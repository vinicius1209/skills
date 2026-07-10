# Business Rules — Inviolable Logic

> These rules MUST be respected by all agents. Violating any of them
> can cause bugs in production, data corruption, or compliance issues.

## Rule 1: <Name>

**Description**: <what the rule enforces>
**Enforced where**: <frontend / backend / both>
**Consequence of violation**: <what breaks>
**Source**: <who decided this, when, or "domain convention">

### Implementation

- <where this rule is checked in code>
- <edge function / API endpoint that enforces it server-side>
- <UI component that enforces it client-side>

### Edge Cases

- <case 1>: <expected behavior>
- <case 2>: <expected behavior>

---

## Rule 2: <Name>

**Description**: <what the rule enforces>
**Enforced where**: <frontend / backend / both>
**Consequence of violation**: <what breaks>
**Source**: <who decided this, when, or "domain convention">

### Implementation

- <where this rule is checked in code>

### Edge Cases

- <case 1>: <expected behavior>

---

## Schema Gotchas

Non-obvious database traps that agents should know about:

| Gotcha | Description | Impact |
|--------|-------------|--------|
| <gotcha 1> | <description> | <what breaks if ignored> |
| <gotcha 2> | <description> | <what breaks if ignored> |
