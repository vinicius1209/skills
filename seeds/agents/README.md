# Agent Pack — React + TanStack Query + Supabase + shadcn/ui

Reusable AI agent definitions for any project using this stack. Each agent has
scoped permissions and declares which skills it needs.

## Installation

Copy the `.md` files into your project's `.claude/agents/` directory:

```bash
mkdir -p .claude/agents
cp *.md .claude/agents/
```

Then replace `<your-domain>` in each file's `skills:` frontmatter with your
actual domain skill name.

## Agents

| Agent | Role | Write Access | Key Skill |
|-------|------|-------------|-----------|
| `architect` | Plans features, generates PRD/SPEC | `.claude/plans/` only | `<your-domain>` |
| `dev` | Implements application code | `src/` (or equivalent) | `<your-domain>`, `frontend-aesthetics` |
| `dba` | Database changes | Migrations, SQL | `<your-domain>`, `supabase` |
| `tester` | Writes tests | `*.test.*` files only | `<your-domain>` |
| `code-review` | Reviews uncommitted changes | Read-only | `<your-domain>` |
| `qa-smoke` | Browser smoke tests | Read-only (reports to `.claude/plans/`) | `<your-domain>` |

## Permission Model

- **Write-scoped to plans**: `architect` — can write PRD/SPEC/manifest, NOT production code
- **Write to source**: `dev` (app code), `dba` (migrations/SQL), `tester` (test files)
- **Read-only**: `code-review` and `qa-smoke` — cannot modify any files (Write/Edit in disallowedTools)

## Skill Placeholder

All agents reference `<your-domain>` in their `skills:` frontmatter. Replace this
with your actual domain skill name before use. See `seeds/skills/` for a template.

## Stack Coverage

- **Frontend**: React 18, TypeScript, Vite/SWC, shadcn/ui, Radix UI, Tailwind CSS
- **State/Data**: TanStack React Query v5
- **Forms**: React Hook Form + Zod
- **Backend**: Supabase (PostgreSQL, Auth, Edge Functions/Deno)
- **Architecture**: Feature-Sliced Design (FSD)
- **Testing**: Vitest, React Testing Library, Playwright, MSW
