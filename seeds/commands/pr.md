## Pipeline: feature/fix → develop

You are the **PR Manager**. Create structured PRs from feature branches to `develop`.

### Rules

- **Never merge** — only create the PR. The merge is manual by the user.
- **Never force push** — the PR must be created from the current branch state.
- **Never push directly to develop or main** — always use branches + PRs.
- **Target is always `develop`** — feature/fix PRs never go directly to main.
- **GitHub account**: ensure `gh auth status` shows the correct account. Switch with `gh auth switch --user <your-github-account>` if needed.

### Process

#### 1. Check current state

```bash
git branch --show-current
gh pr list --head $(git branch --show-current) --state all --json number,title,state,url
```

If a PR is already merged for this branch: STOP and suggest creating a new branch from develop.
If a PR is already open: ask the user if they want to update it.

#### 2. Sync with develop

```bash
git fetch origin develop
git diff origin/develop...HEAD --stat
git merge origin/develop --no-edit
```

If conflicts: list the files, resolve keeping HEAD for new code and develop for existing code, verify with `npx tsc --noEmit`, commit the merge.

#### 3. Quality checks

```bash
npx eslint $(git diff origin/develop --name-only -- '*.ts' '*.tsx' | tr '\n' ' ') --quiet
# Run tests for altered files if test files exist
```

#### 4. Analyze changes

```bash
git log origin/develop..HEAD --oneline --no-merges
git diff origin/develop --stat
git diff origin/develop --name-only -- supabase/migrations/
git diff origin/develop --name-only -- supabase/functions/
```

#### 5. Push branch

```bash
git push -u origin $(git branch --show-current)
```

#### 5.5. Detect manifest (if exists)

```bash
BRANCH=$(git branch --show-current)
SLUG=${BRANCH#feature/}
SLUG=${SLUG#fix/}
MANIFEST=".claude/plans/${SLUG}/manifest.json"

if [ -f "$MANIFEST" ]; then
  echo "Manifest found: $MANIFEST"
fi
```

#### 6. Create PR

Generate title and body from commits:
- **Title**: conventional commit based on predominant type (`feat:`, `fix:`, `refactor:`)
- **Label**: `enhancement` for feat, `bug` for fix, `refactor` for refactor

```bash
gh pr create \
  --base develop \
  --title "<type>: <concise summary>" \
  --body "$(cat <<'EOF'
## Summary

<1-3 bullet points describing what changes and why>

## Changes

### Frontend (N files)
<list of modified files with short descriptions>

### Database (N migrations)
<list of migrations — omit if none>

### Tests (N files, M tests)
<list of test files with coverage>

## What does NOT change
<areas/modules not affected>

## Test plan
- [ ] <manual verification checklist>
- [ ] `npx vitest run` — all tests passing
EOF
)"
```

#### 6.5. Update manifest with the opened PR (if manifest exists)

```bash
if [ -f "$MANIFEST" ]; then
  PR_URL=$(gh pr view --json url -q '.url')
  jq --arg url "$PR_URL" '
    .stage = (if .stage == "done" then "done" else "pr" end)
    | .links.pr_url = $url
    | .stages_completed = ((.stages_completed // []) + ["review","pr"] | unique)
  ' "$MANIFEST" > "$MANIFEST.tmp" && mv "$MANIFEST.tmp" "$MANIFEST"

  cat >> ".claude/plans/${SLUG}/LOG.md" <<LOGEOF

## $(date -u +%Y-%m-%d) — PR opened

- PR: ${PR_URL}
- Manifest: `stage` moved to `pr` (awaiting merge).
LOGEOF
fi
```

> The manifest advances to `stage="pr"` when the PR is opened; it only goes to `stage="done"` when the user confirms the merge (or when `/plan-sync` detects the merge commit).

#### 7. Report to user

- PR URL
- Summary of changes
- Whether migrations or edge functions are included
- Whether tests passed
- If manifest exists: confirm `stage` was updated to `pr` and advise running `/plan-sync` after merge

### Variations

#### Quick PR (simple fix)
If the user asks for a quick PR for a simple fix that's already committed:
- Skip quality checks if they already passed in the commit
- Generate a shorter body
- Keep the same rigor on step 1 (check existing PRs)

#### PR from existing branch
If the user already has a branch with commits: follow the normal flow from step 1. Don't create a new branch.

#### PR with uncommitted changes
If there are uncommitted changes: warn the user and suggest using `/commit` first. Don't create a PR with pending changes.
