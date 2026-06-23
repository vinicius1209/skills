# Spec-Driven Development (SDD) — A Generic Implementation Guide

> **What this is**: A portable blueprint for setting up Spec-Driven Development in any project using AI coding agents (Claude Code, OpenCode, Cursor, Aider, etc.). It provides reusable templates — "seeders" — you can plant into a new project.
>
> **What SDD solves**: AI agents left to their own devices produce inconsistent, context-blind code. SDD constrains them with a structured pipeline (Discovery → PRD → SPEC → Implementation → Tests → Review → PR), specialized agent roles, injectable domain knowledge (skills), canonical pattern references, and a manifest-based contract that tracks each feature from idea to merge.

---

## Table of Contents

1. [TL;DR — 2-Minute Version](#1-tldr--2-minute-version)
2. [When to Use / When NOT to Use SDD](#2-when-to-use--when-not-to-use-sdd)
3. [Tiered Adoption — MVP / Quality / Full](#3-tiered-adoption--mvp--quality--full)
4. [Folder Structure](#4-folder-structure)
5. [Core Concepts](#5-core-concepts)
6. [Setup Guide](#6-setup-guide)
7. [Seeder Files — Copy-Paste Templates](#7-seeder-files--copy-paste-templates)
8. [Troubleshooting & FAQ](#8-troubleshooting--faq)
9. [Success Metrics — Is SDD Working?](#9-success-metrics--is-sdd-working)
10. [Quick Reference Card](#10-quick-reference-card)

---

## 1. TL;DR — 2-Minute Version

**SDD is an assembly line for AI-assisted feature development.** Instead of asking an AI agent to "build feature X" and hoping for the best, you run each feature through a pipeline of specialized agents, each with scoped permissions and injectable domain knowledge.

### The Pipeline

```
  /discovery  →  /prd  →  /spec  →  /developer  →  /test-suite  →  /code-review  →  /pr
  (refine)      (what)    (how)     (build it)      (test it)       (check it)       (ship it)
                     ↑                      ↑
                approval gate         dev + dba in parallel
```

Or just run `/feature` — the orchestrator that does all of the above automatically.

### Minimum to Start (MVP tier — 30 min setup)

1. Create `.claude/` with 3 agents: `architect`, `dev`, `code-review`
2. Create 1 domain skill: `.claude/skills/<your-domain>/SKILL.md`
3. Create 2 references: `architecture.md`, `shared-ui-inventory.md`
4. Copy the manifest schema + template
5. Create 5 commands: `/feature`, `/prd`, `/spec`, `/developer`, `/pr`
6. Wire 1 hook: `auto-commit-plans.sh`

That's it. You now have a structured pipeline. Add tester, dba, qa-smoke, nightly-tests, and more hooks as you grow.

### Where to Find the Templates

All copy-paste-ready file contents are in [§7 Seeder Files](#7-seeder-files--copy-paste-templates).

---

## 2. When to Use / When NOT to Use SDD

### SDD is a good fit when...

- Your project has **recurring feature work** (not one-off scripts)
- You use AI agents **regularly** for implementation
- You have **business rules** that agents need to respect consistently
- You want **auditability** — who decided what, when, and why
- Multiple people (or multiple agent sessions) touch the same codebase

### SDD is overkill when...

- **Typo fixes, config tweaks, dependency bumps** — just do the change, no PRD needed
- **Prototypes / throwaway code** — SDD adds ceremony that slows exploration
- **Solo dev + simple domain** — if you can hold the whole domain in your head, the skill system is dead weight
- **No AI agents in the workflow** — SDD is designed for agent-driven development; without agents it's just heavy process

### Hotfix Fast Path

Not every change needs the full pipeline. For urgent production fixes:

```
fix branch  →  implement fix  →  /test-suite  →  /code-review  →  /pr
```

Skip discovery/PRD/SPEC. The manifest is optional for fixes. Use `/feature` only for actual features.

### The Rule of Thumb

> If the change requires you to think about **who sees what** or **what happens to existing data**, it needs SDD. If it's "change this string from A to B" or "bump this version", just do it.

---

## 3. Tiered Adoption — MVP / Quality / Full

Don't boil the ocean. Start at the tier that matches your project and grow as needed.

### Tier 1: MVP SDD (solo dev or small project, new codebase)

| Component | What you need | Effort |
|-----------|--------------|--------|
| Agents | `architect`, `dev`, `code-review` | 30 min |
| Commands | `/feature`, `/prd`, `/spec`, `/developer`, `/pr` | 20 min |
| Skills | 1 domain skill (`SKILL.md` only, no references) | 1 hour |
| References | `architecture.md`, `shared-ui-inventory.md` | 30 min |
| Manifest | Schema + template | 5 min |
| Hooks | `auto-commit-plans.sh` | 5 min |

**What you get**: Every feature gets a PRD with a Scenario Matrix, a SPEC with file-level detail, and a code review before PR. No more "the agent built the wrong thing."

**What you skip**: Tests, dba, qa-smoke, plan-sync, release, nightly-tests, most hooks.

### Tier 2: Quality SDD (small team, production project)

**Everything in Tier 1, plus:**

| Component | What you add | Why |
|-----------|-------------|-----|
| Agents | `tester`, `dba` (if DB) | Tests follow patterns; DB changes are safe |
| Commands | `/test-suite`, `/code-review` (formalized) | Tests generated for every change |
| References | `forms.md`, `dialogs.md`, `query-patterns.md`, `navigation-surfaces.md` | Agents follow UI/data conventions |
| Hooks | `check-pr-state.sh`, `verify-deliverables.sh`, `detect-stale-plans.sh` | Safety net grows |
| Skills | Domain skill gets `references/` subfolder with topic docs | Deep domain knowledge on demand |

**What you get**: Tests on every change, DB migrations validated, deliverables verified, stale plans detected.

### Tier 3: Full SDD (team, complex domain, CI/CD)

**Everything in Tier 2, plus:**

| Component | What you add | Why |
|-----------|-------------|-----|
| Agents | `qa-smoke` | Browser validation of Scenario Matrix |
| Commands | `/plan-sync`, `/release`, `/nightly-tests`, `/bootstrap-test-tracker`, `/annotate`, `/review` | Full lifecycle management |
| Hooks | `log-session-metrics.sh`, `log-tool.sh`, domain-specific hooks | Telemetry + custom safety gates |
| Plans | `nightly-tests/` with coverage tracker | Auto test generation |
| Processes | Release audit gates, doc-debt detection | Production safety |

**What you get**: Automated test coverage growth, release pipeline with audit gates, full telemetry, stale plan detection.

### Which Tier Are You?

| Your situation | Start at |
|---------------|---------|
| Solo dev, new project, simple domain | Tier 1 |
| Small team (2-5), production project, moderate domain | Tier 1 → grow to Tier 2 within a month |
| Team (5+), complex domain, CI/CD with releases | Tier 2 → grow to Tier 3 as maturity increases |
| Existing project with 50k+ lines, no SDD | See [§6.2 Adopting SDD in an Existing Project](#62-adopting-sdd-in-an-existing-project) |

---

## 4. Folder Structure

```
.claude/                          # or .ai/ — whatever your tool reads
├── settings.json                 # Hook wiring, agent config
├── settings.local.json           # Local overrides (gitignored)
│
├── agents/                       # AI team member definitions
│   ├── architect.md              # Plans features (read-only for prod code)
│   ├── dev.md                    # Implements application code
│   ├── dba.md                    # Database changes (if your project has a DB)
│   ├── tester.md                 # Writes tests
│   ├── code-review.md            # Reviews changes (read-only)
│   ├── qa-smoke.md               # Browser smoke tests (read-only)
│   └── references/               # Per-agent reference docs
│
├── commands/                     # Slash commands (pipeline stages)
│   ├── discovery.md              # Stage 0: Refine informal request
│   ├── feature.md                # Orchestrator: runs all stages
│   ├── prd.md                    # Stage 1: Generate PRD
│   ├── spec.md                   # Stage 2: Generate SPEC
│   ├── developer.md              # Stage 3: Implement SPEC
│   ├── test-suite.md             # Stage 3.5: Generate tests
│   ├── code-review.md            # Stage 4: Review changes
│   ├── pr.md                     # Stage 5: Create PR
│   ├── plan-sync.md              # Housekeeping: sync stale manifests
│   ├── release.md                # Release: develop → main
│   └── nightly-tests.md          # Automated nightly test generation
│
├── skills/                       # Injectable domain knowledge
│   └── <your-domain>/
│       ├── SKILL.md              # Skill index + inviolable rules
│       └── references/           # Deep-dive topic docs
│
├── references/                   # Canonical pattern docs
│   ├── architecture.md           # Layer rules, import hierarchy
│   ├── shared-ui-inventory.md    # Catalog of reusable components
│   ├── forms.md                  # Form conventions
│   ├── dialogs.md                # CRUD modal patterns
│   ├── query-patterns.md         # Data fetching conventions
│   └── navigation-surfaces.md    # All surfaces to update for new screens
│
├── schemas/
│   └── plan-manifest.schema.json # JSON schema for feature manifests
│
├── plans/                        # One folder per feature
│   ├── _manifest.template.json   # Copy this to start a new feature
│   └── {feature-slug}/
│       ├── manifest.json         # Stage tracker + artifact registry
│       ├── PRD.md                # Product Requirements Document
│       ├── SPEC.md               # Technical Specification
│       └── LOG.md                # Execution log
│
└── hooks/                        # Shell scripts for automation
```

---

## 5. Core Concepts

### 5.1 Agents — Your AI Team

Each agent is a markdown file with YAML frontmatter (name, description, model, disallowedTools, skills) + a prompt body (role, constraints, success criteria, failure modes).

**Key principles:**

1. **Read-only agents can't break production** — `architect`, `code-review`, and `qa-smoke` cannot write to `src/`
2. **Write-scoped agents stay in their lane** — `tester` only writes `*.test.*` files, `dba` only writes migrations
3. **Each agent has a "Failure Modes" section** — institutional memory. When an agent makes a mistake, add it here so it doesn't repeat
4. **Skills are declared in frontmatter** — the tool loads them automatically when the agent is invoked

**Generic roster (pick the ones you need — see [§3 Tiers](#3-tiered-adoption--mvp--quality--full)):**

| Agent | Role | Write Access | Tier |
|-------|------|-------------|------|
| `architect` | Plans features, generates PRD/SPEC | Only `.claude/plans/` | MVP |
| `dev` | Implements application code | `src/` (or equivalent) | MVP |
| `code-review` | Reviews uncommitted changes | Read-only | MVP |
| `tester` | Writes tests | `*.test.*` files only | Quality |
| `dba` | Database changes | Migrations, SQL | Quality |
| `qa-smoke` | Browser smoke tests | Read-only (reports to `.claude/plans/`) | Full |

**Full agent file templates**: [§7.1–7.4](#71-agent-architectmd)

---

### 5.2 Skills — Injectable Domain Knowledge

Skills are the **highest-leverage artifact** in SDD. A good skill prevents more bugs than all hooks combined. Invest more time here than anywhere else.

**What a skill is**: A structured knowledge base that gets injected into an agent's context when loaded. Think of it as a company wiki that only opens to the relevant page.

**Folder structure:**

```
skills/
└── <your-domain>/
    ├── SKILL.md              # Index + inviolable rules
    └── references/           # Deep-dive topic docs (Tier 2+)
        ├── vocabulary.md     # Canonical terms (prevents synonym confusion)
        ├── business-rules.md # Inviolable logic
        ├── schema-gotchas.md # DB surprises (if applicable)
        └── ...
```

**What makes a good skill:**

| Section | Purpose | Example |
|---------|---------|---------|
| Inviolable rules | Things that must NEVER be violated | "Orders only originate from quotes" |
| Vocabulary | Canonical terms so agents don't use synonyms | "Use 'customer', not 'client' or 'account'" |
| Schema gotchas | Non-obvious database traps | "The `status` column is an enum, not a string" |
| Approval gates | Who needs to sign off on what | "Pricing changes require sponsor approval" |
| Reference index | Routing table: task type → which file to read | "Before touching pricing → read references/pricing.md" |

**Adapting to your domain type:**

- **Rigid domain** (B2B, regulated, enterprise): Emphasize inviolable rules + approval gates. Every rule is a hard constraint.
- **Fluid domain** (research, prototypes, internal tools): Emphasize vocabulary + patterns. Rules are guidelines, not gates.
- **Exploratory domain** (games, creative tools): Emphasize consistency anchors + shared-ui-inventory. The "rules" are about UX coherence, not business logic.

**SKILL.md template**: [§7.5](#75-skill-skillmd-template)

---

### 5.3 Commands — The Pipeline

Commands are markdown files that define slash commands. Each receives `$1` as its argument and contains instructions for the orchestrator.

**Pipeline overview:**

```
  /discovery  →  /prd  →  /spec  →  /developer  →  /test-suite  →  /code-review  →  /pr
       │           │         │            │              │              │             │
    refine       what       how        build it       test it        check it      ship it
                    ↑                      ↑
              approval gate         dev + dba in parallel
```

Or just run `/feature` — the orchestrator that executes all stages sequentially with smart shortcuts (can resume from any stage via the manifest).

**Stage definitions:**

| Stage | Command | Agent | Output | Gate | Tier |
|-------|---------|-------|--------|------|------|
| 0 — Discovery | `/discovery` | Product Analyst | Structured prompt | User confirms | Quality |
| 1 — PRD | `/prd` | architect | `PRD.md` | **User approval (hard gate)** | MVP |
| 2 — SPEC | `/spec` | architect | `SPEC.md` | Auto | MVP |
| 3 — Implementation | `/developer` | dev + dba (parallel) | Code + migrations | Auto | MVP |
| 3.5 — Tests | `/test-suite` | tester | `*.test.*` files | Tests passing | Quality |
| 4 — Review | `/code-review` | code-review | Review report + manifest update | No critical issues | MVP |
| 5 — PR | `/pr` | PR Manager | GitHub PR | CI passing | MVP |
| — | `/plan-sync` | — | Manifest → `done` | Manual confirm | Full |
| — | `/release` | Release Manager | PR develop → main | Audit gates | Full |
| — | `/nightly-tests` | tester | Auto PRs | Cron | Full |

**Key design principles:**

1. **`$1` is the only input** — commands receive one argument (feature slug or description)
2. **Each command updates the manifest** — `stage` and `stages_completed` are updated after completion
3. **Each command appends to LOG.md** — creating an audit trail
4. **`/feature` is the orchestrator** — runs all stages sequentially, can resume from any stage
5. **`/clear` between stages** — context window is cleared between stages to avoid drift (the manifest carries state forward)

**Full command file templates**: [§7.6–7.12](#76-command-discoverymd)

---

### 5.4 Plans & Manifest — The Contract

Every feature gets a folder under `.claude/plans/{slug}/` with a `manifest.json` that tracks its lifecycle.

```
.claude/plans/{feature-slug}/
├── manifest.json     # Stage tracker + artifact registry
├── PRD.md            # Product Requirements Document
├── SPEC.md           # Technical Specification
└── LOG.md            # Execution log (append-only)
```

**The manifest is the source of truth.** If it says `stage: "implementation"` but the PR is merged, something is wrong. `/plan-sync` fixes this.

**Schema + template**: [§7.13–7.14](#713-manifest-schema)

#### Scenario Matrix — The Key PRD Artifact

The single most important artifact in SDD. It captures **who sees what and what happens** for every persona × state combination, forcing ambiguity to surface before any code is written.

```markdown
| Persona | State/Input | What they SEE in the UI | What happens in the BACKEND |
|---------|-------------|------------------------|----------------------------|
| Admin   | opens form  | full edit + override   | rule applied + logged       |
| User    | opens form  | read-only display      | rule applied server-side    |
| Guest   | opens form  | access denied          | 403 response                |
```

**Rules:**
- Minimum **3 rows** (one per persona + at least one edge case)
- Every cell must be filled — empty cells mean unresolved ambiguity
- The SPEC must map each row to specific files that implement it
- `qa-smoke` validates each row via browser automation (Tier 3)

---

### 5.5 References — Canonical Patterns

References are project-specific pattern documents that prevent agents from reinventing solutions. They are the single source of truth for "how we do things here."

**Recommended references by tier:**

| Reference | Purpose | Tier |
|-----------|---------|------|
| `architecture.md` | Layer rules, import hierarchy, folder structure | MVP |
| `shared-ui-inventory.md` | Catalog of reusable components — prevents reinvention | MVP |
| `navigation-surfaces.md` | All surfaces to update for new screens | Quality |
| `forms.md` | Form conventions (validation, layout, error display) | Quality |
| `dialogs.md` | CRUD modal patterns (width, scroll, button placement) | Quality |
| `query-patterns.md` | Data fetching conventions (cache, invalidation, keys) | Quality |

**How to write a good reference:**

A reference is not a tutorial. It's a **routing table** that tells agents "use this, not that." Structure it as:

1. **Pattern name** — what it's called
2. **When to use** — the condition that triggers this pattern
3. **Canonical file** — the file path that implements it best (the "gold standard")
4. **Key rules** — 3-5 bullet points of what matters
5. **Code example** — a minimal snippet from the canonical file
6. **Anti-patterns** — what NOT to do and why

```markdown
# <Topic> — Canonical Patterns

## Pattern 1: Standard Form Dialog

**When to use**: Any CRUD form in a modal
**Canonical file**: `src/features/billing/BillingFormDialog.tsx`
**Key rules**:
- Dialog width: sm:max-w-[600px] (< 7 fields) or sm:max-w-[700px] (>= 7)
- Scroll: max-h-[70vh] overflow-y-auto inside the form
- Save + Cancel both disabled during submission
- Errors inline (not toast); toasts only in mutation onError

**Anti-pattern**: Using a Sheet/slide-over for CRUD. Sponsor prefers Dialog.

**Navigation surfaces checklist** (when adding a new screen):
- [ ] Route in router config
- [ ] Sidebar/navigation item
- [ ] Settings card (if config-related)
- [ ] Breadcrumb label
```

**The golden rule**: Before creating any new component, the agent should check `shared-ui-inventory.md`. If something equivalent exists, use it. This single rule prevents more code duplication than any lint rule.

---

### 5.6 Hooks — Automated Safety Gates

Hooks are scripts triggered by tool events. They enforce rules that prompts alone can't guarantee.

**The concept is tool-agnostic**: "run a check when the agent does X." Different tools implement this differently:

| Tool | Mechanism | Config File |
|------|-----------|-------------|
| Claude Code | Bash scripts wired in settings.json | `.claude/settings.json` |
| OpenCode | Same (mirrors Claude Code) | `.opencode/` (symlinked) |
| Cursor | Custom rules / MCP servers | `.cursorrules` / MCP config |
| Aider | Pre-commit hooks / conventions | `.aider.conf.yml` |

**The implementations below use Claude Code's format** (bash scripts in `.claude/hooks/`, wired in `.claude/settings.json`). If you use a different tool, adapt the concept — the logic (what to check and when) is universal.

#### Hook Triggers

| Trigger | Fires When | Use For |
|---------|-----------|---------|
| `PreToolUse` | Before any tool invocation | Block invalid actions |
| `PostToolUse` | After a tool completes | Auto-stage files, log events |
| `SubagentStop` | When a subagent finishes | Verify deliverables |
| `Stop` | When the session ends | Log metrics |
| `SessionStart` | When a session begins | Detect stale plans |

#### Essential Hooks by Tier

| Hook | Trigger | Purpose | Tier |
|------|---------|---------|------|
| `auto-commit-plans.sh` | PostToolUse (Write\|Edit) | Auto-stage plan files on feature branches | MVP |
| `check-pr-state.sh` | PreToolUse (Bash) | Block commits on branches with merged PRs | Quality |
| `verify-deliverables.sh` | SubagentStop | Warn if manifest artifacts don't exist on disk | Quality |
| `detect-stale-plans.sh` | SessionStart | Alert on plans whose branch is already merged | Quality |
| `log-session-metrics.sh` | Stop | Track session stats to CSV | Full |

**Full hook scripts**: [§7.15](#715-essential-hooks)

#### Domain-Specific Hooks

These are project-specific — create them based on your domain's constraints. Examples:

| Hook | Trigger | Purpose |
|------|---------|---------|
| `validate-migration-timestamp.sh` | PreToolUse (Write) | Block DB migrations with timestamp ≤ last existing |
| `validate-no-deprecated-refs.sh` | PreToolUse (Write) | Block references to deprecated APIs/patterns |
| `warn-qa-skipped.sh` | SubagentStop | Warn if Scenario Matrix exists but not validated |

**When to add a domain-specific hook**: Every time an agent makes a mistake that a script could have caught, write the hook. Over months, your safety net grows automatically.

---

## 6. Setup Guide

### 6.1 Greenfield Setup (New Project)

#### Phase 1: Bootstrap (30 min)

1. **Create the folder structure**
   ```bash
   mkdir -p .claude/{agents,commands,skills,references,schemas,plans,hooks}
   ```

2. **Copy the manifest schema** from [§7.13](#713-manifest-schema) into `.claude/schemas/plan-manifest.schema.json`

3. **Copy the manifest template** from [§7.14](#714-manifest-template) into `.claude/plans/_manifest.template.json`

4. **Copy `settings.json`** from [§7.16](#716-settingstemplate) into `.claude/settings.json`

5. **Add to `.gitignore`**:
   ```
   .claude/settings.local.json
   .claude/metrics/
   ```

#### Phase 2: Define Your Domain (1–2 hours)

6. **Create your domain skill** — this is the most important step. Create `.claude/skills/<your-domain>/SKILL.md` using the template from [§7.5](#75-skill-skillmd-template).

7. **Write your domain references** (Tier 2+):
   - `vocabulary.md` — canonical terms
   - `business-rules.md` — inviolable rules
   - `schema-gotchas.md` — DB surprises (if applicable)

8. **Write your technical references**:
   - `architecture.md` — your layer/folder rules
   - `shared-ui-inventory.md` — reusable component catalog
   - `navigation-surfaces.md` — all surfaces to update for new screens

#### Phase 3: Define Your Agents (30 min)

9. **Create agent files** using the templates from [§7.1–7.4](#71-agent-architectmd). Start with the agents for your tier (see [§3](#3-tiered-adoption--mvp--quality--full)).

#### Phase 4: Create Commands (20 min)

10. **Copy the command templates** from [§7.6–7.12](#76-command-discoverymd) into `.claude/commands/`. Adapt `$1` handling and agent names to match your agents.

#### Phase 5: Wire Hooks (15 min)

11. **Copy the essential hooks** for your tier from [§7.15](#715-essential-hooks) into `.claude/hooks/`

12. **Make them executable**: `chmod +x .claude/hooks/*.sh`

#### Phase 6: First Feature (30 min)

13. **Run `/discovery`** with an informal feature description

14. **Run `/feature`** with the structured prompt from discovery

15. **Watch the pipeline** go through PRD → SPEC → Implementation → Tests → Review → PR

16. **Iterate** — after your first feature, you'll know which agents need tighter constraints, which references are missing, and which hooks would prevent mistakes.

---

### 6.2 Adopting SDD in an Existing Project

Adding SDD to a codebase with 50k+ lines is different from greenfield. You already have patterns, conventions, and business rules — they're just not documented in agent-readable form.

#### Step 1: Audit existing patterns (2–3 hours)

Before creating any agent or skill, understand what you already have:

```bash
# Count components by type
find src -name "*.tsx" | wc -l

# Identify your most-used UI patterns
grep -rl "Dialog" src/ | head -10
grep -rl "Form" src/ | head -10

# List your data fetching patterns
grep -rl "useQuery\|useSWR\|fetch(" src/ | head -10

# Check for existing tests
find src -name "*.test.*" | wc -l
```

#### Step 2: Reverse-engineer references from code

Don't write references from scratch — extract them from your best existing code:

1. **Pick the "gold standard" file** for each pattern (the cleanest, most-used implementation)
2. **Document it** in the reference file with the actual file path as the canonical example
3. **Note the anti-patterns** — find files that deviate from the standard and note why

Example: If you have 15 form dialogs, pick the best one, document its structure in `dialogs.md`, and cite it as the canonical file. Agents will follow that pattern for new dialogs.

#### Step 3: Extract domain rules from code

Your business rules are already encoded in code. The skill makes them explicit:

1. **Grep for validation logic**: `grep -r "if.*throw\|reject\|error" src/ | head -20`
2. **Grep for permission checks**: `grep -r "can\|permission\|role\|isAdmin" src/ | head -20`
3. **Find the "sacred" rules** — the ones where a bug caused an incident. Those become inviolable rules.
4. **Write them in the SKILL.md** with the consequence of violation

#### Step 4: Decide SDD scope

You don't have to run SDD for every change going forward. Pick a scope:

| Scope | When to choose |
|-------|---------------|
| **New features only** | You have a stable codebase, most work is new features |
| **New features + refactors** | You're actively improving the codebase |
| **Everything except hotfixes** | You want maximum safety (use the hotfix fast path from [§2](#2-when-to-use--when-not-to-use-sdd)) |

#### Step 5: Bootstrap with one pilot feature

Don't switch the whole team to SDD on day one. Pick one upcoming feature:

1. Run it through the full SDD pipeline manually (not `/feature` — run each command separately)
2. Note what broke, what was missing, what was overkill
3. Adjust agents, skills, and references based on the experience
4. Then switch to `/feature` for the second feature
5. Then roll out to the team

---

## 7. Seeder Files — Copy-Paste Templates

> Replace `<placeholder>` values with your project specifics. All files go under `.claude/`.

### 7.1 Agent: `architect.md`

```markdown
---
name: architect
description: |
  Use this agent for planning new features or significant changes. It investigates
  the codebase, identifies reusable patterns and existing components, then generates
  structured PRD.md and SPEC.md documents. Does NOT write implementation code.

  Examples:
  <example>
  user: "I need to add a notifications system"
  assistant: "I'll use the architect to investigate the codebase and generate a PRD."
  </example>

model: opus
color: "#a855f7"
disallowedTools:
  - NotebookEdit
skills:
  - <your-domain>
---

<Agent_Prompt>

<Role>
Senior Software Architect for <Project>. Investigates codebase + plans, NEVER implements
production code (only writes PRD/SPEC/manifest in .claude/plans/).
</Role>

<Project_Context>
- Stack: <your stack>
- Architecture: <your architecture>
- Language: <user-facing language>
</Project_Context>

<Hard_Constraints>
- NEVER Write/Edit in src/ (or equivalent) — implementation is dev/dba's job
- ALWAYS read applicable references/*.md BEFORE proposing patterns
- ALWAYS consult <your-domain> skill BEFORE proposing business rules
- NEVER invent business rules without citing source (domain skill or sponsor)
</Hard_Constraints>

<Success_Criteria>
PRD valid =
  [Scenario Matrix filled (>=3 rows: primary persona, secondary, edge case)]
  AND [Navigation Surfaces enumerated]
  AND [Consistency Anchors with file:line of canonical components]
  AND [Edge cases: retroactivity, permissions, empty state, error]
  AND [Explicit In-scope vs Out-of-scope]
  AND [Testable acceptance criteria linked to personas]

SPEC valid =
  [<= 1500 lines — if exceeds, split into sub-specs]
  AND [Sections marked @dev and @dba]
  AND [Each file to create: path + interfaces + pseudo-code]
  AND [Implementation checklist]
  AND [Test plan linked to Scenario Matrix]
  AND [manifest.json updated with promised_in_spec]
</Success_Criteria>

<Investigation_Protocol>
1. Read applicable references/*.md (always: architecture.md, shared-ui-inventory.md)
2. Consult <your-domain> skill for business rules
3. Investigate codebase with Grep/Read — cite file:line in >=80% of claims
4. If DB involved: invoke dba agent in parallel to map schema
</Investigation_Protocol>

<Output_Format>
PRD: save to .claude/plans/{slug}/PRD.md
SPEC: save to .claude/plans/{slug}/SPEC.md
Manifest: update .claude/plans/{slug}/manifest.json after each artifact
</Output_Format>

<Failure_Modes_To_Avoid>
1. Proposing UI without checking existing patterns
2. Forgetting navigation surfaces
3. Ambiguous behavior between personas
4. SPEC > 1500 lines (nobody reads it fully — split it)
5. Inventing business rules without consulting domain skill
6. Not citing file:line — unanchored claims are hallucinations
</Failure_Modes_To_Avoid>

</Agent_Prompt>
```

### 7.2 Agent: `dev.md`

```markdown
---
name: dev
description: |
  Use this agent for implementing application code, UI components, data fetching,
  and diagnosing performance issues. Ideal for implementing SPEC sections marked @dev.

  Examples:
  <example>
  user: "Implement the notification list component from the SPEC"
  assistant: "I'll use the dev agent to implement the frontend changes."
  </example>

model: inherit
color: "#3b82f6"
skills:
  - <your-domain>
---

You are a **Senior Engineer** for <Project>. You implement SPEC sections marked `@dev`
following the project's established patterns.

## Project Context
- Stack: <your stack>
- Architecture: <your architecture>

## Rules
1. Read the SPEC.md before implementing — follow the checklist order
2. Use path aliases (never relative imports across layers)
3. Follow references/*.md patterns — never reinvent what exists
4. All user-facing text in <your language>
5. Run `npx tsc --noEmit` after changes to verify types
6. Never suppress type errors (no `as any`, `@ts-ignore`)
```

### 7.3 Agent: `tester.md`

```markdown
---
name: tester
description: |
  Use this agent for writing tests, debugging test failures, improving coverage,
  and making testing strategy decisions.

  Examples:
  <example>
  user: "Generate tests for the files I just changed"
  assistant: "I'll use the tester agent to create tests following project patterns."
  </example>

model: inherit
color: "#f59e0b"
skills:
  - <your-domain>
---

You are a **QA Engineer** for <Project>. You write tests that follow project conventions.

## Rules
1. Tests live next to source files: `Component.tsx` + `Component.test.tsx`
2. Test names describe behavior: "should display X when Y"
3. Use test factories for mock data (never inline literals)
4. Cover: happy path + error + edge case
5. Run `npx vitest run <test-file>` to validate before finishing
6. Never delete failing tests to "pass" — fix the test or the code
```

### 7.4 Agent: `code-review.md`

```markdown
---
name: code-review
description: |
  Use this agent to review uncommitted changes against project standards.
  Analyzes modified files for convention violations, missing patterns, and quality issues.

  Examples:
  <example>
  user: "Review my changes before I commit"
  assistant: "I'll use the code-review agent to check for violations."
  </example>

model: inherit
color: "#ef4444"
disallowedTools:
  - Write
  - Edit
  - NotebookEdit
---

You are a **Senior Code Reviewer** for <Project>. You review uncommitted changes
and report violations — you NEVER modify code.

## Process
1. Analyze all modified files (staged + unstaged) via `git diff`
2. Check against references/*.md patterns
3. Classify issues: Red Critical / Yellow Important / Orange Warning
4. Run quality checks:
   - `npx vitest run` (tests)
   - `npx tsc --noEmit` (types)
   - `npm run lint` (linting)
5. Persist results in manifest.json verification fields
6. Report concisely — only real issues, no style nitpicks
```

### 7.5 Skill: `SKILL.md` Template

```markdown
---
name: <your-domain>
description: >
  Provides domain knowledge for <project name> — <list key topics>.
  Use when the task touches <list of entities/areas>.
---

# <Project> — Domain Knowledge

Domain knowledge for **<Project>**, <one-line description>. This file is an
index — open the reference file for the topic before implementing.

## Inviolable Rules

1. **<Rule 1>** — <description + consequence of violation>
2. **<Rule 2>** — <description + consequence of violation>
3. **<Rule 3>** — <description + consequence of violation>

## Operational Rules

- **<Rule>** — <description>
- **<Rule>** — <description>

## Approval Gates

Changes to the following areas require **explicit approval from <sponsor>**
before merge:
- <area 1>
- <area 2>

## Reference Files — When to Read Each

| Task Topic | Read Before | File |
|------------|-------------|------|
| <topic> | implementing <X> | `references/<file>.md` |
| <topic> | modifying <Y> | `references/<file>.md` |
```

> **Domain type adaptation**: If your domain is fluid/exploratory (not rigid/regulated), replace "Inviolable Rules" with "Guiding Principles" and drop the "Approval Gates" section. See [§5.2](#52-skills--injectable-domain-knowledge) for domain type guidance.

### 7.6 Command: `discovery.md`

```markdown
## Pipeline SDD: Stage 0 — Discovery (Request Refinement)

You are a **Product Analyst** who transforms informal requests into structured
prompts for the `/feature` command.

### Original request

$1

### Your job

Transform this request into a clear, actionable prompt, ensuring the architect
agent will have enough context to generate a PRD without ambiguity.

### Process

1. **Understand intent**: What is being asked? Why? For whom?
2. **Investigate codebase**: Does this exist partially? What entities/components are involved?
3. **Identify ambiguities** — ask at least one question from each category:
   - A. Persona behavior: "For persona X, what do they see/do when state Y?"
   - B. Retroactivity: "Does this affect existing records? Need backfill?"
   - C. Navigation: "Where does the user access this? (sidebar, settings, direct URL)"
   - D. Sponsor preferences: Check domain skill for established preferences
   - E. Generic: New screen or modification? New DB columns? MVP vs nice-to-have?
4. **Present analysis** to user with questions
5. **Generate structured prompt** after questions are answered:
   ```
   /feature "Action verb: What will be built
   Context: Problem/motivation in 1-2 sentences
   Requirements:
   - Functional requirement 1
   - Functional requirement 2
   Constraints:
   - Technical or scope constraint
   References in codebase:
   - Component/hook/table to reuse"
   ```

### Rules
- Never invent requirements — if not mentioned, ask
- Be specific about the codebase — cite real file paths
- Keep scope minimal — turn vague requests into well-defined MVPs
```

### 7.7 Command: `prd.md`

```markdown
## Pipeline SDD: Stage 1 — PRD (Product Requirements Document)

Use the **architect** agent to generate a PRD.md for the feature below.

### Feature requested

$1

### Instructions for architect

1. Read applicable references/*.md before proposing patterns
2. Consult <your-domain> skill for business rules
3. Investigate codebase for related components/hooks/queries/migrations
4. If DB involved: invoke dba agent in parallel to map schema

### Required PRD Structure

Save to `.claude/plans/{slug}/PRD.md`. Required sections:

1. **Overview** (1-2 paragraphs)
2. **Personas involved**
3. **Scenario Matrix** (MANDATORY — fill before any other decision):

   | Persona | State/Input | What they SEE | What happens in BACKEND |
   |---------|-------------|---------------|-------------------------|
   | <persona 1> | <state> | <ui> | <backend> |
   | <persona 2> | <state> | <ui> | <backend> |
   | <edge case> | <state> | <ui> | <backend> |

4. **Navigation Surfaces to update** (consult references/navigation-surfaces.md)
5. **Consistency Anchors** — 1-3 canonical components this feature MUST follow
6. **Edge cases**: retroactivity, permissions, empty state, loading/error
7. **In-scope** vs **Out-of-scope** (explicit delimitation)
8. **Acceptance criteria** (testable, linked to personas)
9. **Risks and mitigations**

### Next step

"PRD generated. Review the Scenario Matrix and Navigation Surfaces. If ambiguous,
adjust before SPEC. Then run `/spec {slug}`."
```

### 7.8 Command: `spec.md`

```markdown
## Pipeline SDD: Stage 2 — SPEC (Technical Specification)

Use the **architect** agent to generate SPEC.md from an existing PRD.

### Feature slug

$1

### Instructions for architect

1. Read the PRD entirely — Scenario Matrix, Navigation Surfaces, and Consistency
   Anchors must be filled. If missing, stop and go back to PRD.
2. Read applicable references/*.md
3. Validate Consistency Anchors by reading the referenced canonical files
4. If SPEC exceeds 1500 lines, split into sub-specs

### Required SPEC Structure

1. **Responsibility summary by agent** (@dev, @dba, @tester)
2. **For each file to CREATE**: path + TypeScript interfaces + pseudo-code + edge cases
3. **For each file to MODIFY**: path + description of change + before/after
4. **For each @dba migration**: full SQL, idempotent, timestamp validated
5. **Scenario Matrix cross-reference**: which files cover each matrix row
6. **Implementation checklist** (granular, per agent)
7. **Navigation Surfaces checklist** (copied from PRD)
8. **Test plan** — coverage for each scenario

### Next step

"SPEC generated. Run `/developer {slug}`. If @dba sections exist, dba runs in parallel."
```

### 7.9 Command: `developer.md`

```markdown
## Pipeline SDD: Stage 3 — Implementation

Use the **dev** agent to implement an existing SPEC.

### Feature slug

$1

### Instructions

1. Read the SPEC.md as implementation guide
2. If SPEC contains @dba sections, invoke dba agent IN PARALLEL
3. Follow project patterns defined in references/*.md
4. Implement in checklist order — respect file dependencies
5. Run `npx tsc --noEmit` after changes

### Next step

"Implementation complete. Run `/test-suite` to generate tests, or `/code-review`
to review directly."
```

### 7.10 Command: `code-review.md`

```markdown
## Pipeline SDD: Stage 4 — Code Review

Use the **code-review** agent to review uncommitted changes and persist
verification results in the manifest.

### Instructions

1. Analyze all modified files (staged + unstaged)
2. Follow the review checklist in agents/code-review.md
3. Classify issues: Red Critical / Yellow Important / Orange Warning
4. Run quality checks:
   ```bash
   npx vitest run 2>&1 | tail -5
   npx tsc --noEmit
   npx eslint $(git diff --name-only -- '*.ts' '*.tsx' | tr '\n' ' ') --quiet
   ```
5. Persist results in manifest.json:
   - verification.tests_passing
   - verification.type_check_passing
   - verification.build_passing
   - stage = "review"
6. Warn if Scenario Matrix exists but scenarios_validated != true

### Next step

"Review complete. Fix Red Critical issues (if any). Then run `/commit` or `/pr`."
```

### 7.11 Command: `pr.md`

```markdown
## Pipeline: feature/fix → develop

You are the **PR Manager**. Create structured PRs from feature branches to `develop`.

### Rules
- Never merge — only create the PR
- Never force push
- Target is always `develop`
- Check for existing PRs before creating

### Process
1. Verify branch state and check for existing PRs
2. Sync with develop (merge origin/develop, resolve conflicts if any)
3. Run quality checks (lint, tests on altered files)
4. Analyze changes (commits, files, migrations)
5. Push branch
6. Detect manifest and update stage to "pr" if found
7. Create PR with conventional commit title and structured body
8. Update manifest with PR URL

### PR Body Template
```
## Summary
<1-3 bullet points describing what changes and why>

## Changes
### Frontend (N files)
<list of modified files>

### Database (N migrations)
<list of migrations — omit if none>

### Tests (N files, M tests)
<list of test files>

## What does NOT change
<areas/modules not affected>

## Test plan
- [ ] <manual verification checklist>
- [ ] `npx vitest run` — all tests passing
```
```

### 7.12 Command: `feature.md` (Orchestrator)

```markdown
## SDD Pipeline — Feature End-to-End

You are the **orchestrator** of the SDD pipeline. Execute all stages automatically
using specialized agents (each runs in isolated context window).

### Feature requested

$1

### Execution Flow

Execute sequentially. Each agent gets its own context window.

---

#### Stage 0: Setup

1. Generate `{slug}` from description (e.g., "notification system" → `notification-system`)
2. Create branch `feature/{slug}` from develop
3. Create `.claude/plans/{slug}/` directory
4. Copy manifest template:
   ```bash
   cp .claude/plans/_manifest.template.json .claude/plans/{slug}/manifest.json
   # Edit slug, title, branch, created_at
   ```
5. Initialize LOG.md

**Smart shortcut**: If `.claude/plans/{slug}/manifest.json` already exists, read `stage`
and skip completed stages. Ask user: continue from where it stopped or restart?

---

#### Stage 1: PRD (agent: architect)

Invoke architect to generate PRD.md. Update manifest stage to "prd".

**Approval gate**: Present PRD summary (objectives, Scenario Matrix, Navigation Surfaces,
scope). Ask user to approve. If approved, set manifest.artifacts.prd.approved = true.

---

#### Stage 2: SPEC (agent: architect)

Invoke architect to generate SPEC.md from PRD.

---

#### Stage 3: Implementation (agents: dev + dba)

Invoke dev for @dev sections. If @dba sections exist, invoke dba IN PARALLEL.

---

#### Stage 4: Tests (agent: tester)

Invoke tester to generate tests for altered files. Run `npx vitest run` to validate.

---

#### Stage 5: Code Review (agent: code-review)

Invoke code-review to review all changes. Fix Red Critical issues before proceeding.

---

#### Stage 5.5: QA Smoke (if Scenario Matrix non-empty)

If manifest has scenario_matrix, invoke qa-smoke for Playwright validation.
Persist verification.scenarios_validated.

---

#### Stage 6: Commit

Stage relevant files. Create conventional commit.

---

#### Stage 7: Push & PR

1. Push branch to origin
2. Create PR to develop with structured body
3. Verify CI checks
4. Update manifest: stage = "pr", links.pr_url = <URL>

---

### General Rules
- Never skip stages
- Keep LOG.md updated after each stage
- Only approval gate is after PRD (Stage 1)
- If an agent fails, log the error, try once more, then stop and report
```

### 7.13 Manifest Schema

> Save to `.claude/schemas/plan-manifest.schema.json`

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "PlanManifest",
  "description": "Contract between SDD pipeline stages. Enables smart shortcuts, resume, and verify-deliverables.",
  "type": "object",
  "required": ["slug", "stage", "artifacts"],
  "properties": {
    "$schema": { "type": "string" },
    "slug": {
      "type": "string",
      "pattern": "^[a-z0-9][a-z0-9-]*$",
      "description": "Kebab-case feature identifier"
    },
    "title": { "type": "string" },
    "sponsor": { "type": "string" },
    "branch": { "type": "string", "pattern": "^feature/" },
    "created_at": { "type": "string", "format": "date-time" },
    "stage": {
      "type": "string",
      "enum": ["discovery", "prd", "spec", "implementation", "test", "review", "pr", "done"]
    },
    "stages_completed": {
      "type": "array",
      "items": {
        "enum": ["discovery", "prd", "spec", "implementation", "test", "review", "pr"]
      }
    },
    "artifacts": {
      "type": "object",
      "properties": {
        "prd": {
          "type": "object",
          "properties": {
            "path": { "type": "string" },
            "approved": { "type": "boolean" },
            "approved_at": { "type": ["string", "null"], "format": "date-time" }
          }
        },
        "spec": {
          "type": "object",
          "properties": {
            "path": { "type": "string" },
            "approved_at": { "type": ["string", "null"], "format": "date-time" }
          }
        },
        "migrations": { "type": "array", "items": { "type": "string" } },
        "source_files": { "type": "array", "items": { "type": "string" } },
        "tests": { "type": "array", "items": { "type": "string" } }
      }
    },
    "promised_in_spec": {
      "type": "object",
      "description": "Snapshot of SPEC promises — used by code-review and qa-smoke to validate delivery",
      "properties": {
        "scenario_matrix": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["persona", "input", "ui", "backend"],
            "properties": {
              "persona": { "type": "string" },
              "input": { "type": "string" },
              "ui": { "type": "array", "items": { "type": "string" } },
              "backend": { "type": "string" }
            }
          }
        },
        "navigation_surfaces": {
          "type": "array",
          "items": { "type": "string" }
        },
        "consistency_anchors": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "category": { "type": "string" },
              "canon_file": { "type": "string" },
              "reference_doc": { "type": "string" }
            }
          }
        }
      }
    },
    "verification": {
      "type": "object",
      "description": "Quality check results (true=pass, false=fail, null=not run yet)",
      "properties": {
        "scenarios_validated": { "type": ["boolean", "null"] },
        "all_nav_surfaces_updated": { "type": ["boolean", "null"] },
        "consistency_check_passed": { "type": ["boolean", "null"] },
        "tests_passing": { "type": ["boolean", "null"] },
        "build_passing": { "type": ["boolean", "null"] },
        "type_check_passing": { "type": ["boolean", "null"] }
      }
    },
    "links": {
      "type": "object",
      "properties": {
        "pr_url": { "type": ["string", "null"] },
        "issue_url": { "type": ["string", "null"] }
      }
    }
  }
}
```

### 7.14 Manifest Template

> Save to `.claude/plans/_manifest.template.json`

```json
{
  "$schema": "../schemas/plan-manifest.schema.json",
  "slug": "FEATURE_SLUG",
  "title": "Human-readable feature title",
  "sponsor": "<sponsor name>",
  "branch": "feature/FEATURE_SLUG",
  "created_at": "2024-01-01T00:00:00Z",
  "stage": "discovery",
  "stages_completed": [],
  "artifacts": {
    "prd": { "path": "PRD.md", "approved": false, "approved_at": null },
    "spec": { "path": "SPEC.md", "approved_at": null },
    "migrations": [],
    "source_files": [],
    "tests": []
  },
  "promised_in_spec": {
    "scenario_matrix": [],
    "navigation_surfaces": [],
    "consistency_anchors": []
  },
  "verification": {
    "scenarios_validated": null,
    "all_nav_surfaces_updated": null,
    "consistency_check_passed": null,
    "tests_passing": null,
    "build_passing": null,
    "type_check_passing": null
  },
  "links": {
    "pr_url": null,
    "issue_url": null
  }
}
```

### 7.15 Essential Hooks

#### `auto-commit-plans.sh` (PostToolUse — Write|Edit)

```bash
#!/bin/bash
# Auto-stages plan files when edited on a feature branch
BRANCH=$(git branch --show-current 2>/dev/null)
case "$BRANCH" in
  feature/*|fix/*)
    git add .claude/plans/ 2>/dev/null
    ;;
esac
```

#### `check-pr-state.sh` (PreToolUse — Bash)

```bash
#!/bin/bash
# Blocks git commits on branches whose PR is already merged
BRANCH=$(git branch --show-current 2>/dev/null)
case "$BRANCH" in
  feature/*|fix/*)
    PR_STATE=$(gh pr list --head "$BRANCH" --state merged --json number -q '.[0].number' 2>/dev/null)
    if [ -n "$PR_STATE" ]; then
      echo "PR #$PR_STATE for $BRANCH was already merged. Create a new branch."
      exit 1
    fi
    ;;
esac
```

#### `verify-deliverables.sh` (SubagentStop)

```bash
#!/bin/bash
# Warns if manifest declares artifacts that don't exist on disk
BRANCH=$(git branch --show-current 2>/dev/null)
SLUG=${BRANCH#feature/}
SLUG=${SLUG#fix/}
MANIFEST=".claude/plans/${SLUG}/manifest.json"

if [ -f "$MANIFEST" ]; then
  PRD_PATH=$(jq -r '.artifacts.prd.path // empty' "$MANIFEST")
  if [ -n "$PRD_PATH" ] && [ ! -f ".claude/plans/${SLUG}/${PRD_PATH}" ]; then
    echo "PRD declared in manifest but not found: ${PRD_PATH}"
  fi
  SPEC_PATH=$(jq -r '.artifacts.spec.path // empty' "$MANIFEST")
  if [ -n "$SPEC_PATH" ] && [ ! -f ".claude/plans/${SLUG}/${SPEC_PATH}" ]; then
    echo "SPEC declared in manifest but not found: ${SPEC_PATH}"
  fi
fi
```

#### `detect-stale-plans.sh` (SessionStart)

```bash
#!/bin/bash
# Scans manifests on startup and alerts if any active plan has its branch merged
for m in .claude/plans/*/manifest.json; do
  [ -f "$m" ] || continue
  stage=$(jq -r '.stage // ""' "$m")
  case "$stage" in
    done|cancelled|abandoned|"") continue ;;
  esac
  slug=$(jq -r '.slug // ""' "$m")
  [ -z "$slug" ] && continue
  merge=$(git log --merges --oneline 2>/dev/null | grep -E "feature/${slug}|fix/${slug}" | head -1)
  if [ -n "$merge" ]; then
    echo "Stale plan: ${slug} (stage=${stage}) — branch appears merged. Run /plan-sync."
  fi
done
```

#### `log-session-metrics.sh` (Stop)

```bash
#!/bin/bash
# Appends session metrics to CSV
METRICS_DIR=".claude/metrics"
mkdir -p "$METRICS_DIR"
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ),${SESSION_ID:-unknown}" >> "$METRICS_DIR/sessions.csv"
```

### 7.16 `settings.json` Template

> Save to `.claude/settings.json`

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "command": ".claude/hooks/auto-commit-plans.sh"
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "command": ".claude/hooks/check-pr-state.sh"
      }
    ],
    "SubagentStop": [
      {
        "command": ".claude/hooks/verify-deliverables.sh"
      }
    ],
    "Stop": [
      {
        "command": ".claude/hooks/log-session-metrics.sh"
      }
    ],
    "SessionStart": [
      {
        "command": ".claude/hooks/detect-stale-plans.sh"
      }
    ]
  }
}
```

> **Note**: This is Claude Code's format. If you use OpenCode, Cursor, or another tool, the concept is the same (run checks on tool events) but the config format differs. See [§5.6](#56-hooks--automated-safety-gates) for the tool-agnostic mapping.

---

## 8. Troubleshooting & FAQ

### The agent ignores my skill / references

**Symptom**: The agent proposes a pattern that contradicts what's in your SKILL.md or references.

**Causes & fixes:**

| Cause | Fix |
|-------|-----|
| Skill not declared in agent's frontmatter | Add `skills: [<your-domain>]` to the agent's YAML frontmatter |
| Reference not mentioned in the command instructions | Add "Read references/X.md before proposing patterns" to the command file |
| Skill is too long / vague | Trim to the essential rules. A 50-line skill that's always followed beats a 500-line one that's skimmed |
| Agent has too much context (SPEC > 1500 lines) | Split the SPEC into sub-specs (see §5.4) |

### The manifest drifts from reality

**Symptom**: Manifest says `stage: "implementation"` but the PR is already merged.

**Fix**: Run `/plan-sync`. It scans all manifests, finds ones whose branches are merged, and updates them to `stage: "done"`. The `detect-stale-plans.sh` hook (SessionStart) will also warn you on startup.

### The agent keeps reinventing components

**Symptom**: Agent creates a new dialog/form/table when a similar one already exists.

**Fix**: 
1. Make sure `shared-ui-inventory.md` exists and lists all reusable components with file paths
2. Add "ALWAYS check shared-ui-inventory.md before creating any new component" to the agent's Hard_Constraints
3. Add a `validate-no-reinvention.sh` hook that greps for new component files and checks if they duplicate existing ones

### The hook blocks legitimate work

**Symptom**: A hook prevents a valid action (e.g., migration timestamp validation blocks a legitimate migration).

**Fix**: 
1. Check if the hook logic is correct — maybe the timestamp format changed
2. If the hook is too strict, add an escape hatch (e.g., `SKIP_VALIDATION=1` env var)
3. Don't remove the hook — adjust it. Every hook exists because something went wrong before

### SDD feels too slow for small changes

**Symptom**: Running the full pipeline for a 1-line fix feels like overkill.

**Fix**: Use the [hotfix fast path](#2-when-to-use--when-not-to-use-sdd): skip discovery/PRD/SPEC, go directly to implementation → test → review → PR. The manifest is optional for fixes.

### Tests fail during `/test-suite`

**Symptom**: Generated tests fail on the first run.

**Fix**: The tester agent has up to 3 retry attempts built in. If it still fails:
1. Check if the test reveals a real bug (the code is wrong, not the test)
2. Check if the test factories/mocks are out of date with recent schema changes
3. Mark the item as `needs-review` in the tracker and move on (for nightly-tests)

### The agent proposes code in the wrong language

**Symptom**: Agent writes UI text in English when your project uses Portuguese (or vice versa).

**Fix**: Add `<Language>: <your language>` to the agent's `Project_Context` section. Add "All user-facing text in <language>" to the agent's Rules section.

### Two agents produce conflicting code

**Symptom**: `dev` and `dba` produce changes that conflict with each other.

**Fix**: The SPEC should clearly separate `@dev` and `@dba` sections with explicit interfaces between them. If conflicts occur, the SPEC didn't define the boundary clearly enough. Add more detail to the interface contract in the SPEC.

---

## 9. Success Metrics — Is SDD Working?

SDD adds ceremony. You should know whether that ceremony is paying off. Track these metrics:

### Leading Indicators (weekly)

| Metric | How to measure | Healthy |
|--------|---------------|---------|
| **Pipeline completion rate** | % of features that reach `stage: "done"` | > 80% |
| **PRD approval on first pass** | % of PRDs approved without changes | > 60% |
| **Scenario Matrix coverage** | Avg rows per PRD | >= 3 |
| **Reference compliance** | % of code-review findings that are "pattern not followed" | < 20% |

### Lagging Indicators (monthly)

| Metric | How to measure | Healthy |
|--------|---------------|---------|
| **Bugs per feature** | Bugs reported in first 30 days after merge | Trending down |
| **Rework rate** | % of PRs that require follow-up fixes within 7 days | < 15% |
| **Test coverage growth** | `coverage-tracker.json` coveragePercent over time | Trending up |
| **Stale plan count** | Plans stuck in non-done stages after 30 days | < 5 |

### How to collect

- **Pipeline metrics**: Parse `.claude/plans/*/manifest.json` with `jq`
- **Code review metrics**: Parse code-review reports (if you persist them)
- **Test coverage**: Use the nightly-tests coverage tracker
- **Bugs/rework**: Cross-reference git history with issue tracker

```bash
# Quick pipeline health check
for m in .claude/plans/*/manifest.json; do
  [ -f "$m" ] || continue
  slug=$(jq -r '.slug' "$m")
  stage=$(jq -r '.stage' "$m")
  approved=$(jq -r '.artifacts.prd.approved' "$m")
  echo "$slug | stage=$stage | prd_approved=$approved"
done
```

### When metrics say SDD isn't working

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| Pipeline completion < 50% | Too much ceremony for project size | Drop to a lower tier (§3) |
| PRD never approved on first pass | Skill/references are incomplete | Invest more in domain skill |
| Reference compliance < 50% | References don't match reality | Re-extract from gold-standard code (§6.2) |
| Bugs not decreasing after 3 months | Agents not following skills | Tighten agent constraints, add hooks |

---

## 10. Quick Reference Card

```
START HERE
  │
  ├─ /discovery "informal request"  →  structured prompt
  │
  ├─ /feature "structured prompt"   →  full pipeline (PRD→SPEC→impl→tests→review→PR)
  │     │
  │     ├─ /prd {slug}              →  PRD.md  (approval gate)
  │     ├─ /spec {slug}             →  SPEC.md
  │     ├─ /developer {slug}        →  code + migrations
  │     ├─ /test-suite              →  test files
  │     ├─ /code-review             →  review + manifest update
  │     └─ /pr                      →  GitHub PR
  │
  ├─ /plan-sync                     →  housekeeping (stale → done)
  ├─ /release                       →  develop → main PR
  ├─ /nightly-tests                 →  auto test generation (cron)
  ├─ /annotate                      →  mark tech debt in code
  └─ /review                        →  review + annotate debt

HOTFIX FAST PATH (skip SDD ceremony):
  fix branch → implement → /test-suite → /code-review → /pr

TIERS:
  MVP:     architect + dev + code-review | /feature /prd /spec /developer /pr | 1 skill | 2 refs | 1 hook
  Quality: + tester + dba | + /test-suite | + 4 refs | + 3 hooks | skill gets references/
  Full:    + qa-smoke | + /plan-sync /release /nightly-tests | + telemetry hooks | + coverage tracker
```

---

## Final Notes

1. **Start at Tier 1** — bootstrap with just `architect`, `dev`, and `code-review`. Add agents as your project needs them. See [§3](#3-tiered-adoption--mvp--quality--full).

2. **The domain skill is the highest-leverage artifact** — invest more time there than anywhere else. A good skill prevents more bugs than all hooks combined. See [§5.2](#52-skills--injectable-domain-knowledge).

3. **The Scenario Matrix is non-negotiable** — if your PRD doesn't have one, you're building on ambiguity. Every empty cell is a future bug. See [§5.4](#54-plans--manifest--the-contract).

4. **Hooks are institutional memory** — every time an agent makes a mistake that a hook could have prevented, write the hook. Over months, your safety net grows automatically. See [§5.6](#56-hooks--automated-safety-gates).

5. **The manifest is the source of truth** — if it says `stage: "implementation"` but the PR is merged, run `/plan-sync`. See [§8](#8-troubleshooting--faq).

6. **References prevent reinvention** — before creating any new component, the agent should check `shared-ui-inventory.md`. If something equivalent exists, use it. See [§5.5](#55-references--canonical-patterns).

7. **Not every change needs SDD** — use the [hotfix fast path](#2-when-to-use--when-not-to-use-sdd) for urgent fixes, typo corrections, and config tweaks.

8. **Adapt to your domain type** — rigid domains need inviolable rules + approval gates. Fluid domains need vocabulary + patterns. See [§5.2](#52-skills--injectable-domain-knowledge).

9. **Track metrics** — if you can't measure whether SDD is helping, you can't know when to adjust. See [§9](#9-success-metrics--is-sdd-working).
