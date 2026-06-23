## Pipeline SDD: Stage 4 — Code Review

Use the **code-review** agent to review uncommitted changes and persist
verification results in the manifest.

### Instructions

1. **Analyze all modified files** — staged and unstaged
2. **Follow the review checklist** in `agents/code-review.md` — path aliases, TanStack Query patterns, edge functions, migration idempotency, RLS, shadcn/ui, formatters, user-facing text language
3. **Classify issues** by severity: Red Critical, Yellow Important, Orange Warning
4. **Be concise** — report only real issues. Don't suggest refactoring outside the change scope.
5. **Run quality checks** explicitly (output used in step 6):

   ```bash
   # Tests in the altered scope
   npx vitest run $(git diff --name-only --diff-filter=AM | grep -E '\.(test|spec)\.(ts|tsx)$' | tr '\n' ' ') 2>&1 | tail -5

   # Global type check
   npx tsc --noEmit

   # Lint altered files
   npx eslint $(git diff --name-only --diff-filter=AM | grep -E '\.(ts|tsx)$' | tr '\n' ' ') --quiet
   ```

   Consider: `tests_passing=true` if vitest exit code 0; `type_check_passing=true` if tsc exit code 0; `lint_passing=true` if eslint exit code 0. `build_passing` — only run `npm run build` if the change affects build config, deps, or public assets; otherwise inherit from `type_check_passing && lint_passing`.

### Step 6 — Persist verification in manifest (if it exists)

Detect the branch and locate the manifest:

```bash
BRANCH=$(git branch --show-current)
SLUG=${BRANCH#feature/}
SLUG=${SLUG#fix/}
MANIFEST=".claude/plans/${SLUG}/manifest.json"

if [ -f "$MANIFEST" ]; then
  jq '
    .verification.tests_passing = $tests
    | .verification.type_check_passing = $typeck
    | .verification.build_passing = $build
    | .stage = (if .stage == "done" then "done" else "review" end)
    | .stages_completed = ((.stages_completed // []) + ["review"] | unique)
  ' "$MANIFEST" > "$MANIFEST.tmp" && mv "$MANIFEST.tmp" "$MANIFEST"
fi
```

### Step 7 — QA smoke gate (warning, non-blocking)

If the manifest exists, check the promised scenario matrix:

```bash
if [ -f "$MANIFEST" ]; then
  HAS_MATRIX=$(jq '(.promised_in_spec.scenario_matrix // []) | length > 0' "$MANIFEST")
  VALIDATED=$(jq '.verification.scenarios_validated' "$MANIFEST")

  if [ "$HAS_MATRIX" = "true" ] && [ "$VALIDATED" != "true" ]; then
    echo "Scenario Matrix present but not validated (verification.scenarios_validated != true)."
    echo "Recommended to run before PR:"
    echo "  /qa-smoke ${SLUG}"
    echo "(does not block commit — warning only)"
  fi
fi
```

### Next step

"Review complete. Verification persisted in manifest (`tests=…`, `type_check=…`). Fix Red Critical issues (if any). If the qa-smoke warning appeared above, run `/qa-smoke {slug}` before proceeding. Then run `/commit` or `/pr`."
