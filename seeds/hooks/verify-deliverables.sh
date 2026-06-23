#!/bin/bash
# Warns if manifest declares artifacts that don't exist on disk
BRANCH=$(git branch --show-current 2>/dev/null)
SLUG=${BRANCH#feature/}
SLUG=${SLUG#fix/}
MANIFEST=".claude/plans/${SLUG}/manifest.json"

if [ -f "$MANIFEST" ]; then
  PRD_PATH=$(jq -r '.artifacts.prd.path // empty' "$MANIFEST")
  if [ -n "$PRD_PATH" ] && [ ! -f ".claude/plans/${SLUG}/${PRD_PATH}" ]; then
    echo "PRD declared in manifest but not found: ${PRD_PATH}"
  fi
  SPEC_PATH=$(jq -r '.artifacts.spec.path // empty' "$MANIFEST")
  if [ -n "$SPEC_PATH" ] && [ ! -f ".claude/plans/${SLUG}/${SPEC_PATH}" ]; then
    echo "SPEC declared in manifest but not found: ${SPEC_PATH}"
  fi
fi
