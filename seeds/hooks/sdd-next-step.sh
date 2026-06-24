#!/usr/bin/env bash
# Hook: SubagentStop
# Objetivo: apos um subagente de uma etapa do pipeline SDD terminar, injetar
# no contexto do Claude (via additionalContext) qual e o proximo passo
# sugerido do pipeline.
#
# Filosofia (alinhada com auto-update-manifest-stage.sh e detect-stale-plans.sh):
# INFORMATIVO apenas. NAO muta manifest.json. NAO bloqueia (exit 0 sempre).
# A mutacao de stage continua sendo responsabilidade dos proprios comandos do
# pipeline (/developer, /pr, etc) e do /plan-sync.
#
# Em SubagentStop, stdout puro NAO e injetado no contexto: e preciso emitir
# JSON com hookSpecificOutput.additionalContext (doc oficial: hooks.md).
# O campo que identifica o subagente no stdin e "agent_type".

set -uo pipefail

INPUT=$(cat 2>/dev/null || echo '{}')
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // empty' 2>/dev/null || echo "")
[ -z "$AGENT_TYPE" ] && exit 0

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
BRANCH=$(git -C "$REPO_ROOT" branch --show-current 2>/dev/null || true)
case "$BRANCH" in
  feature/*|fix/*) ;;
  *) exit 0 ;;
esac
SLUG="${BRANCH#feature/}"; SLUG="${SLUG#fix/}"

MSG=""
case "$AGENT_TYPE" in
  architect)
    MSG="O architect terminou. Se gerou o PRD: revise a Scenario Matrix e rode /spec ${SLUG}. Se gerou o SPEC: rode /developer ${SLUG}."
    ;;
  dev|dba)
    MSG="Implementacao concluida por '${AGENT_TYPE}'. Proximo passo do pipeline: /test-suite ${SLUG}."
    ;;
  tester)
    MSG="Testes gerados. Confirme verde com 'npx vitest run' e siga para /code-review ${SLUG}."
    ;;
  code-review)
    MSG="Code review concluido. Se nao houver itens Critical, o proximo passo e /pr."
    ;;
  qa-smoke)
    MSG="QA smoke concluido. Se os cenarios passaram, o proximo passo e /pr."
    ;;
  *)
    exit 0
    ;;
esac

[ -z "$MSG" ] && exit 0

jq -cn --arg ctx "[SDD next-step] $MSG" \
  '{hookSpecificOutput: {hookEventName: "SubagentStop", additionalContext: $ctx}}' \
  2>/dev/null || true
exit 0
