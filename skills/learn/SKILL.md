---
name: learn
description: Add a rule-format entry at the top of docs/LEARNINGS.md — Why + When to apply, short, no ceremony.
disable-model-invocation: true
allowed-tools: Read, Edit, AskUserQuestion, Bash
---

# /groundrules:learn

You will add a learning entry at the top of `docs/LEARNINGS.md` of the current project, in the **rule format** (the template format since ADR 0019: one actionable rule with *Why* and *When to apply*). All output is in **English**.

## Phase 1 — Checks

1. `docs/LEARNINGS.md` must exist in the cwd. Otherwise: warn and suggest `/groundrules:bootstrap`. Stop.

## Phase 2 — Collect the entry

If `$ARGUMENTS` is non-empty, use it as the **title** (the rule statement).

Ask via `AskUserQuestion` (a single call):

- **Title** — *states the rule*, imperative or "X: do Y" (e.g. "Anchor agent rituals to observable events"). Skip if already provided via `$ARGUMENTS`.
- **Why** — the story behind it: what happened and **what it cost** (a revert, a lost CI cycle, a 30+ min block and its fix, a confused user). Mention the date here.
- **When to apply** — the concrete trigger conditions, so the rule fires at the right moment next time.

Keep the answers **short**. If the user writes a wall of text, keep the essence; no hagiography.

## Phase 3 — Formatting

Entry format (the date lives inside **Why**, not in the title — the title is a timeless rule):

```markdown
## {TITLE — states the rule}

**Why**: {WHY — the story + what it cost, including the date}.

**When to apply**: {WHEN — the trigger conditions}.
```

## Phase 4 — Insertion

Read `docs/LEARNINGS.md`.

Find the `---` separator (the first one after the intro). New entries go **right after** that `---`, at the top (reverse-chronological).

Use `Edit` with:
- `old_string` = `\n---\n\n` (the separator as-is, with its line breaks)
- `new_string` = `\n---\n\n{FORMATTED ENTRY}\n\n` (the separator + the entry + a double break for spacing)

If the user already has entries and `---` no longer has the `\n---\n\n<!-- Example` shape, adapt: insert after the `---` respecting the existing format.

## Phase 5 — Recap

Show:
- ✅ Entry added to `docs/LEARNINGS.md`
- 📋 The rule title

**NEVER commit automatically.**

## Important rules

- **Rule format, not a journal note**: each entry is one actionable rule with *Why* (story + cost) and *When to apply* (triggers) — not a "Context/Lesson" diary entry. A long decision belongs in an ADR instead.
- Keep the entry **short**: it's a list of rules, not an essay.
- A blocker that cost 30+ min and its fix is a valid learning — the *Why* carries the cost.
- Keep the file's `generated-by` signature as-is (don't regenerate it here).
