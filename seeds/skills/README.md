# Skills — Injectable Domain Knowledge

Skills are the **highest-leverage artifact** in SDD. A good skill prevents more
bugs than all hooks combined. Invest more time here than anywhere else.

## What a Skill Is

A structured knowledge base that gets injected into an agent's context when loaded.
Think of it as a company wiki that only opens to the relevant page.

## Folder Structure

```
.claude/skills/
└── <your-domain>/
    ├── SKILL.md              # Index + inviolable rules
    └── references/           # Deep-dive topic docs
        ├── vocabulary.md     # Canonical terms (prevents synonym confusion)
        ├── business-rules.md # Inviolable logic
        └── ...               # Whatever your domain needs
```

## Installation

Copy the `domain-template/` folder and rename it to your domain:

```bash
mkdir -p .claude/skills
cp -r domain-template .claude/skills/<your-domain>
```

Then edit `SKILL.md` and the reference files with your project's domain knowledge.

## How to Write a Good Skill

| Section | Purpose | Example |
|---------|---------|---------|
| Inviolable rules | Things that must NEVER be violated | "Orders only originate from quotes" |
| Vocabulary | Canonical terms so agents don't use synonyms | "Use 'customer', not 'client' or 'account'" |
| Schema gotchas | Non-obvious database traps | "The `status` column is an enum, not a string" |
| Approval gates | Who needs to sign off on what | "Pricing changes require sponsor approval" |
| Reference index | Routing table: task type → which file to read | "Before touching pricing → read references/pricing.md" |

## Domain Type Adaptation

- **Rigid domain** (B2B, regulated, enterprise): Emphasize inviolable rules + approval gates. Every rule is a hard constraint.
- **Fluid domain** (research, prototypes, internal tools): Emphasize vocabulary + patterns. Rules are guidelines, not gates.
- **Exploratory domain** (games, creative tools): Emphasize consistency anchors + shared-ui-inventory. The "rules" are about UX coherence, not business logic.

## How Agents Load Skills

Agents declare skills in their YAML frontmatter:

```yaml
skills:
  - <your-domain>
```

When the agent is invoked, the tool automatically loads `SKILL.md` into its context.
The agent then reads specific reference files on demand based on the routing table
in the reference index.
