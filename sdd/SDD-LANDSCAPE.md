# SDD Tooling Landscape — Your Custom Approach vs The Ecosystem

> **Context**: Analysis of the Spec-Driven Development (SDD) tooling landscape as of mid-2026, comparing a custom-built SDD pipeline against all notable third-party SDD frameworks and tools.
>
> **Date**: June 2026

---

## Table of Contents

1. [What the Case Study Project Uses Today](#1-what-the-case-study-project-uses-today)
2. [The SDD Ecosystem (2025–2026)](#2-the-sdd-ecosystem-20252026)
3. [Structural Comparison](#3-structural-comparison)
4. [What Your SDD Has That Others Don't](#4-what-your-sdd-has-that-others-dont)
5. [What Others Have That Yours Doesn't](#5-what-others-have-that-yours-doesnt)
6. [Decision Matrix](#6-decision-matrix)
7. [Honest Assessment](#7-honest-assessment)

---

## 1. What the Case Study Project Uses Today

From codebase analysis:

| Category | What you use | Where |
|----------|-------------|-------|
| **SDD pipeline** | Custom Claude Code workflow (15 commands, 7 agents, 6 skills, 15 hooks, manifest schema) | `.claude/` |
| **Unit/integration tests** | Vitest 2.x + React Testing Library + MSW | `vitest.config.ts`, `src/test/` |
| **E2E tests** | Playwright 1.50.x | `playwright.config.ts`, `e2e/` |
| **API spec** | OpenAPI 3.0.3 + Swagger UI | `public/openapi.yaml`, `src/pages/ApiDocs.tsx` |
| **Schema validation** | Zod (forms + runtime) | via `react-hook-form` + `@hookform/resolvers` |
| **DB testing** | SQL-based RLS/RPC tests via `psql` + transactions | `supabase/tests/rpc/` |
| **Release automation** | release-please | `release-please-config.json` |
| **Git hooks** | husky + lint-staged + commitlint | `package.json` |
| **AI orchestration** | Anthropic Cockpit + Claude Code agents | `.cockpit/config.json`, `.claude/` |
| **Nightly tests** | Custom cron + launchd | `scripts/nightly-tests.sh` |

Your SDD approach is **100% custom-built** — no third-party SDD framework is used. You built your own pipeline, manifest schema, agent definitions, skills, and hooks from scratch on top of Claude Code's native capabilities.

---

## 2. The SDD Ecosystem (2025–2026)

A booming SDD tooling landscape emerged in 2025–2026. Here's every notable tool, categorized.

### Tier 1: Major Platforms (backed by big companies)

#### GitHub Spec Kit

| Field | Value |
|-------|-------|
| **Author** | GitHub |
| **Stars** | ~115K |
| **License** | Open source |
| **URL** | https://github.com/github/spec-kit |
| **Blog** | https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/ |

**What it is**: The reference implementation of SDD. Open-source toolkit with a structured pipeline: `/speckit.constitution` → `/speckit.specify` → `/speckit.clarify` → `/speckit.checklist` → `/speckit.plan` → `/speckit.tasks` → `/speckit.analyze` → `/speckit.implement`. Supports 30+ AI agents (Copilot, Claude Code, Gemini CLI, Codex, Windsurf, Zed, Kiro, etc.). Installed via `specify init` CLI.

**Key features**:
- Constitution file (project-wide rules as EARS statements)
- Clarify command (surfaces ambiguities before planning)
- Checklist command (validates requirements quality)
- Analyze command (cross-artifact consistency check: spec ↔ plan ↔ tasks)
- Converge command (assesses codebase against spec and appends remaining work)
- Tasks-to-issues (exports to GitHub Issues)
- 30+ integrations, no vendor lock-in
- Markdown artifacts that feed the next phase

**Key difference from yours**: The reference implementation. Your pipeline is structurally identical but uses different naming (PRD vs spec, SPEC vs plan). Spec Kit is agent-agnostic; yours is Claude Code-specific. Spec Kit has `/speckit.analyze` (cross-artifact consistency check) — you don't have an equivalent.

---

#### AWS Kiro

| Field | Value |
|-------|-------|
| **Author** | Amazon |
| **License** | Proprietary |
| **URL** | https://kiro.dev |
| **Price** | From $20/month |

**What it is**: Agentic IDE (VS Code fork) with built-in SDD. Requirements.md → design.md → tasks.md. Has Agent Hooks (event-driven automation on file save/create/delete), Steering (persistent rules), MCP support, Powers (bundled MCP + steering + hooks). Two modes: Vibe sessions (fast exploration) and Spec sessions (structured SDD).

**Key features**:
- IDE-native hooks (not shell scripts — UI for hook management)
- Steering files (persistent rules versioned in repo)
- Agent hooks triggered on file save/create/delete
- Powers (installable packages grouping MCP + steering + hooks)
- Checkpointing (revert agent actions)
- Property-based testing (fast-check integration)
- EARS notation for requirements
- MCP server support
- Code OSS base (VS Code compatible plugins)

**Key difference from yours**: Kiro's hooks are IDE-native, not shell scripts. Your hooks are bash scripts wired in settings.json. Kiro has a UI for hook management. Kiro locks you into their IDE + Claude models. Your approach works with any tool that reads `.claude/`.

**Sources**: AWS re:Invent 2025 (DVT209, DEV314), InfoQ, InfoWorld, Forbes, AWS re:Post.

---

#### Google Antigravity

| Field | Value |
|-------|-------|
| **Author** | Google |
| **License** | Experimental |
| **Status** | Early / less documented |

**What it is**: "Agent-first" specification-constrained autonomy. Gives agents deep autonomy within spec boundaries.

**Key difference from yours**: Less documented. Appears to give agents more autonomy within spec boundaries. Your approach is more controlled (stage gates).

---

### Tier 2: Open-Source SDD Frameworks

#### OpenSpec

| Field | Value |
|-------|-------|
| **Author** | Fission-AI |
| **Stars** | ~55K |
| **License** | Open source |
| **URL** | https://github.com/Fission-AI/OpenSpec |
| **Website** | https://openspec.pro |
| **Thoughtworks Radar** | Assess (April 2026) |

**What it is**: Lightweight SDD framework. `/opsx:propose` → specs → design → tasks → implement → archive. Brownfield-first (designed for existing codebases). Spec deltas (tracks changes vs. baseline, not full specs). No rigid phase gates — fluid iteration. 25+ AI assistants. npm install.

**Key features**:
- Fluid workflow (no rigid phase gates — update any artifact anytime)
- Spec deltas (diff against known baseline, not new document from scratch)
- Brownfield-first design
- 5-minute setup (no Python required)
- ~250 lines of specs per change (vs Spec Kit's ~800)
- `openspec/` directory with `changes/` and `archive/`
- Per-change folder: `proposal.md`, `specs/`, `design.md`, `tasks.md`
- Explore workflow (understand existing code before modifying)
- Schema-editable prompt definitions (YAML + template Markdown)
- AGENTS.md auto-generated
- No API keys or MCP required

**Key difference from yours**: Simpler than yours. No agents, no skills, no hooks, no manifest schema. Just markdown files + slash commands. OpenSpec explicitly positions itself as the "anti-Spec Kit" (lighter, no Python, 5-min setup). Your approach is closer to Spec Kit in rigor but with custom tooling.

---

#### BMAD-METHOD

| Field | Value |
|-------|-------|
| **Author** | bmad-code-org |
| **Stars** | ~49K |
| **License** | Other |
| **URL** | https://github.com/bmad-code-org/BMAD-METHOD |

**What it is**: Community methodology. 19 specialized agents (PM, Architect, Developer, UX, Scrum Master, etc.). 34+ workflows across 4 phases (Analysis → Planning → Architecture → Implementation). Party Mode (multiple agent personas in one session). Scale-adaptive (adjusts depth from bug fix to enterprise). Constitution file. Module ecosystem (Test Architect, Game Dev Studio, Creative Intelligence Suite).

**Key features**:
- 19 specialized agents with customizable personalities
- Party Mode (multi-agent collaboration in one session)
- Scale-adaptive intelligence (auto-adjusts planning depth)
- 34+ workflows
- Module ecosystem (Test Architect, Game Dev Studio, Creative Intelligence)
- BMad Builder (create custom agents and workflows)
- Web Bundles (use in ChatGPT, Claude Projects, Gemini Gems)
- Multi-language support (separate settings for communication and code)
- Document sharding (90% token savings for large projects)
- Update-safe customization

**Key difference from yours**: More agents than yours (19 vs 7). Has "Party Mode" for multi-agent collaboration. Your agents are role-specific but don't collaborate in a single session. BMAD is more of a methodology than tooling — it's prompt packs, not code.

---

#### cc-sdd

| Field | Value |
|-------|-------|
| **Author** | gotalab |
| **URL** | https://github.com/gotalab/claude-code-spec |
| **Install** | `npx cc-sdd@latest --claude` |

**What it is**: SDD for Claude Code (and 8 other agents). `/kiro:*` commands. Kiro-style workflow. 11 commands + 9 subagents. Supports Claude Code, Codex, OpenCode, Cursor, GitHub Copilot, Gemini CLI, Qwen Code, Windsurf.

**Key features**:
- 11 slash commands
- 9 subagents
- 8 agent platform support
- 13 language support
- Project Memory (AI remembers architecture across sessions)
- Team-aligned templates
- Parallel execution ready

**Key difference from yours**: Directly comparable to yours. Same tool (Claude Code), same approach (slash commands + subagents). cc-sdd is installable via npx; yours is hand-built. cc-sdd supports 8 agents (Claude, Cursor, Gemini, Codex, Copilot, Qwen, OpenCode, Windsurf); yours is Claude Code only.

---

#### SolidSpec

| Field | Value |
|-------|-------|
| **Author** | jyjeanne |
| **URL** | https://github.com/jyjeanne/solidspec |

**What it is**: Multi-schema SDD with 20 AI agents. 7 schemas: minimal (4 artifacts), spec-driven (9 artifacts), security-first (5 artifacts), tdd-driven (10 artifacts), intent-driven (11 artifacts), apex-driven (9 artifacts), intent-apex (11 artifacts).

**Key features**:
- 7 methodology schemas (pick the rigor level)
- 20 AI agent support
- TDD schema (real failing tests before implementation — RED phase)
- Security schema (mandatory OWASP audit gates)
- Intent-driven schema (captures WHY, evidence collection, drift detection)
- APEX implementation (structured A-P-E-X replaces manual handoff)

**Key difference from yours**: Schema selection — you pick the rigor level. Your tiers (MVP/Quality/Full) are similar but aren't formal schemas. SolidSpec has TDD and security schemas you don't have.

---

### Tier 3: Niche SDD Tools

#### SpecWright

| Field | Value |
|-------|-------|
| **Author** | amelmo |
| **URL** | https://github.com/amelmo/specwright |

**What it is**: AI specialists orchestrator: Product Manager → UX Designer → Engineer → Tech Lead. Produces PRDs, wireframes, architecture, issues. CLI + Web UI.

**Phases**: Scope (classifier) → Product (PM: PRD with job stories) → Design (UX: screen inventory, wireframes, user flows) → Architecture (Engineer: tech choices, architecture) → Breakdown (Tech Lead: implementation tasks by vertical slice).

**Key difference from yours**: Has a UX Designer agent you don't have. Produces wireframes and screen inventories. Your architect does PM + architecture but no UX.

---

#### Speculator

| Field | Value |
|-------|-------|
| **Author** | wbeard |
| **URL** | https://github.com/wbeard/speculator |

**What it is**: Research-Plan-Implement workflow. `/spec.new` → `/spec.research` → `/spec.plan` → `/spec.tasks` → `/spec.implement`. Multi-agent orchestration with task claiming.

**Key features**:
- `/spec.clarify` for mid-implementation changes (assesses downstream impact)
- Multi-agent orchestration: `spec tasks ready` → `spec task claim <id>` → work → `spec task complete <id>`
- Claim-before-you-code principle
- Per-feature workspace in `.speculator/features/`

**Key difference from yours**: Task claiming — multiple agents can claim tasks atomically. Your approach is sequential, not parallel-claim.

---

#### Specd

| Field | Value |
|-------|-------|
| **Author** | Specd |
| **URL** | https://specd.app/blog/ai-prd-cursor-claude-code |

**What it is**: AI PRD generator for Cursor/Claude/Windsurf. Generates PRDs with build order, file structure, acceptance criteria, out-of-scope items.

**Key difference from yours**: PRD-only — doesn't do implementation. It's a PRD generator, not a full pipeline. Your `/discovery` + `/prd` covers this.

---

#### spec-kit-command-cursor

| Field | Value |
|-------|-------|
| **Author** | madebyaris |
| **URL** | https://github.com/madebyaris/spec-kit-command-cursor |

**What it is**: SDD for Cursor IDE. `/brief` → `/specify` → `/plan` → `/tasks` → `/implement`. Parallel DAG execution. Checkpoints & resume.

**Key features**:
- Parallel DAG execution via async subagents (`/execute-parallel`)
- Checkpoints & resume (`--resume` after interruption)
- Deep research mode (`/research --deep` with web search, documentation deep-dives, confidence scoring)
- Full project roadmap (`/sdd-full-plan` with DAG)
- 40+ task support with phased creation
- Conflict detection for parallel execution

**Key difference from yours**: Parallel DAG execution — tasks run in parallel with dependency tracking. Your `/developer` is sequential. Has checkpoint/resume for long-running implementations.

---

#### claude-plugin-prd-workflow

| Field | Value |
|-------|-------|
| **Author** | Yassinello |
| **URL** | https://github.com/Yassinello/claude-plugin-prd-workflow |

**What it is**: Claude Code plugin. 13 AI agents. `/create-prd` → `/review-prd` → `/setup-prd` → `/code-prd`. Git worktree orchestration. 7-dimension PRD review.

**Key features**:
- 13 AI agents (prd-reviewer, prd-implementer, orchestrator, security-expert, quality-assurance, devops-engineer, etc.)
- Git worktree orchestration (each PRD gets its own worktree)
- 7-dimension PRD review with grading
- Quick Ship workflow for small changes
- Multi-PRD orchestration (dependency analysis, bottleneck detection)
- Automated quality gates

**Key difference from yours**: Git worktree orchestration — each PRD gets its own worktree. Your approach uses branches but not worktrees. Has a 7-dimension PRD review (yours has Scenario Matrix + approval gate).

---

#### Tessl

| Field | Value |
|-------|-------|
| **Author** | Tessl |
| **Focus** | Compliance |

**What it is**: Compliance-focused SDD. Audit trails, regulated templates.

**Key difference from yours**: For fintech/healthtech. Less relevant unless you need compliance.

---

## 3. Structural Comparison

| Dimension | Your SDD | GitHub Spec Kit | OpenSpec | AWS Kiro | BMAD |
|-----------|---------|----------------|---------|---------|------|
| **Pipeline** | discovery → prd → spec → dev → test → review → pr | constitution → specify → clarify → checklist → plan → tasks → analyze → implement | propose → implement → archive | requirements → design → tasks → implement | analysis → planning → architecture → implementation |
| **Stages** | 7 + orchestrator | 8 | 3 (fluid) | 3 | 4 phases, 34 workflows |
| **Agents** | 7 (architect, dev, dba, tester, code-review, qa-smoke, wa-triage) | 0 (uses the coding agent directly) | 0 (uses the coding agent directly) | Built-in | 19 (PM, Architect, Dev, UX, QA, Scrum Master, etc.) |
| **Skills** | 6 (domain-knowledge, db-best-practices, commit, frontend-aesthetics, db-sync, explain-code) | 0 (uses constitution instead) | 0 | Steering files | 0 (agents have embedded expertise) |
| **Manifest** | JSON schema with stage tracking, artifacts, verification, promised_in_spec | Markdown artifacts (spec.md, plan.md, tasks.md) | Markdown + YAML frontmatter | Markdown (requirements.md, design.md, tasks.md) | Markdown docs |
| **Hooks** | 15 bash scripts (PreToolUse, PostToolUse, SubagentStop, Stop, SessionStart) | 0 (no hooks) | 0 (no hooks) | IDE-native hooks (file save/create/delete triggers) | 0 (no hooks) |
| **References** | 7 canonical pattern docs | Constitution file | 0 | Steering files | 0 |
| **Approval gates** | 1 (after PRD) | Multiple (clarify, checklist, analyze) | 0 (fluid) | Built-in review | Multiple (phase boundaries) |
| **Scenario Matrix** | Yes (mandatory, 3+ rows) | No (uses EARS acceptance criteria) | No (uses spec deltas) | Yes (EARS format) | No (uses user stories) |
| **Test integration** | Vitest + Playwright + MSW + nightly auto-test generation | None (tool-agnostic) | None | Property-based testing (fast-check) | Test Architect module |
| **Release pipeline** | `/release` (develop → main with audit gates) | None | None | None | None |
| **Nightly automation** | Yes (cron + coverage tracker + auto PRs) | None | None | None | None |
| **Tool support** | Claude Code only | 30+ agents | 25+ agents | Kiro IDE only | Claude Code, Cursor, Windsurf, VS Code |
| **Setup** | Manual (copy templates) | `specify init` CLI | `openspec init` CLI | Download IDE | npm install |
| **Brownfield support** | Yes (guide §6.2) | Limited | Yes (first-class) | Limited | Limited |

---

## 4. What Your SDD Has That Others Don't

1. **Domain skills system** — No other SDD tool has injectable domain knowledge like the case study's domain skill with references. Spec Kit has a "constitution" (project rules), but this approach is deeper (vocabulary, business rules, schema gotchas, approval gates, reference routing table).

2. **15 hooks with safety gates** — Only Kiro has comparable hook automation. Spec Kit, OpenSpec, and BMAD have zero hooks. Custom hooks like `validate-migration-timestamp.sh`, `validate-no-deprecated-refs.sh`, `check-pr-state.sh` etc. are unique safety nets.

3. **Nightly test automation** — No other SDD tool auto-generates tests overnight with a coverage tracker and auto-PRs. This is entirely custom.

4. **Release pipeline with audit gates** — No SDD tool includes a `/release` command with 10-dimension audit + doc-debt detection. This is yours alone.

5. **Plan-sync / stale detection** — No other tool tracks whether manifests are stale (merged PR but stage ≠ done) and auto-detects on session start.

6. **LOG.md per feature** — The append-only execution log per feature is unique. Other tools have artifacts but no execution trail.

7. **Consistency anchors** — Your PRD requires citing canonical files that the feature must follow. Spec Kit has a constitution but not per-feature anchors.

---

## 5. What Others Have That Yours Doesn't

1. **Cross-artifact consistency check** (Spec Kit's `/speckit.analyze`) — validates spec ↔ plan ↔ tasks alignment before implementation. Your code-review catches issues post-implementation, not pre-implementation.

2. **Tool portability** — Spec Kit and OpenSpec work with 25-30+ AI assistants. Yours is Claude Code only. If you switch to Cursor or Gemini, you'd need to rewrite everything.

3. **npm install** — `npx cc-sdd@latest --claude` gives you a working SDD pipeline in 30 seconds. Yours requires manual setup (copy templates, wire hooks, configure settings).

4. **EARS notation** — Spec Kit and Kiro use EARS (Easy Approach to Requirements Syntax) for acceptance criteria: "The system SHALL do X WHEN Y." Yours uses freeform Scenario Matrix rows. EARS is more structured and machine-parseable.

5. **Parallel task execution with DAG** (Speculator, spec-kit-command-cursor) — Tasks can run in parallel with dependency tracking. Your `/developer` is sequential.

6. **Git worktree isolation** (claude-plugin-prd-workflow) — Each PRD gets its own worktree, so multiple features can be developed simultaneously without branch conflicts. Yours uses branches only.

7. **Multi-agent "Party Mode"** (BMAD) — Multiple agent personas collaborate in a single session. Your agents are invoked sequentially, never simultaneously in one context.

8. **UX Designer agent** (SpecWright, BMAD) — Produces wireframes, screen inventories, and user flows before architecture. Your architect skips UX and goes straight to PRD → SPEC.

9. **Brownfield-first spec deltas** (OpenSpec) — Tracks changes as deltas against a baseline spec, not full new specs. This is specifically designed for existing codebases. Your approach creates full PRDs/SPECs per feature.

10. **Scale-adaptive depth** (BMAD) — Automatically adjusts planning depth based on complexity. A typo fix gets minimal planning; an enterprise system gets deep analysis. Yours has the hotfix fast path but it's manual, not automatic.

---

## 6. Decision Matrix

If you were starting today, which should you use?

| Your situation | Recommendation |
|---------------|---------------|
| **Already have a working custom SDD (you)** | Keep yours. It's more tailored than any framework. Borrow ideas: `/speckit.analyze` (pre-implementation consistency check), EARS notation for acceptance criteria, OpenSpec's spec deltas for brownfield changes. |
| **New project, want SDD fast** | GitHub Spec Kit — `specify init`, 30+ agents, reference implementation, huge community. |
| **Existing project, want lightweight SDD** | OpenSpec — brownfield-first, 5-min setup, no Python, fluid workflow. |
| **AWS shop, want integrated IDE** | AWS Kiro — hooks, steering, MCP, all in one IDE. |
| **Want multi-agent role-play** | BMAD-METHOD — 19 agents, party mode, scale-adaptive. |
| **Want the simplest possible SDD** | OpenSpec — propose → implement → archive. That's it. |
| **Claude Code only, want installable SDD** | cc-sdd — `npx cc-sdd@latest --claude`, 11 commands + 9 subagents. |
| **Regulated industry** | Tessl — compliance-focused, audit trails, regulated templates. |
| **Want TDD integration** | SolidSpec — tdd-driven schema with RED phase before implementation. |

---

## 7. Honest Assessment

### Strengths of Your Approach

Your SDD is the most customized and arguably the most thorough of all the tools found.

- The **skills system** (injectable domain knowledge with references) is unique and more sophisticated than any other tool's "constitution" or "steering" concept
- The **15 hooks** provide safety nets that no open-source SDD tool offers (only Kiro has comparable hooks, and it's proprietary)
- The **nightly test automation** with coverage tracking and auto-PRs is genuinely novel
- The **manifest schema** with `promised_in_spec` and `verification` fields is more structured than any other tool's artifact tracking
- The **release pipeline** with audit gates fills a gap no other SDD tool addresses

Your approach is essentially **Spec Kit rigor + Kiro hooks + custom domain skills + nightly automation** — a hybrid that no single tool provides.

### Gaps to Consider Addressing

1. **Add a pre-implementation consistency check** like Spec Kit's `/speckit.analyze` — validate spec ↔ SPEC ↔ tasks alignment before `/developer` runs
2. **Consider EARS notation** for acceptance criteria — it's more machine-parseable than freeform Scenario Matrix rows
3. **Consider packaging as npm** — if you ever want to reuse this in another project, `npx my-sdd init` would be easier than manual setup
4. **Consider spec deltas for brownfield changes** — OpenSpec's approach of tracking changes vs. baseline is more efficient for existing codebases than full PRDs per feature
5. **Consider a UX agent** — SpecWright and BMAD both have UX design before architecture. Your architect goes straight to PRD without wireflows/screen inventories

### The Trade-off

The cost of your approach is **maintainability** (you maintain everything yourself) and **portability** (Claude Code only). The benefit is **depth** — no framework gives you the level of domain-specific safety nets that your 15 hooks + 6 skills + 7 references provide.

---

## Sources

- GitHub Spec Kit: https://github.com/github/spec-kit
- GitHub Blog (Spec Kit announcement): https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/
- Spec Kit Docs: https://github.github.io/spec-kit/
- OpenSpec: https://github.com/Fission-AI/OpenSpec
- OpenSpec Website: https://openspec.pro
- OpenSpec FAQ: https://openspec.pro/faq/
- Thoughtworks Radar (OpenSpec): https://www.thoughtworks.com/en-us/radar/tools/openspec
- AWS Kiro: https://kiro.dev
- InfoQ (Kiro): https://www.infoq.com/news/2025/08/aws-kiro-spec-driven-agent/
- InfoWorld (Kiro): https://www.infoworld.com/article/4023980/from-prompts-to-specs-awss-kiro-signals-the-next-phase-of-ai-coding-tools.html
- Forbes (Kiro): https://www.forbes.com/sites/adrianbridgwater/2025/07/14/aws-builds-agentic-integrated-developer-environment/
- AWS re:Invent 2025 (Kiro): https://www.youtube.com/watch?v=S8G0qRuWweA
- AWS re:Post (Kiro): https://repost.aws/articles/AROjWKtr5RTjy6T2HbFJD_Mw/
- BMAD-METHOD: https://github.com/bmad-code-org/BMAD-METHOD
- cc-sdd: https://github.com/gotalab/claude-code-spec
- SolidSpec: https://github.com/jyjeanne/solidspec
- SpecWright: https://github.com/amelmo/specwright
- Speculator: https://github.com/wbeard/speculator
- Specd: https://specd.app/blog/ai-prd-cursor-claude-code
- spec-kit-command-cursor: https://github.com/madebyaris/spec-kit-command-cursor
- claude-plugin-prd-workflow: https://github.com/Yassinello/claude-plugin-prd-workflow
- DEV Community (SDD 2026 guide): https://dev.to/krlz/spec-driven-development-in-2026-what-it-is-the-tooling-and-how-teams-actually-use-it-2fk2
- BCMS (SDD guide): https://thebcms.com/blog/spec-driven-development
- Redreamality (comparison): https://redreamality.com/blog/-sddbmad-vs-spec-kit-vs-openspec-vs-promptx/
- Specdriven (OpenSpec): https://specdriven.com/landscape/openspec
- Developer Toolkit (PRD workflow): https://developertoolkit.ai/en/claude-code/quick-start/prd-workflow/
