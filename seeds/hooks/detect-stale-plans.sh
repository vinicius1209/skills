#!/bin/bash
# Scans manifests on startup and alerts if any active plan has its branch merged
for m in .claude/plans/*/manifest.json; do
  [ -f "$m" ] || continue
  stage=$(jq -r '.stage // ""' "$m")
  case "$stage" in
    done|cancelled|abandoned|"") continue ;;
  esac
  slug=$(jq -r '.slug // ""' "$m")
  [ -z "$slug" ] && continue
  merge=$(git log --merges --oneline 2>/dev/null | grep -E "feature/${slug}|fix/${slug}" | head -1)
  if [ -n "$merge" ]; then
    echo "Stale plan: ${slug} (stage=${stage}) — branch appears merged. Run /plan-sync."
  fi
done
