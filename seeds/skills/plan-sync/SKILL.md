---
name: plan-sync
description: Syncs stale manifests (PR merged but stage != done) with the real git state.
disable-model-invocation: true
---

Updates manifests in `.claude/plans/*/` whose PR was merged but `stage` is still in-progress.

## Process

1. **Scan** `.claude/plans/*/manifest.json` for stale plans:

   ```bash
   for m in .claude/plans/*/manifest.json; do
     stage=$(jq -r '.stage // ""' "$m")
     case "$stage" in
       done|cancelled|abandoned|"") continue ;;
     esac
     slug=$(jq -r '.slug // ""' "$m")
     [ -z "$slug" ] && continue
     merge=$(git log --merges --oneline | grep -E "feature/${slug}$|feature/${slug} |fix/${slug}$|fix/${slug} " | head -1)
     if [ -n "$merge" ]; then
       echo "STALE: $slug (stage=$stage) → $merge"
     fi
   done
   ```

2. **Present the list** to the user with:
   - slug
   - current stage
   - PR number (extracted from "pull request #N")
   - merge commit (short SHA)
   - merge date

3. **Confirm before applying** — ask: *"Update the N manifests to stage=done?"*

4. **For each confirmed stale plan**, edit the manifest preserving all other fields:
   - `stage: "done"`
   - `merged_at: "<ISO date of merge commit>"`
   - `stages_completed`: complete the array adding missing stages up to `release`
   - `links.pr_url: "https://github.com/<your-github-account>/<your-repo>/pull/<PR#>"`

5. **Add entry to LOG.md** of each plan:

   ```markdown

   ## YYYY-MM-DD — Manifest sync (housekeeping)

   Manifest updated retroactively: `stage` moved from `<old>` → `done`. PR #<N> merged in `<SHA>` (<ISO date>). Detected and updated by /plan-sync.
   ```

6. **Report** total: *"N manifests updated. Want to commit now?"*

## Hard Rules

- **DO NOT** auto-commit — only make the edits, user decides
- If a manifest is in-progress AND **has no merge** corresponding, leave it alone — it's active work
- If a manifest has custom fields beyond the canonical ones, **preserve them** (use surgical Edit, not Write)
- If no stale plans found, respond only: *"No stale manifests. Everything is synchronized."*

## When to Run

- You were alerted by the `detect-stale-plans.sh` hook on SessionStart
- You came back from vacation and want to clean up old plans
- Before starting a new SPEC and want a clean environment
- Periodic audit of plan states
