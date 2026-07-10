# dev/ — Spec-Driven Development kit

The **dev** domain of this repo: everything you need to bootstrap Spec-Driven
Development (SDD) in a new project. Copy the files into your `.claude/` directory
and you're running. The methodology docs (guide, landscape, visual) live in
[`docs/`](docs/).

## Quick Install

```bash
# Clone this repo
git clone https://github.com/vinicius1209/skills.git /tmp/ai-seeds

# Copy seeds into your project
mkdir -p .claude/{agents,skills,schemas,plans,hooks,references}
cp /tmp/ai-seeds/dev/agents/*.md .claude/agents/
# Pipeline skills (each is a folder with a SKILL.md) → .claude/skills/
cp -r /tmp/ai-seeds/dev/skills/{discovery,prd,spec,developer,test-suite,code-review,pr,plan-sync,feature} .claude/skills/
# Domain knowledge skill → rename the template to your domain
cp -r /tmp/ai-seeds/dev/skills/domain-template .claude/skills/<your-domain>
# Technical reference scaffolds (FSD, query patterns, forms, dialogs...) → .claude/references/
cp /tmp/ai-seeds/dev/references/*.md .claude/references/
cp /tmp/ai-seeds/dev/schemas/*.json .claude/schemas/
cp /tmp/ai-seeds/dev/plans/*.json .claude/plans/
cp /tmp/ai-seeds/dev/hooks/*.sh .claude/hooks/
cp /tmp/ai-seeds/dev/settings.json .claude/settings.json
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
| `skills/` (pipeline) | `.claude/skills/` | 9 pipeline skills forming the SDD pipeline (discovery, prd, spec, developer, test-suite, code-review, pr, plan-sync, feature) |
| `skills/domain-template/` | `.claude/skills/<your-domain>/` | Domain knowledge template (SKILL.md + reference templates) |
| `references/` | `.claude/references/` | 6 technical reference scaffolds (architecture/FSD, query-patterns, forms, dialogs, navigation-surfaces, shared-ui-inventory) — framework anti-patterns pre-filled |
| `schemas/` | `.claude/schemas/` | JSON schema for the plan manifest |
| `plans/` | `.claude/plans/` | Manifest template for new features |
| `hooks/` | `.claude/hooks/` | 8 bash scripts for automated safety gates |
| `settings.json` | `.claude/settings.json` | Hook wiring config |

## The 6-Layer System

| Layer | What it IS | What it DOES |
|-------|-----------|-------------|
| **Skills** | Knowledge | Injectable domain expertise loaded into agents on demand |
| **Agents** | Execution | Specialized AI team members with scoped permissions |
| **Commands/Skills** | Coordination | Pipeline stages that invoke the right agent with the right context. Commands and skills are unified — both create `/<name>`; the pipeline ships as skills (with `disable-model-invocation`) |
| **Manifest** | Contract | Tracks feature lifecycle, enables resume + deliverable verification |
| **Hooks** | Safety | Automated checks that fire on tool events — institutional memory |
| **References** | Patterns | Canonical docs that prevent reinvention (you write these per project) |

## After Installation

1. **Replace `<your-domain>`** in all agent and pipeline-skill files with your actual skill name
2. **Replace `<your-project>`** with your project name
3. **Replace `<your-github-account>`** (and `<your-repo>`) in the pipeline-skill files with your GitHub username/repo
4. **Write your domain skill** — fill in `SKILL.md` with your business rules, vocabulary, and schema gotchas
5. **Fill in your references** — start from the scaffolds copied to `.claude/references/` (architecture, query-patterns, forms, dialogs, navigation-surfaces, shared-ui-inventory): the framework-level anti-patterns are pre-filled; add your project-specific paths, aliases, and components
6. **Run `/discovery`** with an informal feature description to test the pipeline

## Stack Coverage

These seeds are optimized for:
- **Frontend**: React 18, TypeScript, Vite/SWC, shadcn/ui, Radix UI, Tailwind CSS
- **State/Data**: TanStack React Query v5
- **Forms**: React Hook Form + Zod
- **Backend**: Supabase (PostgreSQL, Auth, Edge Functions/Deno)
- **Architecture**: Feature-Sliced Design (FSD)
- **Testing**: Vitest, React Testing Library, Playwright, MSW

Using a different stack? The pipeline skills, manifest, hooks, and skill template
are stack-agnostic. Only the agent definitions are stack-specific — adapt them to
your framework.
