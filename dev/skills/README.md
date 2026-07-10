# Skills — Domain Knowledge + Pipeline Steps

Skills are the **highest-leverage artifact** in SDD. This kit ships **two kinds**:

1. **`domain-template/`** — auto-invocable domain knowledge. Claude loads it on its
   own when a task is relevant to your domain.
2. **Pipeline skills** (`discovery`, `prd`, `spec`, `developer`, `test-suite`,
   `code-review`, `pr`, `plan-sync`, `feature`) — deliberate steps of the
   Spec-Driven Development pipeline. Each carries `disable-model-invocation: true`
   so Claude never auto-triggers them; **only the user runs them** via `/<name>`.

> These pipeline steps are delivered as Skills (the unified modern form). You could
> also drop them into `.claude/commands/` as plain slash-command `.md` files — both
> create `/<name>`. We use skills here for `disable-model-invocation` and cleaner
> packaging.

---

## Part 1 — Domain Knowledge Skill (`domain-template/`)

A good domain skill prevents more bugs than all hooks combined. Invest more time
here than anywhere else.

### What a Skill Is

A structured knowledge base that gets injected into an agent's context when loaded.
Think of it as a company wiki that only opens to the relevant page.

### Folder Structure

```
.claude/skills/
└── <your-domain>/
    ├── SKILL.md              # Index + inviolable rules
    └── references/           # Deep-dive topic docs
        ├── vocabulary.md     # Canonical terms (prevents synonym confusion)
        ├── business-rules.md # Inviolable logic
        └── ...               # Whatever your domain needs
```

### Installation

Copy the `domain-template/` folder and rename it to your domain:

```bash
mkdir -p .claude/skills
cp -r domain-template .claude/skills/<your-domain>
```

Then edit `SKILL.md` and the reference files with your project's domain knowledge.

### How to Write a Good Skill

| Section | Purpose | Example |
|---------|---------|---------|
| Inviolable rules | Things that must NEVER be violated | "Orders only originate from quotes" |
| Vocabulary | Canonical terms so agents don't use synonyms | "Use 'customer', not 'client' or 'account'" |
| Schema gotchas | Non-obvious database traps | "The `status` column is an enum, not a string" |
| Approval gates | Who needs to sign off on what | "Pricing changes require sponsor approval" |
| Reference index | Routing table: task type → which file to read | "Before touching pricing → read references/pricing.md" |

### Domain Type Adaptation

- **Rigid domain** (B2B, regulated, enterprise): Emphasize inviolable rules + approval gates. Every rule is a hard constraint.
- **Fluid domain** (research, prototypes, internal tools): Emphasize vocabulary + patterns. Rules are guidelines, not gates.
- **Exploratory domain** (games, creative tools): Emphasize consistency anchors + shared-ui-inventory. The "rules" are about UX coherence, not business logic.

### How Agents Load Skills

Agents declare skills in their YAML frontmatter:

```yaml
skills:
  - <your-domain>
```

When the agent is invoked, the tool automatically loads `SKILL.md` into its context.
The agent then reads specific reference files on demand based on the routing table
in the reference index. The domain skill can also auto-invoke for relevant tasks
(no `disable-model-invocation` flag).

---

## Part 2 — Pipeline Skills (user-invoked SDD stages)

These form the Spec-Driven Development pipeline. Each skill is a `SKILL.md` that
instructs the AI orchestrator on what to do, which agent to invoke, and what
artifacts to produce. They all set `disable-model-invocation: true`, so they fire
**only** when you type `/<name>` — never automatically.

### Pipeline Overview

```
/discovery → /prd → /spec → /developer → /test-suite → /code-review → /pr
 (refine)    (what)  (how)    (build it)    (test it)     (check it)    (ship it)
```

Or run `/feature` — the single skill that orchestrates all of the above stages
automatically.

### Pipeline Skills

| Skill | Stage | Agent | Output | Gate |
|-------|-------|-------|--------|------|
| `/discovery` | 0 | Product Analyst | Structured prompt | User confirms |
| `/feature` | All | Orchestrator | Full pipeline | PRD approval |
| `/prd` | 1 | architect | PRD.md | **User approval** |
| `/spec` | 2 | architect | SPEC.md | Auto |
| `/developer` | 3 | dev + dba | Code + migrations | Auto |
| `/test-suite` | 3.5 | tester | Test files | Tests passing |
| `/code-review` | 4 | code-review | Review report | No critical issues |
| `/pr` | 5 | PR Manager | GitHub PR | CI passing |
| `/plan-sync` | — | — | Manifest → done | Manual confirm |

### Installation

Copy each pipeline skill folder into your project's `.claude/skills/` directory:

```bash
mkdir -p .claude/skills
cp -r discovery prd spec developer test-suite code-review pr plan-sync feature \
  .claude/skills/
```

(They live next to your domain skill — `.claude/skills/<your-domain>/` and
`.claude/skills/discovery/`, etc.)

### Key Concepts

- **`$1` / `$ARGUMENTS`** is the input — pipeline skills receive one argument (feature slug or description). Placeholders work identically inside `SKILL.md`.
- **Each step updates the manifest** — `stage` and `stages_completed` advance after completion.
- **Each step appends to LOG.md** — creating an audit trail.
- **`/feature` can resume** — reads the manifest and skips completed stages.
- **`/clear` between stages** — clear the context window between stages to avoid drift (the manifest carries state forward).

### Placeholders to Replace

Before using these skills, replace:
- `<your-domain>` → your actual domain skill name
- `<your-project>` → your project name
- `<your-github-account>` → your GitHub username
- `<your-repo>` → your repository name
