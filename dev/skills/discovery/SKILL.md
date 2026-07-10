---
name: discovery
description: Stage 0 — refine an informal request into a structured prompt for the SDD pipeline.
disable-model-invocation: true
---

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
2. **Investigate codebase**: Does this exist partially? What entities/components are involved? What components/screens would be impacted? Is there a similar pattern already implemented? Are there relevant edge functions or migrations?
3. **Identify ambiguities** — ask at least one question from each category:
   - A. Persona behavior: "For persona X, what do they see/do when state Y?"
   - B. Feature flags: "Is there a feature flag involved? Is it a gate for application, visibility, or both?"
   - C. Retroactivity: "Does this affect existing records? Need backfill?"
   - D. Navigation: "Where does the user access this? (sidebar, settings, direct URL)"
   - E. Sponsor preferences: Check domain skill for established preferences
   - F. Generic: New screen or modification? New DB columns? MVP vs nice-to-have? Mobile?
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
- Preserve the original intent — don't reinterpret what the requester meant
