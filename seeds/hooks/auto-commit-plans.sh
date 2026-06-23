#!/bin/bash
# Auto-stages plan files when edited on a feature branch
BRANCH=$(git branch --show-current 2>/dev/null)
case "$BRANCH" in
  feature/*|fix/*)
    git add .claude/plans/ 2>/dev/null
    ;;
esac
