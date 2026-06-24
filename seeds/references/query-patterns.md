# TanStack Query — Canonical Patterns

> Reference for any agent (architect / dev) that defines queries or mutations.
> This is the most consequential reference: getting `staleTime`, query keys, and
> invalidation right is what keeps a React + Query app fast and bug-free.
>
> Suggested global config (set once where you create the `QueryClient`):
> `staleTime: 5min`, `gcTime: 10min`, `refetchOnWindowFocus: false`.

---

## The 4 staleTime categories

Pick the category first, then the number follows. Every `useQuery` in the app
should map to exactly one of these.

### 1. Global / catalog data — `staleTime: 5min` (the default)

Data that rarely changes and is shared across many screens (lookup lists,
catalogs, reference tables, settings read across the app).

```ts
useQuery({
  queryKey: keys.<entity>.list(filters),
  queryFn: () => fetchList(filters),
  staleTime: 5 * 60 * 1000,
  gcTime: 10 * 60 * 1000,
});
```

- **Invalidate**: after any mutation that creates/updates/deletes an item in this category.
- **Why 5min**: cheap to serve from cache; freshness within minutes is fine.

### 2. Form-internal dynamic data — `staleTime: Infinity`

Queries that resolve values *in response to form inputs* (a computed value, an
autocomplete inside a form, a derived lookup). These must **not** silently change
under the user mid-edit.

```ts
const result = useQuery({
  queryKey: [...keys.<entity>.resolve, debouncedInputs],
  queryFn: () => resolve(debouncedInputs),
  enabled: !!requiredInput,
  staleTime: Infinity, // queryKey changes when inputs change → natural refetch
});

// ALWAYS memoize the returned shape (see Anti-pattern 1):
return useMemo(
  () => ({ data: result.data, isLoading: result.isLoading, isError: result.isError }),
  [result.data, result.isLoading, result.isError],
);
```

- **Why Infinity**: if someone edits the underlying data in another tab while the
  form is open, the form value should not "jump". The query key carries the
  inputs, so changing an input still triggers a fresh fetch.

### 3. Detail of a saved entity — `staleTime: 5min` or `Infinity`

Fetching a single saved entity to display or edit.

```ts
useQuery({
  queryKey: keys.<entity>.detail(id),
  queryFn: () => fetchOne(id),
  enabled: !!id,
  staleTime: 5 * 60 * 1000, // read-only / short edits
});
```

- **5min** for read-only views or short edits.
- **`Infinity`** for long edit sessions where a background refetch would
  **overwrite the user's unsaved changes**. In that case invalidate explicitly
  after save instead of relying on staleness.

### 4. Live / polling badge — short `staleTime` (30s) + `refetchInterval` (60s)

Global indicators that must reflect change "fast enough" without realtime
sockets (unread counts, pending-approval badges, sync status).

```ts
useQuery({
  queryKey: keys.<entity>.badgeCount(),
  queryFn: () => fetchCount(),
  staleTime: 30_000,        // absorb refetch on quick remounts (menu hover, tab switch)
  refetchInterval: 60_000,  // bound staleness to ~1min
  refetchOnWindowFocus: true,
});
```

- **Use for**: small counts/indicators in a global shell, high read volume, where
  ~30-60s lag is acceptable.
- **Don't use for**: lists (category 1), open detail views (category 3), or forms
  in edit (category 2).
- **Backend tip**: back the count with an index so the `COUNT` stays cheap.

### Quick picker

| Situation | Category | staleTime |
|-----------|----------|-----------|
| Lookup list / catalog shared across screens | 1 | `5min` |
| Value resolved from form inputs | 2 | `Infinity` |
| Detail view, read-only or short edit | 3 | `5min` |
| Detail view, long edit session | 3 | `Infinity` (invalidate on save) |
| Topbar count / status badge | 4 | `30s` + `refetchInterval 60s` |

---

## Query-key factory

Centralize all keys in one module (e.g. `<alias>/api/query-keys.ts`). Never write
keys inline at the call site. Keys are hierarchical so you can invalidate at any
level.

```ts
export const keys = {
  <entity>: {
    all: ['<entity>'] as const,
    list: (filters?: <Entity>Filters) =>
      [...keys.<entity>.all, 'list', filters] as const,
    detail: (id: string) =>
      [...keys.<entity>.all, 'detail', id] as const,
    paginated: (filters?: <Entity>Filters, page?: number, size?: number) =>
      [...keys.<entity>.all, 'paginated', filters, page, size] as const,
  },
} as const;
```

Why a factory:

- One source of truth — rename/restructure once.
- Hierarchy enables scoped invalidation (`keys.<entity>.all` covers every
  list/detail/paginated key under it).
- `as const` preserves literal types for safer matching.

---

## Invalidation scopes

**Rule: invalidate the narrowest key that fully covers the change.** Over-broad
invalidation wastes refetches; too-narrow leaves stale UI.

