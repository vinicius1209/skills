## SDD Pipeline — Feature End-to-End

You are the **orchestrator** of the SDD pipeline. Execute all stages automatically
using specialized agents (each runs in isolated context window).

### Feature requested

$1

### Execution Flow

Execute sequentially. Each agent gets its own context window — no need to `/clear` between stages.

---

#### Stage 0: Setup

1. Generate a `{slug}` from the description (e.g., "notification system" → `notification-system`).
2. Create branch `feature/{slug}` from develop (updated).
3. Create the `.claude/plans/{slug}/` directory.
4. **Initialize `manifest.json`** by copying from `.claude/plans/_manifest.template.json` and filling in `slug`, `title`, `branch`, `created_at`:
   ```bash
   cp .claude/plans/_manifest.template.json .claude/plans/{slug}/manifest.json
   # edit slug, title, branch, created_at
   ```
5. Initialize `LOG.md`:
   ```markdown
   # Log: {slug}
   > Feature: $1
   > Started: {date/time}
   > Branch: feature/{slug}
   > Manifest: .claude/plans/{slug}/manifest.json

   ## Stages
   ```

**Smart shortcut**: Before creating everything, check if `.claude/plans/{slug}/manifest.json` already exists. If so, read the `stage` and **skip completed stages**. Ask the user if they want to continue from where it stopped or restart.

---

#### Stage 1: PRD (agent: architect)

Use the **Task tool with subagent_type=architect** to:
- Investigate the codebase for components, hooks, queries, mutations, edge functions, and migrations related to the scenario.
- Use the **dba** agent (in parallel) if the scenario involves database entities.
- Generate `PRD.md` and save to `.claude/plans/{slug}/PRD.md`.
- Delimit scope with an "Out-of-scope" section.

After generating, **update the `manifest.json`**:
```jsonc
{
  "stage": "prd",
  "stages_completed": ["discovery"],
  "artifacts": {
    "prd": { "path": "PRD.md", "approved": false, "approved_at": null }
  }
}
```
And **log in LOG.md**:
```
- [x] **PRD** — generated at `.claude/plans/{slug}/PRD.md`
```

**Approval gate**: Present to the user a PRD summary (objectives, **Scenario Matrix**, **Navigation Surfaces enumerated**, in-scope/out-of-scope). Ask if they approve proceeding. If approved, update `manifest.json.artifacts.prd.approved = true` and `approved_at`.

---

#### Stage 2: SPEC (agent: architect)

Use the **Task tool with subagent_type=architect** to:
- Read the PRD.md generated in the previous stage.
- Generate `SPEC.md` and save to `.claude/plans/{slug}/SPEC.md`.
- Separate clearly `@dev` (frontend) and `@dba` (database/migrations/RLS) sections.
- Detail interfaces, types, imports, pseudo-code, and edge cases.
- Include an implementation checklist.

After generating, **log in LOG.md**:
```
- [x] **SPEC** — generated at `.claude/plans/{slug}/SPEC.md`
```

---

#### Stage 3: Implementation (agents: dev + dba)

Use the **Task tool with subagent_type=dev** to:
- Read the SPEC.md and implement all sections marked as `@dev`.

If the SPEC contains `@dba` sections, use the **Task tool with subagent_type=dba** **in parallel** to:
- Create migrations, RLS policies, database functions, and triggers.
- **NEVER run `supabase db push --linked`** — migrations are applied to the remote database only by CI after merge to develop/main. During development, use `--local` only.

After implementing, **log in LOG.md**:
```
- [x] **Implementation** — {N} files created, {M} modified
```

---

#### Stage 4: Tests (agent: tester)

Use the **Task tool with subagent_type=tester** to:
- Identify altered files via `git diff --name-only`.
- Generate tests following the project's testing patterns.
- Test files next to source, using test factories and mocks.
- Run `npx vitest run` to validate.

After generating, **log in LOG.md**:
```
- [x] **Tests** — {N} test files generated, all passing
```

If any test fails, fix and re-run before proceeding.

---

#### Stage 5: Code Review (agent: code-review)

Use the **Task tool with subagent_type=code-review** to:
- Review all modified files (staged + unstaged).
- Classify by severity: Red Critical, Yellow Important, Orange Warning.

If there are Red Critical items, **fix them before proceeding** (use the dev or dba agent as needed).

After a clean review, **log in LOG.md**:
```
- [x] **Code Review** — approved ({N} warnings, 0 critical)
```

The **code-review** agent should also persist `verification.{tests_passing, type_check_passing, build_passing}` in the `manifest.json`.

---

#### Stage 5.5: QA Smoke (if Scenario Matrix is non-empty)

After code review, check the manifest's Scenario Matrix:

```bash
MANIFEST=".claude/plans/{slug}/manifest.json"
HAS_MATRIX=$(jq '(.promised_in_spec.scenario_matrix // []) | length > 0' "$MANIFEST")
```

If `HAS_MATRIX=true`, use the **Task tool with subagent_type=qa-smoke** to:
- Read `manifest.promised_in_spec.scenario_matrix` and generate Playwright smoke tests for each scenario (persona × input × ui × backend).
- Execute and report results.
- Persist `verification.scenarios_validated = true/false` in the manifest.

After running (or skipping with user justification), **log in LOG.md**:
```
- [x] **QA Smoke** — {N} scenarios, {M} passing ({skipped: reason})
```

---

#### Stage 6: Commit

1. Stage all relevant files (excluding `.env`, credentials, etc.).
2. Create a conventional commit:
   - `feat({scope}): {concise description}` for new features
   - `fix({scope}): {description}` for fixes
3. **Log in LOG.md**:
```
- [x] **Commit** — `{short hash}` on branch `feature/{slug}`
```

---

#### Stage 7: Push & Pull Request

1. Ensure `gh` CLI is authenticated with the correct account:
   ```bash
   gh auth switch --user <your-github-account>
   ```

2. Push the branch to remote:
   ```bash
   git push -u origin feature/{slug}
   ```

3. Create the PR to `develop` with a structured body (summary, changes, what doesn't change, test plan).

4. Verify CI after creation:
   ```bash
   sleep 10
   gh pr checks {PR_NUMBER}
   ```
   If any check fails, investigate and fix before reporting to the user.

5. **Update the manifest** with the opened PR:
   ```bash
   PR_URL=$(gh pr view --json url -q '.url')
   jq --arg url "$PR_URL" '
     .stage = (if .stage == "done" then "done" else "pr" end)
     | .links.pr_url = $url
     | .stages_completed = ((.stages_completed // []) + ["review","pr"] | unique)
   ' "$MANIFEST" > "$MANIFEST.tmp" && mv "$MANIFEST.tmp" "$MANIFEST"
   ```

6. **Log in LOG.md**:
   ```
   - [x] **Pull Request** — {PR URL}
   - [x] **Manifest** — stage updated to `pr` (awaiting merge)
   ```

7. Finalize LOG.md:
   ```
   ## Result
   > Completed at: {date/time}
   > Commit: {hash}
   > Branch: feature/{slug}
   > PR: {PR URL}
   ```

---

### General Rules

- **Never skip stages** — even if it seems simple, follow the full flow.
- **Keep LOG.md updated** — log each stage as soon as it completes.
- **Only approval gate** — after the PRD (Stage 1). Other stages are automatic.
- **If an agent fails**, log the error in LOG.md, try to fix once, and if it persists, stop and report to the user.
