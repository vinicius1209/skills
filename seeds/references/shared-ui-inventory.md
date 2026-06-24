# Shared UI Inventory

> **Before building a new shared component, check this inventory.** If something
> reusable already exists, use it. This file is the project's catalog of shared
> UI — the single place to look before reinventing a button, combobox, or card.

This is a **template**. Fill the table with your project's real components as you
build them. Keep it current: every new component added to your shared UI layer
should get a row here.

---

## Inventory

| Component | Import path | Use for | Notes |
|-----------|-------------|---------|-------|
| `<Component>` | `<alias>/ui/<component>` | `<what it's for>` | `<gotchas, props, "use this instead of X">` |
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |

---

## How to use this inventory

- **Before creating a component**, scan the table for something that already
  covers the need (possibly with an extra prop).
- **When you add a shared component**, add a row here in the same change.
- **When a feature component gets reused by a second feature**, that's the signal
  to promote it down to the shared layer — and record it here.

## When a component belongs in shared UI

A component goes in the shared UI layer when **all** of these hold:

- It is reused by 2+ features (or clearly will be).
- It is domain-agnostic (no business rules baked in).
- It has no direct side effects (data changes flow in via callbacks/props).

If it's used by only one feature, keep it inside that feature until a second
consumer appears.

## Guidelines for new shared components

1. Consistent file naming (pick one convention, e.g. kebab-case).
2. Named export with a typed `Props` interface.
3. Re-export from the shared UI barrel so consumers import from the public API.
4. A short doc comment: primary use case + key props.
5. No side effects — mutations/data changes come through callbacks.
6. Accessible: labels, roles, keyboard navigation where relevant.
