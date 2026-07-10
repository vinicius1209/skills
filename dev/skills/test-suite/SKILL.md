---
name: test-suite
description: Stage 3.5 — generate tests for files altered by the implementation via the tester agent.
disable-model-invocation: true
---

## Pipeline SDD: Stage 3.5 — Post-Implementation Tests

Use the **tester** agent to generate tests for files altered by the implementation.

### Instructions

1. **Identify altered files** — run `git diff --name-only` to list modified/created files
2. **Filter to testable files** — components (`.tsx`), hooks (`use*.ts`), utility functions (`.ts`). Ignore type files, index barrels, and migrations.
3. **Generate tests** following the patterns in `agents/tester.md`:
   - Tests **next to the source file** (e.g., `Component.test.tsx` next to `Component.tsx`)
   - Test names describe behavior ("should display X when Y")
   - Use `renderWithProviders` and `renderHookWithProviders` from test utilities
   - Use test factories for mock data
   - Use mocks for Supabase and edge functions
4. **Prioritize** by layer: `shared/lib/` (unit) > `entities/api/` (hooks) > `features/` (integration)
5. **Run the tests** with `npx vitest run` at the end to validate they pass

### Next step

"Tests generated and validated. Run `/code-review` to review all changes before committing."
