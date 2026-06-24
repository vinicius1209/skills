#!/usr/bin/env bash
# Hook: SessionStart
# Objetivo: ao iniciar sessao numa branch feature/* ou fix/* que tenha um
# plano SDD, injetar no contexto do Claude o estado atual do pipeline e o
# proximo passo sugerido.
#
# Stdout de SessionStart e injetado no contexto do Claude (confirmado na doc
# oficial: code.claude.com/docs/en/hooks-guide.md). Filosofia alinhada com
# detect-stale-plans.sh: INFORMATIVO, nao bloqueia, zero ruido quando nao ha
# plano para a branch.

set -uo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
BRANCH=$(git -C "$REPO_ROOT" branch --show-current 2>/dev/null || true)
case "$BRANCH" in
  feature/*|fix/*) ;;
  *) exit 0 ;;
esac

SLUG="${BRANCH#feature/}"; SLUG="${SLUG#fix/}"
MANIFEST="$REPO_ROOT/.claude/plans/$SLUG/manifest.json"
[ -f "$MANIFEST" ] || exit 0

STAGE=$(jq -r '.stage // "unknown"' "$MANIFEST" 2>/dev/null || echo "unknown")
COMPLETED=$(jq -r '(.stages_completed // []) | join(", ")' "$MANIFEST" 2>/dev/null || echo "")
LOG_FILE="$REPO_ROOT/.claude/plans/$SLUG/LOG.md"
LOG_TAIL=""
[ -f "$LOG_FILE" ] && LOG_TAIL=$(tail -5 "$LOG_FILE" 2>/dev/null || true)

case "$STAGE" in
  discovery|prd)  NEXT="revise o PRD e rode /spec ${SLUG}" ;;
  spec)           NEXT="/developer ${SLUG}" ;;
  developer)      NEXT="/test-suite ${SLUG}" ;;
  test-suite)     NEXT="/code-review ${SLUG}" ;;
  code-review)    NEXT="/pr" ;;
  pr)             NEXT="aguardar merge; depois /plan-sync" ;;
  release|done)   NEXT="feature concluida" ;;
  *)              NEXT="" ;;
esac

{
  echo "[SDD context] Branch: ${BRANCH} | Stage: ${STAGE}"
  echo "Etapas concluidas: ${COMPLETED:-nenhuma}"
  if [ -n "$LOG_TAIL" ]; then
    echo "Atividade recente (LOG.md):"
    echo "$LOG_TAIL"
  fi
  [ -n "$NEXT" ] && echo "Proximo passo sugerido: $NEXT"
}
exit 0
