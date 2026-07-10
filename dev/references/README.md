# References — Technical Pattern Scaffolds

Canonical, framework-level reference docs for a **React + Supabase +
Feature-Sliced Design** project. They complement the **domain** references in
`seeds/skills/domain-template/references/` (business rules, vocabulary):

- **domain-template/references/** → *what your product does* (business knowledge)
- **these references/** → *how the codebase is built* (architecture & framework patterns)

The seed agents and pipeline skills already cite these filenames, so keeping the
names stable means the references "just work" once you copy them in.

## What's here

| File | Covers |
|------|--------|
| [`query-patterns.md`](query-patterns.md) | TanStack Query: the 4 `staleTime` categories, query-key factory, invalidation scopes, optimistic updates, framework anti-patterns. **Start here — the deepest one.** |
| [`architecture.md`](architecture.md) | FSD layers, import hierarchy, forbidden combos, "where do I put X?" matrix. |
| [`forms.md`](forms.md) | React Hook Form + Zod canon, the reset trap, the numeric-input trap, DO/DON'T. |
| [`dialogs.md`](dialogs.md) | CRUD modal pattern, width guidance, internal-scroll pattern, reset-on-open. |
| [`navigation-surfaces.md`](navigation-surfaces.md) | The "one screen touches N surfaces" checklist (route, nav, settings, breadcrumb, guard, top bar). |
| [`shared-ui-inventory.md`](shared-ui-inventory.md) | A template catalog of shared components — fill it in to prevent reinvention. |

## How to use them

1. **Copy** this folder into your project's references directory (wherever your
   agents look for canonical patterns).
2. **Replace placeholders** with your project's real values:
   - `<alias>` → your path-alias prefix(es)
   - `<entity>` / `<related>` → your real entity names
   - `<canonical-file>` → the file you want new code to mirror
   - `<router-file>`, `<nav-file>`, `<settings-file>`, `<breadcrumb-file>`,
     `<shell-file>` → your project's real files (in `navigation-surfaces.md`)
   - `<your-project>` → your project name
3. **Fill in `shared-ui-inventory.md`** as you build — it ships intentionally
   empty (a template), since every project's component set is different.
4. **Keep them current.** When you establish a new convention, add it to the
   matching reference so the whole agent team follows it.

## A note on the anti-pattern catalogs

The anti-pattern sections in `query-patterns.md` and `forms.md` (unstable hook
return refs, `new Date()` in render, missing `enabled` guards, missing
`disabled={isPending}`, the `type="number"` scientific-notation trap) are
**framework-level React/TanStack truths**, not project-specific configuration.
They are pre-filled and safe to keep as-is in any project on this stack.
