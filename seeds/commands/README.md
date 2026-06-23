# SDD Pipeline Commands

Slash commands that form the Spec-Driven Development pipeline. Each command
is a markdown file that instructs the AI orchestrator on what to do, which
agent to invoke, and what artifacts to produce.

## Installation

Copy the `.md` files into your project's `.claude/commands/` directory:

```bash
mkdir -p .claude/commands
cp *.md .claude/commands/
```

## Pipeline Overview

```
/discovery → /prd → /spec → /developer → /test-suite → /code-review → /pr
 (refine)    (what)  (how)    (build it)    (test it)     (check it)    (ship it)
```

Or run `/feature` — the orchestrator that executes all stages automatically.

## Commands

| Command | Stage | Agent | Output | Gate |
|---------|-------|-------|--------|------|
| `/discovery` | 0 | Product Analyst | Structured prompt | User confirms |
| `/feature` | All | Orchestrator | Full pipeline | PRD approval |
| `/prd` | 1 | architect | PRD.md | **User approval** |
| `/spec` | 2 | architect | SPEC.md | Auto |
| `/developer` | 3 | dev + dba | Code + migrations | Auto |
| `/test-suite` | 3.5 | tester | Test files | Tests passing |
| `/code-review` | 4 | code-review | Review report | No critical issues |
| `/pr` | 5 | PR Manager | GitHub PR | CI passing |
| `/plan-sync` | — | — | Manifest → done | Manual confirm |

## Key Concepts

- **$1** is the only input — commands receive one argument (feature slug or description)
- **Each command updates the manifest** — stage and stages_completed are updated after completion
- **Each command appends to LOG.md** — creating an audit trail
- **`/feature` can resume** — reads the manifest and skips completed stages
- **`/clear` between stages** — clear context window between stages to avoid drift (the manifest carries state forward)

## Placeholders to Replace

Before using these commands, replace:
- `<your-domain>` → your actual domain skill name
- `<your-project>` → your project name
- `<your-github-account>` → your GitHub username
- `<your-repo>` → your repository name
