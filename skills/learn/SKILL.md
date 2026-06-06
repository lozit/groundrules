---
name: learn
description: Add a dated entry at the top of docs/LEARNINGS.md — short, in place, no ceremony.
disable-model-invocation: true
allowed-tools: Read, Edit, AskUserQuestion, Bash
---

# /groundrules:learn

You will add a learning entry at the top of `docs/LEARNINGS.md` of the current project. All output is in **English**.

## Phase 1 — Checks

1. `docs/LEARNINGS.md` must exist in the cwd. Otherwise: warn and suggest `/groundrules:bootstrap`. Stop.

## Phase 2 — Collect the entry

If `$ARGUMENTS` is non-empty, use it as the **short title** (the first line).

Ask via `AskUserQuestion` (a single call):

- **Short title** (1 sentence, e.g. "Long task names break the spinner") — skip if already provided via `$ARGUMENTS`
- **Context** (1-2 sentences: what we were doing when we discovered this)
- **Lesson** (1-3 sentences: what we learned and how to apply it)

Keep the answers **short**. If the user writes a wall of text, keep the essence; no hagiography.

## Phase 3 — Formatting

Today's date in ISO format (YYYY-MM-DD).

Entry format:

```markdown
## {DATE} — {TITLE}

**Context**: {CONTEXT}
**Lesson**: {LESSON}
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
- 📋 The title and date

**NEVER commit automatically.**

## Important rules

- Keep the entry **short**: it's a journal, not an essay. If the user wants to write more, suggest an ADR or a section in `docs/` instead.
- If two entries are added on the same day, that's fine — both appear one after the other, the most recent on top.
- Keep the file's `generated-by` signature as-is (don't regenerate it here).
