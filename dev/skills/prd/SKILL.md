---
name: prd
description: Stage 1 — generate a PRD.md for a feature via the architect agent.
disable-model-invocation: true
---

## Pipeline SDD: Stage 1 — PRD (Product Requirements Document)

Use the **architect** agent to generate a PRD.md for the feature below.

### Feature requested

$1

### Instructions for architect

1. Read applicable `references/*.md` before proposing patterns (architecture.md, shared-ui-inventory.md always; conditionally: dialogs.md, forms.md, query-patterns.md, navigation-surfaces.md)
2. Consult your domain skill for business rules
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

   This matrix captures ambiguities before implementation. Without it, the feature is NOT ready for SPEC.

4. **Navigation Surfaces to update** (consult references/navigation-surfaces.md):
   - [ ] Route in router config
   - [ ] Sidebar/navigation item
   - [ ] Settings card (if config-related)
   - [ ] Breadcrumb label
5. **Consistency Anchors** — list 1-3 canonical components this feature MUST follow
6. **Edge cases**: retroactivity, permissions, empty state, loading/error
7. **In-scope** vs **Out-of-scope** (explicit delimitation)
8. **Acceptance criteria** (testable, linked to personas)
9. **Risks and mitigations**

### Next step

"PRD generated at `.claude/plans/{slug}/PRD.md`. Review the Scenario Matrix and Navigation Surfaces — if anything is ambiguous, adjust before the SPEC. Then run `/spec {slug}`."
