# Hooks — Automated Safety Gates

Hooks are shell scripts triggered by AI tool events. They enforce rules that
prompts alone can't guarantee. Every time an agent makes a mistake that a script
could have caught, write a hook here.

## Installation

```bash
mkdir -p .claude/hooks
cp *.sh .claude/hooks/
chmod +x .claude/hooks/*.sh
```

Then wire them in `.claude/settings.json` (see `seeds/settings.json`).

## Hook Triggers

| Trigger | Fires When | Use For |
|---------|-----------|---------|
| `PreToolUse` | Before any tool invocation | Block invalid actions |
| `PostToolUse` | After a tool completes | Auto-stage files, log events |
| `SubagentStop` | When a subagent finishes | Verify deliverables, suggest next step |
| `Stop` | When the session ends | Log metrics |
| `SessionStart` | When a session begins | Detect stale plans, inject context |

> These are the most common of ~27 hook events (others include `UserPromptSubmit`,
> `SubagentStart`, `PreCompact`, `PostCompact`, `SessionEnd`, etc.) — see the
> official Claude Code hooks docs for the full list.

## Included Hooks

| Hook | Trigger | Purpose |
|------|---------|---------|
| `auto-commit-plans.sh` | PostToolUse (Write\|Edit) | Auto-stage plan files on feature branches |
| `check-pr-state.sh` | PreToolUse (Bash) | Block commits on branches with merged PRs |
| `verify-deliverables.sh` | SubagentStop | Warn if manifest artifacts don't exist on disk |
| `detect-stale-plans.sh` | SessionStart | Alert on plans whose branch is already merged |
| `log-session-metrics.sh` | Stop | Track session stats to CSV |
| `sdd-context-inject.sh` | SessionStart | Inject the current branch's SDD pipeline state into context |
| `sdd-next-step.sh` | SubagentStop | Suggest the next pipeline step via `additionalContext` (does NOT mutate the manifest) |
| `auto-typecheck.sh` | PostToolUse (Write\|Edit) | Run vitest on just the edited test file and report failures (does not run a full project type-check) |

> The last three (`sdd-context-inject.sh`, `sdd-next-step.sh`, `auto-typecheck.sh`)
> are **informational** — they only inject context or warn, and never block.

## Writing Your Own Hooks

Hooks are plain bash scripts. They receive context from the AI tool and can:
- **Block** an action by exiting with **exit code 2**. Exit 2 blocks only on these
  events: `PreToolUse`, `UserPromptSubmit`, `Stop`, `PreCompact`, and
  `UserPromptExpansion`. On other events (e.g. `PostToolUse`, `SessionStart`) exit 2
  just shows stderr **without** blocking.
- **Report a non-blocking error** with any other non-zero exit code.
- **Succeed** with **exit 0** — stdout JSON is processed (e.g.
  `hookSpecificOutput.additionalContext` injects context).
- **Warn / log** by printing to stderr or appending to files (all triggers).

### Pattern: Domain-specific validation hook

```bash
#!/bin/bash
# Blocks creation of files that reference deprecated APIs/patterns.
# Wired on PreToolUse, so exit 2 actually blocks the tool call.
MATCHES=$(grep -rl "deprecatedFunction" "$1" 2>/dev/null)
if [ -n "$MATCHES" ]; then
  echo "Blocked: deprecatedFunction reference found in $MATCHES" >&2
  exit 2
fi
exit 0
```

### When to add a hook

- An agent creates a migration with a duplicate timestamp → `validate-migration-timestamp.sh`
- An agent references a deprecated API → `validate-no-deprecated-refs.sh`
- An agent commits to a branch whose PR is already merged → `check-pr-state.sh`
- A subagent finishes but its declared artifacts don't exist → `verify-deliverables.sh`

**Institutional memory**: every mistake that a hook could have prevented → write the hook. Over months, your safety net grows automatically.

## Tool Compatibility

These hooks use Claude Code's format (bash scripts wired in `settings.json`).
Other AI tools have equivalent mechanisms:

| Tool | Mechanism | Config File |
|------|-----------|-------------|
| Claude Code | Bash scripts | `.claude/settings.json` |
| OpenCode | Same (mirrors Claude Code) | `.opencode/` |
| Cursor | Custom rules / MCP servers | `.cursorrules` / MCP config |
| Aider | Pre-commit hooks | `.aider.conf.yml` |
