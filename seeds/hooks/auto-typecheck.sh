#!/usr/bin/env bash
# Hook: PostToolUse (matcher Write|Edit)
# Objetivo: feedback rapido. Ao editar um arquivo de TESTE, roda apenas
# aquele arquivo no vitest; se falhar, injeta o resultado no contexto do
# Claude via additionalContext.
#
# Decisao de custo: NAO roda 'tsc --noEmit' no projeto inteiro (caro demais
# para rodar a cada edicao). Type-check completo fica para o CI / verificacao
# manual. Se quiser desligar este hook, remova-o do .claude/settings.json.
#
# INFORMATIVO: nunca bloqueia (exit 0 sempre). Em PostToolUse, contexto so e
# injetado via JSON hookSpecificOutput.additionalContext (doc oficial).

set -uo pipefail

INPUT=$(cat 2>/dev/null || echo '{}')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")
[ -z "$FILE_PATH" ] && exit 0

case "$FILE_PATH" in
  *.test.ts|*.test.tsx|*.spec.ts|*.spec.tsx) ;;
  *) exit 0 ;;
esac
[ -f "$FILE_PATH" ] || exit 0

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$REPO_ROOT" 2>/dev/null || exit 0

# vitest precisa estar disponivel; se nao estiver, sai limpo
command -v npx >/dev/null 2>&1 || exit 0

RESULT=$(npx vitest run "$FILE_PATH" --reporter=dot 2>&1 | tail -40 || true)
if echo "$RESULT" | grep -qiE '(FAIL|[0-9]+ failed|✗|×)'; then
  jq -cn --arg ctx "[auto-typecheck] Testes falharam apos editar ${FILE_PATH}:
${RESULT}

Corrija antes de prosseguir." \
    '{hookSpecificOutput: {hookEventName: "PostToolUse", additionalContext: $ctx}}' \
    2>/dev/null || true
fi
exit 0
