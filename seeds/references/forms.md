# Forms — React Hook Form + Zod

> Reference for any agent (architect / dev) that proposes or implements a form.
> One schema, one resolver, explicit defaults, inline errors, toast only on
> mutation failure. Keep it boring and consistent.

---

## The canon

```tsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod'; // NOT `import { z }` — keep one import style project-wide

const formSchema = z.object({
  name: z.string().min(2, 'Name is required'),
  email: z.string().email('Invalid email').optional().or(z.literal('')),
  quantity: z.coerce.number().min(1, 'Minimum 1'), // HTML inputs are strings → coerce
  active: z.boolean().default(true),
});

type FormData = z.infer<typeof formSchema>;

const DEFAULTS: FormData = { name: '', email: '', quantity: 1, active: true };

export function EntityFormDialog({ open, onOpenChange, entity, onSuccess }) {
  const mutation = useCreateOrUpdate();
  const isPending = mutation.isPending;
  const isEditing = !!entity;

  const {
    register, handleSubmit, reset,
    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(formSchema), // ALWAYS
    defaultValues: DEFAULTS,           // ALWAYS explicit
  });

  // Reset on open and whenever the edited entity changes
  useEffect(() => {
    if (open) reset(entity ? { ...DEFAULTS, ...entity } : DEFAULTS);
  }, [open, entity, reset]); // deps are mandatory — see "reset trap" below

  const onSubmit = (data: FormData) => {
    mutation.mutate(data, {
      onSuccess: () => {
        onOpenChange(false); // local UI only — toast lives in the mutation
        onSuccess?.();
      },
    });
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
      <div className="space-y-2">
        <Label htmlFor="name">Name</Label>
        <Input
          id="name"
          {...register('name')}
          className={errors.name ? 'border-destructive' : ''}
        />
        {errors.name && (
          <p className="text-xs text-destructive">{errors.name.message}</p>
        )}
      </div>

      <div className="flex justify-end gap-2">
        <Button variant="outline" disabled={isPending} onClick={() => onOpenChange(false)}>
          Cancel
        </Button>
        <Button type="submit" disabled={isPending}>
          {isPending && <Spinner className="mr-2 animate-spin" />}
          Save
        </Button>
      </div>
    </form>
  );
}
```

Key points:

- **`import * as z`** everywhere (pick one style, never mix).
- **`zodResolver(schema)`** always — no hand-rolled `onChange` validation.
- **Explicit `defaultValues`** — avoids uncontrolled-input warnings.
- **Reset in `useEffect([open, entity, reset])`** when the form edits an entity.
- **Errors inline** as small destructive text next to the field.
- **Toast only in the mutation's `onError`** — never on field validation.
- **`disabled={isPending}` on both buttons** + a spinner on the primary one.

---

## The reset trap

When a form edits an entity, you must reset the fields when the dialog opens
**and** when the entity changes:

```tsx
useEffect(() => {
  if (open) reset(entity ? { ...DEFAULTS, ...entity } : DEFAULTS);
}, [open, entity, reset]);
```

- Missing `entity` in deps → stale values when switching records.
- Missing `reset` in deps → linter warning; closure may capture an old `reset`.
- Missing the `if (open)` guard → reset fires on every render → wipes user input.

---

## The numeric-input trap (anti-pattern)

A native `<input type="number">` accepts scientific notation by default: users
can type `e`, `E`, `+`, `-`. That lets `1e3`, `+5`, `--` slip into your value and
breaks `valueAsNumber` parsing.

```tsx
// BAD — accepts "1e3", "+5", "--"
<input type="number" {...register('quantity', { valueAsNumber: true })} />

// GOOD (inline) — block the offending keys
<Input
  type="number"
  inputMode="decimal"
  step="0.01"
  onKeyDown={(e) => { if (['e','E','+','-'].includes(e.key)) e.preventDefault(); }}
  {...register('quantity', { valueAsNumber: true })}
/>

// BEST — wrap it once in a shared component and reuse everywhere
<NumericInput min={0} {...register('quantity', { valueAsNumber: true })} />
```

Prefer a shared `NumericInput` (and a `CurrencyInput` for money) so the guard
lives in one place. See `shared-ui-inventory.md`.

---

## DO / DON'T

**DO**

- `import * as z from 'zod'`
- `zodResolver(schema)` in `useForm`
- Explicit `defaultValues`
- Reset in `useEffect([open, entity, reset])` when editing
- Inline errors as small destructive text
- Toast only in mutation `onError`
- `disabled={isPending}` on submit **and** cancel
- Spinner on the primary button while saving
- Format values for **display only** — keep raw values in the form

**DON'T**

- Mix `import { z }` and `import * as z`
- Validate in ad-hoc `onChange` handlers instead of the schema
- Mix controlled (`value=`) and uncontrolled (`register`) on the same field
- Toast in both `onSubmit` and the mutation (duplicate message)
- Reset without the dependency array (resets on every render)
- Use a bare `<input type="number">` without blocking `e/E/+/-`
- Put a formatted/masked string into the form value (store the raw value)