```ts
// Narrowest — one detail changed
queryClient.invalidateQueries({ queryKey: keys.<entity>.detail(id) });

// Scope — anything about this entity (lists + details + paginated)
queryClient.invalidateQueries({ queryKey: keys.<entity>.all });

// Cross-entity — a change here also affects another entity's views
await Promise.all([
  queryClient.invalidateQueries({ queryKey: keys.<entity>.all }),
  queryClient.invalidateQueries({ queryKey: keys.<related>.all }),
]);
```

Decision guide:

| You changed... | Invalidate |
|----------------|-----------|
| One record, only its detail is on screen | `detail(id)` |
| One record, but it appears in lists too | `<entity>.all` |
| A record that another entity's views derive from | both entities' `.all` |

---

## Mutations

### Base pattern

```ts
export const useCreate<Entity> = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (input: <Entity>Input) => create(input),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: keys.<entity>.all });
      toast.success('Saved');
    },
    onError: (error: Error) => {
      toast.error(error.message ?? 'Something went wrong');
    },
  });
};
```

- Toast for the entity lives in the mutation (`onSuccess`/`onError`).
- Component-local effects (close dialog, navigate) go in the per-call callback so
  the toast is not duplicated:

```ts
mutation.mutate(payload, {
  onSuccess: () => { onOpenChange(false); onSuccess?.(); },
});
```

### Optimistic update template

Use only when the operation is fast, likely to succeed, and UX-critical (toggle,
reorder, like). Avoid for risky create/delete or complex forms.

```ts
useMutation({
  mutationFn: (next) => save(next),
  onMutate: async (next) => {
    await queryClient.cancelQueries({ queryKey: keys.<entity>.all });
    const previous = queryClient.getQueryData(keys.<entity>.list());
    queryClient.setQueryData(keys.<entity>.list(), (old) => applyOptimistic(old, next));
    return { previous };           // rollback context
  },
  onError: (_err, _next, ctx) => {
    if (ctx?.previous) queryClient.setQueryData(keys.<entity>.list(), ctx.previous);
  },
  onSettled: () => {
    queryClient.invalidateQueries({ queryKey: keys.<entity>.all }); // reconcile with server
  },
});
```

---

## Anti-patterns (framework-level — safe to keep as-is)

These are React/TanStack truths, not project-specific. Each has bitten real apps.

### 1. Returning a fresh object/array from a query hook every render

A custom hook that returns `{ data, isLoading, ... }` creates a **new object
reference** every render. If a consumer puts that object in a `useEffect`
dependency array, the effect runs forever.

```ts
// BAD — new ref each render
const state = use<Entity>State();
useEffect(() => { /* ... */ }, [state]); // loops

// GOOD — depend on scalars
useEffect(() => { /* ... */ }, [state.items, state.total]);

// GOOD — memoize the hook's return so its ref is stable
return useMemo(() => ({ items, total }), [items, total]);
```

### 2. `new Date()` / `Math.random()` during render or in `setState` init

Calling impure functions during render (or inside `setState({ at: new Date() })`
in an effect) produces a new value every pass → re-render → effect re-runs → loop.

```ts
// BAD — runs every effect pass, never settles
useEffect(() => { setState((s) => ({ ...s, at: new Date() })); }, [trigger]);

// GOOD — idempotency guard via ref
const lastRef = useRef<string | null>(null);
useEffect(() => {
  if (lastRef.current === trigger) return;
  lastRef.current = trigger;
  setState((s) => ({ ...s, at: new Date().toISOString() }));
}, [trigger]);
```

### 3. Missing `enabled` guard on a dependent query

A query whose `queryFn` needs a value that can be `undefined` will fire with a
bad argument (often a 4xx/5xx) before the dependency exists.

```ts
// BAD — runs with id === undefined
useQuery({ queryKey: keys.<entity>.detail(id), queryFn: () => fetchOne(id) });

// GOOD — gate on the dependency
useQuery({
  queryKey: keys.<entity>.detail(id),
  queryFn: () => fetchOne(id!),
  enabled: !!id,
});
```

### 4. Forms: missing `disabled={isPending}` on submit/cancel

Without it, a fast double-click fires the mutation twice (duplicate writes).

```tsx
<Button type="submit" disabled={mutation.isPending}>
  {mutation.isPending && <Spinner className="mr-2 animate-spin" />} Save
</Button>
<Button variant="outline" disabled={mutation.isPending}>Cancel</Button>
```

---

## Checklist

- [ ] Key defined in the central factory (never inline)
- [ ] `staleTime` chosen by category (5min / Infinity / 5min|Infinity / 30s+poll)
- [ ] `enabled` set when the query has optional/dependent inputs
- [ ] Form-internal hooks return a `useMemo`-ed object
- [ ] Mutation `onSuccess` invalidates the narrowest covering key
- [ ] Mutation `onError` surfaces a descriptive toast
- [ ] Submit/cancel buttons `disabled` while pending
- [ ] Effects reading query data depend on scalars, not the hook's return object
- [ ] No `new Date()` / `Math.random()` in render or unguarded `setState`
