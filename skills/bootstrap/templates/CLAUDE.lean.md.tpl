<!-- generated-by: starter-kit v0.10.0 -->
# CLAUDE.md — {{PROJECT_NAME}}

> **Relationship with the global CLAUDE.md**: this file is loaded **in addition to** the global CLAUDE.md (`~/.claude/CLAUDE.md` + managed enterprise policy) — it does not replace it. It holds **project-specific** content only. Do not restate global rules (commits, workflow, tool/MCP choices, verification, output conventions…). **On conflict, the global/enterprise rule wins.**

> **Lean** variant: a global CLAUDE.md was detected at generation time. For the full version (all generic sections), regenerate without the lean option.

## Description

{{DESCRIPTION}}

## Setup / Build / Test

> **Critical test**: a new dev (or Claude) must be able to run the project and its tests **on the first try** with the commands below.

- Install deps: `<fill in>`
- Run in dev: `<fill in>`
- Test: `<fill in>`
- Lint: `<fill in>`
- Build: `<fill in>`

## Key files and folders

- `README.md` — public presentation
- `CLAUDE.md` — this file (project-specific; the generic stuff lives in the global)
- `PLAN.md` — active todo (if present)
- `docs/` — project documentation (`docs/decisions/` ADRs, `docs/LEARNINGS.md`, etc.)
- `brief/` — upstream notes (domain context)
- `docs/media/` — visual assets

## Project-specific conventions

{{STACK}}

> Put here **only** what differs from or refines the global: code conventions specific to this repo, in-house patterns, known pitfalls. Cross-cutting rules (git, commits, tools, verification) live in the global CLAUDE.md.

## When to document

- **ADR** (`docs/decisions/`): any structural decision → copy `0000-template.md`.
- **LEARNINGS** (`docs/LEARNINGS.md`): any non-trivial learning, dated entry at the top.
- **PLAN.md**: check off done, add emergent tasks, note blockers.
- **Living docs**: every generated doc (`docs/VISION.md`, `docs/ARCHITECTURE.md`, `docs/DATA_MODEL.md`, `README.md`, `CHANGELOG.md`…) must be kept in sync **in the same change** that makes it stale — updating it is part of the task, not a follow-up.

## Updating this file

This file is living. When Claude gets something **project-specific** wrong, add the rule here. If the rule is cross-cutting, propose it for the global CLAUDE.md instead.

## Notes

Project bootstrapped with [starter-kit](https://github.com/lozit/claude-code-starter-kit) on {{DATE}}.
