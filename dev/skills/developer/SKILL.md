---
name: developer
description: Stage 3 — implement an existing SPEC via the dev (and dba) agents.
disable-model-invocation: true
---

## Pipeline SDD: Stage 3 — Implementation

Use the **dev** agent to implement an existing SPEC.

### Feature slug

$1

If `$1` was provided, use it as the slug to locate `.claude/plans/{slug}/SPEC.md`. Otherwise, locate the most recent `SPEC.md` in `.claude/plans/`.

### Instructions

1. **Read the SPEC.md** as implementation guide
2. If the SPEC contains sections marked `@dba` (migrations, RLS policies, database functions), use the **dba** agent **in parallel** to create the database changes
3. Follow project patterns defined in `agents/dev.md` — path aliases, TanStack Query, shadcn/ui, formatters, user-facing text language
4. Implement in the checklist order from the SPEC — respect dependencies between files
5. Avoid duplicate migrations — check `supabase/migrations/` before creating new ones
6. **NEVER** run `supabase db push --linked` — migrations are applied to the remote database only by CI after merge to develop/main. Use `--local` during development.

### Next step

"Implementation complete. Run `/test-suite` to generate tests for the altered files, or `/code-review` to review directly."
