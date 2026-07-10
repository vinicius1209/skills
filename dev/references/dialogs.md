# Dialogs — CRUD Modals

> Reference for any agent (architect / dev) implementing a create/edit modal.
> Pick one modal pattern and standardize it. Consistency beats cleverness here.

---

## Pick ONE pattern (and stick to it)

Two common approaches for CRUD:

| Pattern | Feels like | Good for |
|---------|-----------|----------|
| **Centered `Dialog`** | Blocking modal in the middle | Focused, form-first CRUD. Many teams standardize on this for CRUD. |
| **Side `Sheet` / drawer** | Slides in from the edge | Filters, detail drilldowns, contextual side panels. |

This is a **choice, not a mandate** — but make it once per project and apply it
everywhere. Mixing both for the same kind of task (e.g. some entity forms in a
Dialog, others in a Sheet) is the thing to avoid. A frequent default is: **Dialog
for CRUD forms, Sheet for filters/drilldowns.** Record your project's choice and
point new screens at `<canonical-file>`.

---

## Width guidance

Scale the width to field count, not gut feeling:

| Fields | Suggested width |
|--------|-----------------|
| Few (< ~7) | narrower (e.g. `~600px`) |
| Many (≥ ~7) | wider (e.g. `~700px`) |

Avoid going too narrow — cramped two-column forms read worse than a slightly
wider modal. Pick two width tokens for the project and reuse only those.

---

## Internal scroll pattern

When fields exceed the viewport, scroll the **body**, not the whole dialog. Keep
the header and the footer actions **outside** the scroll area so Save/Cancel are
always reachable.

```tsx
<DialogContent className="sm:max-w-[700px]">
  <DialogHeader>
    <DialogTitle>{isEditing ? 'Edit entity' : 'New entity'}</DialogTitle>
    <DialogDescription>
      {isEditing ? 'Update the details.' : 'Create a new record.'}
    </DialogDescription>
  </DialogHeader>

  <form onSubmit={handleSubmit(onSubmit)} className="flex flex-col gap-4">
    {/* SCROLLABLE BODY — only the fields scroll */}
    <div className="max-h-[70vh] overflow-y-auto pr-2 space-y-6">
      {/* fields, sections, separators */}
    </div>

    {/* FIXED FOOTER — outside the scroll area, always visible */}
    <DialogFooter className="gap-2">
      <Button variant="outline" disabled={isPending} onClick={() => onOpenChange(false)}>
        Cancel
      </Button>
      <Button type="submit" disabled={isPending}>
        {isPending && <Spinner className="mr-2 animate-spin" />}
        Save
      </Button>
    </DialogFooter>
  </form>
</DialogContent>
```

Common mistake: putting `max-h-* overflow-y-auto` on the whole `DialogContent`.
That scrolls the title and footer away. Put it on the body wrapper only.

---

## Reset form state on open

A reused dialog instance keeps stale values from the previous record. Reset when
it opens and when the edited entity changes (see `forms.md` for the full pattern):

```tsx
useEffect(() => {
  if (open) reset(entity ? { ...DEFAULTS, ...entity } : DEFAULTS);
}, [open, entity, reset]);
```

---

## DO / DON'T

**DO**

- Use the one modal pattern your project standardized on for CRUD
- Always render a description line (helps screen readers + clarifies create vs edit)
- Size width by field count (two tokens, reused)
- Scroll the body; keep header/footer outside the scroll
- Reset form state on `open` and on `entity` change
- `disabled={isPending}` on both buttons + spinner on Save
- Toast in the mutation, not in the submit handler
- Follow the project's reference dialog: `<canonical-file>`

**DON'T**

- Mix Dialog and Sheet for the same kind of CRUD task
- Put `overflow-y-auto` on the whole modal (scrolls away the actions)
- Float the footer inside the scroll area
- Skip the description line
- Forget to reset → previous record's data leaks into the form
- Duplicate the success toast in both submit and mutation

---

## Checklist (paste into the spec when proposing a new dialog)

- [ ] Modal pattern matches the project standard (Dialog vs Sheet)
- [ ] Width chosen from the project's two tokens, by field count
- [ ] Internal scroll on the body; header + footer outside it
- [ ] Description line present (create vs edit)
- [ ] Form resets on `open` and on `entity` change
- [ ] Both buttons `disabled={isPending}`; spinner on Save
- [ ] Toast in mutation only
- [ ] Mirrors the reference example: `<canonical-file>`
