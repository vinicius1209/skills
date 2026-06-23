# Seeds — Copy-Paste SDD Starter Kit

Everything you need to bootstrap Spec-Driven Development in a new project.
Copy the files into your `.claude/` directory and you're running.

## Quick Install

```bash
# Clone this repo
git clone https://github.com/vinicius1209/skills.git /tmp/ai-seeds

# Copy seeds into your project
mkdir -p .claude/{agents,commands,skills,schemas,plans,hooks}
cp /tmp/ai-seeds/seeds/agents/*.md .claude/agents/
cp /tmp/ai-seeds/seeds/commands/*.md .claude/commands/
cp -r /tmp/ai-seeds/seeds/skills/domain-template .claude/skills/<your-domain>
cp /tmp/ai-seeds/seeds/schemas/*.json .claude/schemas/
cp /tmp/ai-seeds/seeds/plans/*.json .claude/plans/
cp /tmp/ai-seeds/seeds/hooks/*.sh .claude/hooks/
cp /tmp/ai-seeds/seeds/settings.json .claude/settings.json
chmod +x .claude/hooks/*.sh

# Write your domain skill
# Edit .claude/skills/<your-domain>/SKILL.md with your business rules

# Run your first feature
# /discovery "I need to add a notifications system"
# /feature "structured prompt from discovery"
```

## What's Included

| Folder | Copy to | What it is |
|--------|---------|-----------|
| `agents/` | `.claude/agents/` | 6 AI agent definitions (architect, dev, dba, tester, code-review, qa-smoke) |
| `commands/` | `.claude/commands/` | 9 slash commands forming the SDD pipeline |
| `skills/` | `.claude/skills/<your-domain>/` | Domain knowledge template (SKILL.md + reference templates) |
| `schemas/` | `.claude/schemas/` | JSON schema for the plan manifest |
| `plans/` | `.claude/plans/` | Manifest template for new features |
| `hooks/` | `.claude/hooks/` | 5 bash scripts for automated safety gates |
| `settings.json` | `.claude/settings.json` | Hook wiring config |

## The 6-Layer System

| Layer | What it IS | What it DOES |
|-------|-----------|-------------|
| **Skills** | Knowledge | Injectable domain expertise loaded into agents on demand |
| **Agents** | Execution | Specialized AI team members with scoped permissions |
| **Commands** | Coordination | Pipeline stages that invoke the right agent with the right context |
| **Manifest** | Contract | Tracks feature lifecycle, enables resume + deliverable verification |
| **Hooks** | Safety | Automated checks that fire on tool events — institutional memory |
| **References** | Patterns | Canonical docs that prevent reinvention (you write these per project) |

## After Installation

1. **Replace `<your-domain>`** in all agent and command files with your actual skill name
2. **Replace `<your-project>`** with your project name
3. **Replace `<your-github-account>`** in command files with your GitHub username
4. **Write your domain skill** — fill in `SKILL.md` with your business rules, vocabulary, and schema gotchas
5. **Write your references** — create `references/*.md` docs for your project's canonical patterns (forms, dialogs, query patterns, navigation surfaces, shared UI inventory)
6. **Run `/discovery`** with an informal feature description to test the pipeline

## Stack Coverage

These seeds are optimized for:
- **Frontend**: React 18, TypeScript, Vite/SWC, shadcn/ui, Radix UI, Tailwind CSS
- **State/Data**: TanStack React Query v5
- **Forms**: React Hook Form + Zod
- **Backend**: Supabase (PostgreSQL, Auth, Edge Functions/Deno)
- **Architecture**: Feature-Sliced Design (FSD)
- **Testing**: Vitest, React Testing Library, Playwright, MSW

Using a different stack? The commands, manifest, hooks, and skill template are
stack-agnostic. Only the agent definitions are stack-specific — adapt them to
your framework.
