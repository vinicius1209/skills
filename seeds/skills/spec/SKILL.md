---
name: spec
description: Stage 2 — generate a SPEC.md from an existing PRD via the architect agent.
disable-model-invocation: true
---

## Pipeline SDD: Stage 2 — SPEC (Technical Specification)

Use the **architect** agent to generate SPEC.md from an existing PRD.

### Feature slug

$1

If `$1` was provided, use it as the slug. Otherwise, locate the most recent PRD in `.claude/plans/`.

### Instructions for architect

1. **Read the PRD entirely** — Scenario Matrix, Navigation Surfaces, and Consistency Anchors must be filled. If missing, stop and go back to PRD.
2. Read applicable `references/*.md`
3. Validate Consistency Anchors by reading the referenced canonical files
4. Check migration timestamps if `@dba` sections will be included:
   ```bash
   ls supabase/migrations/ | tail -3
   ```
   Next timestamp MUST be strictly greater.
5. **SPEC size limit** — if it exceeds **1500 lines**, split into sub-specs:
   ```
   .claude/plans/{slug}/
   ├── manifest.json        (root with index of sub-specs)
   ├── 01-backend/
   │   ├── PRD.md
   │   └── SPEC.md
   ├── 02-admin-ui/
   │   └── ...
   └── 03-integration/
       └── ...
   ```

### Required SPEC Structure

1. **Responsibility summary by agent** (`@dba`, `@dev`, `@tester`)
2. **For each file to CREATE**: path + TypeScript interfaces + pseudo-code + edge cases
3. **For each file to MODIFY**: path + description of change + before/after snippet
4. **For each @dba migration**: full SQL, idempotent, with timestamp validated
5. **Scenario Matrix cross-reference**: for each matrix row, list which files cover it
6. **Implementation checklist** — granular, per agent
7. **Navigation Surfaces checklist** — copied from PRD, ensure no surface is forgotten
8. **Test plan** — coverage for each scenario in the matrix

### Anti-patterns that warrant SPEC rewrite

- Generic SPEC like "use shadcn Dialog" — must cite canonical component file
- Migrations without prior timestamp check
- Scenario Matrix with empty cells (ambiguous)
- SPEC > 1500 lines (split it)
- Missing Navigation Surfaces checklist

### Next step

"SPEC generated at `.claude/plans/{slug}/SPEC.md`. Run `/developer {slug}`. If @dba sections exist, dba will be invoked in parallel."
