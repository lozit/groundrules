---
name: add-adr
description: Use when a structural decision has been made (tech, pattern, tradeoff, naming) and you want to record it as a numbered ADR in docs/decisions/, with the index updated.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion
---

# /groundrules:add-adr

You will create a new **Architecture Decision Record** in the current project. All output is in **English**.

## Phase 1 — Project context

1. Check that `docs/decisions/` exists in the cwd. Otherwise: warn the user the project doesn't have the groundrules structure and suggest `/groundrules:bootstrap` first. Stop.
2. Compute the **next ADR number**:
   - `ls docs/decisions/[0-9]*.md 2>/dev/null`
   - Extract the NNNN prefix of each filename (ignore `0000-template.md`)
   - Next number = max + 1, formatted on 4 digits (e.g. `0003`)
   - If no existing ADR (excluding the template) → `0001`

## Phase 2 — Collect the info

If `$ARGUMENTS` is non-empty, use it as the raw **title** (the first line).

Otherwise, ask via `AskUserQuestion` (a single call, max 3 questions):

- **Short title** (1 sentence, e.g. "Database choice for analytics module")
- **Initial status**: `Proposed` (recommended) / `Accepted`
- **Mode**: `Skeleton` (just the template with placeholders to fill) / `Pre-filled` (ask 2 more questions for Context and Decision, 1-2 sentences each)

If `Pre-filled` mode, make a 2nd call:
- **Context (1-3 sentences)**: why this decision arises now
- **Decision (1-2 sentences)**: what is decided

## Phase 3 — Title slugification

Convert the title to kebab-case for the filename:
- All lowercase
- Strip accents (é→e, à→a, etc.)
- Non-alphanumeric characters → dash
- Consecutive dashes → a single dash
- Trim leading/trailing dashes
- Limit to ~60 characters

Example: `"Database choice for the analytics module"` → `database-choice-for-the-analytics-module`

Final name: `NNNN-{slug}.md`

## Phase 4 — Generation

1. Read the template: `${CLAUDE_PLUGIN_ROOT}/skills/bootstrap/templates/adr-template.md`
2. Substitutions to make in the read content:
   - `NNNN — Short decision title` → `NNNN — {provided title}`
   - `**Date**: YYYY-MM-DD` → today's date in ISO
   - `**Status**: Proposed | Accepted | ...` → `**Status**: {chosen status}`
   - Update the signature `<!-- generated-by: groundrules vX.Y.Z -->` to the current plugin version (read from `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`)
   - If `Pre-filled` mode: replace the Context and Decision sections with the provided sentences (leave Alternatives/Consequences/Notes with their placeholders)
3. Write to `docs/decisions/NNNN-{slug}.md` via `Write`.

## Phase 5 — Update the index

Read `docs/decisions/README.md`. Find the table row matching the last existing ADR (or the `| 0000 | Template | — | — |` row if it's the first ADR).

Insert **after that row** a new row:

```
| [NNNN](NNNN-{slug}.md) | {Title} | {Status} | {Date} |
```

Use the `Edit` tool with `old_string` = the previous row, `new_string` = the previous row + `\n` + the new row.

## Phase 6 — Recap

Show the user:
- ✅ Path of the new ADR created
- ✅ Assigned number
- 📋 Next steps:
  - Open the file and fill the Alternatives / Consequences sections
  - If `Skeleton` mode: fill Context and Decision

**NEVER commit automatically** — let the user decide when to commit.

## Important rules

- If an ADR with the same slug already exists → show the error, suggest a slightly different title.
- Don't overwrite an existing ADR.
- Keep the `generated-by` signature for consistency with the other project files.
