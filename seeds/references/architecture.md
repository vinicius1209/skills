# Architecture — Feature-Sliced Design (FSD)

> Reference for any agent (architect / dev) deciding **where new code goes**.
> FSD keeps imports flowing one direction so the app stays modular and testable.

---

## Layers

From most generic (bottom) to most specific (top):

| Layer | Responsibility |
|-------|----------------|
| `app` | Bootstrap: providers, global config, the root component. |
| `pages` | Route entries — thin, compositional; orchestrate one feature + widgets. |
| `widgets` | Composed, route-agnostic UI blocks (layout, data table, board view). |
| `features` | Domain-specific workflows and business logic (forms, multi-step flows). |
| `entities` | Domain entities with their data layer (CRUD hooks + types). |
| `shared` | Domain-agnostic primitives (UI kit, hooks, lib, api client, config). |
| `integrations` | Adapters/generated code for external systems (DB types, API clients). |

---

## Import hierarchy

A layer may only import from layers **below** it. This is the whole point of FSD.

| Layer | May import from |
|-------|-----------------|
| `shared` | nothing (it is the base) |
| `entities` | `shared` |
| `features` | `shared`, `entities` |
| `widgets` | `shared`, `entities`, `features` (components only) |
| `pages` | everything |
| `integrations` | `shared`, `entities` |
| `app` | everything |

`pages` is the only layer that may compose freely — and it **exports nothing**
(pages are consumed only by the router).

---

## Forbidden combinations

| Forbidden | Why |
|-----------|-----|
| `feature → feature` | Couples sibling features; extract the shared part down a layer. |
| `entity ← feature / widget / page` | Inverts the hierarchy; entities must not know about callers. |
| `shared ← anything above it` | `shared` is the base; importing upward breaks the entire model. |
| `widget ← page` | Widgets are route-agnostic; they cannot depend on a specific route. |
| Bypassing a slice's public API | Reaching into `<alias>/features/X/components/internal` instead of the slice's `index` barrel couples you to internals. Import only from the barrel. |
| Relative cross-slice imports (`../../`) | Use path aliases; relative climbs hide layer violations. |

**Public API rule**: every slice exposes a single `index` barrel. Consumers
import `from '<alias>/features/X'`, never from a file deep inside it.

---

## "Where do I put X?" decision matrix

| What you're building | Goes in |
|----------------------|---------|
| A reusable button / input / generic UI primitive | `shared/ui` |
| A pure helper / formatter (no domain knowledge) | `shared/lib` |
| A domain-agnostic hook (debounce, media query) | `shared/hooks` |
| A CRUD hook + types for one domain entity | `entities/<entity>` |
| The TypeScript Row/Insert/Update types of an entity | `entities/<entity>/model` |
| A multi-step business workflow / domain form | `features/<feature>` |
| A hook that calls a mutation + drives UI logic | `features/<feature>/hooks` |
| A composed UI block reused across routes (dashboard block, table) | `widgets/<widget>` |
| A route entry that wires a feature to a URL | `pages/<page>` |
| Generated external types / external API adapter | `integrations/<system>` |

Tie-breakers:

- Reused by **2+ features** and domain-agnostic → push down to `shared` or `widgets`.
- Used by only **one feature** → keep it inside that feature.
- Pure CRUD + types, no business rules → `entities`.
- Orchestrates multiple entities or encodes business rules → `features`.

---

## Path aliases

Configure these in your bundler/tsconfig so cross-slice imports never use `../../`:

```
<alias>/shared        → src/shared
<alias>/entities      → src/entities
<alias>/features      → src/features
<alias>/widgets       → src/widgets
<alias>/pages         → src/pages
<alias>/integrations  → src/integrations
```

Replace `<alias>` with your project's prefix (e.g. `@`, `@app`, or a per-layer
alias like `@shared`/`@entities`).

---

## Checklist for new code

- [ ] Correct layer chosen (use the decision matrix)
- [ ] Not duplicating something that already exists in `shared/ui` (check the inventory)
- [ ] Imports respect the hierarchy (no upward / no sibling-feature imports)
- [ ] Path aliases used (no `../../` across slices)
- [ ] Slice exposes its public API via an `index` barrel; consumers import only from it
