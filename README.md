# skills

My A.I. home — agent skills, workflows, and spec-driven development tooling.

## Contents

### `sdd/` — Spec-Driven Development

A portable, domain-agnostic SDD implementation guide and ecosystem analysis for AI-assisted development.

| File | Description |
|------|-------------|
| [`SDD-GUIDE.md`](sdd/SDD-GUIDE.md) | Complete implementation guide: folder structure, agents, skills, commands, manifest schema, hooks, seeder templates, troubleshooting, and success metrics |
| [`SDD-VISUAL.html`](sdd/SDD-VISUAL.html) | Interactive visual presentation (open in browser) — pipeline flow, tiered adoption, core concepts, scenario matrix |
| [`SDD-LANDSCAPE.md`](sdd/SDD-LANDSCAPE.md) | Ecosystem analysis: comparison of custom SDD vs GitHub Spec Kit, OpenSpec, AWS Kiro, BMAD, cc-sdd, and 7 other tools |

#### Quick Start

1. Read `SDD-GUIDE.md` for the full blueprint
2. Open `SDD-VISUAL.html` in a browser for the visual overview
3. Check `SDD-LANDSCAPE.md` to see how your approach compares to existing tools

#### The SDD Pipeline

```
/discovery → /prd → /spec → /developer → /test-suite → /code-review → /pr
 (refine)    (what)  (how)    (build it)    (test it)     (check it)    (ship it)
```

Or just run `/feature` — the orchestrator that does all of the above automatically.

#### Tiers

- **MVP**: 3 agents, 5 pipeline skills, 1 domain skill, 2 references, 1 hook
- **Quality**: + tester, dba, 4 references, 3 hooks
- **Full**: + qa-smoke, release, nightly-tests, telemetry hooks

### `seeds/` — Copy-Paste Starter Kit

Ready-to-use files that bootstrap SDD in any project. Copy them into your `.claude/`
directory and you're running.

| Folder | What it is |
|--------|-----------|
| `seeds/agents/` | 6 AI agent definitions (architect, dev, dba, tester, code-review, qa-smoke) |
| `seeds/skills/` | Domain knowledge template + 9 pipeline skills forming the SDD pipeline |
| `seeds/schemas/` | JSON schema for the plan manifest |
| `seeds/plans/` | Manifest template for new features |
| `seeds/hooks/` | 8 bash scripts for automated safety gates |
| `seeds/settings.json` | Hook wiring config |

See [`seeds/README.md`](seeds/README.md) for installation instructions.
