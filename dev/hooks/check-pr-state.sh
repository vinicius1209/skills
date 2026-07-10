#!/bin/bash
# Blocks git commits on branches whose PR is already merged
BRANCH=$(git branch --show-current 2>/dev/null)
case "$BRANCH" in
  feature/*|fix/*)
    PR_STATE=$(gh pr list --head "$BRANCH" --state merged --json number -q '.[0].number' 2>/dev/null)
    if [ -n "$PR_STATE" ]; then
      echo "PR #$PR_STATE for $BRANCH was already merged. Create a new branch."
      exit 1
    fi
    ;;
esac
