<!-- generated-by: groundrules v1.3.0 -->
# CLAUDE.md — {{PROJECT_NAME}}

> **Relationship with the global CLAUDE.md**: this file is loaded **in addition to** the global CLAUDE.md (`~/.claude/CLAUDE.md` + managed enterprise policy) — it does not replace it. It holds **project-specific** content only. Do not restate global rules (commits, workflow, tool/MCP choices, verification, output conventions…). **On conflict, the global/enterprise rule wins.**

> **Lean** variant: a global CLAUDE.md was detected at generation time. For the full version (all generic sections), regenerate without the lean option.

## Session start — read first, in order

1. `PLAN.md` (current state) → 2. `docs/LEARNINGS.md` (learned rules) → 3. `docs/VISION.md` (scope) → 4. artifacts of the work in progress.

## Capture at checkpoints (don't wait to be asked)

The agent can't perceive "session end" — so capture at boundaries it *can* see, proactively: **before a `git push`/tag/release** (most reliable) or at a completed `PLAN.md` milestone. You can also trigger it any time with **`/groundrules:checkpoint`**. Route three questions: **decided** → `/groundrules:add-adr` · **learned** (incl. a 30+ min blocker + fix) → `/groundrules:learn` · **agent mistake/hallucination/drift caught** → `docs/AGENT-EVALS.md` (if present) + a guard here. If it's not in the repo, it's gone next session.

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
- `intake/` — upstream notes (domain context)
- `docs/media/` — visual assets

## Project-specific conventions

{{STACK}}

> Put here **only** what differs from or refines the global: code conventions specific to this repo, in-house patterns, known pitfalls. Cross-cutting rules (git, commits, tools, verification) live in the global CLAUDE.md.

## When to document

- **ADR** (`docs/decisions/`): any structural decision → copy `0000-template.md`.
- **LEARNINGS** (`docs/LEARNINGS.md`): any non-trivial learning, dated entry at the top.
- **PLAN.md**: check off done, add emergent tasks, note blockers.
- **The repo is the only memory**: project knowledge goes into the repo docs (`LEARNINGS`, `decisions/`, `PLAN.md`), never into machine-local agent memory/plans; no `~/.claude/*` references in repo docs.
- **Living docs**: every generated doc (`docs/VISION.md`, `docs/ARCHITECTURE.md`, `docs/DATA_MODEL.md`, `README.md`, `CHANGELOG.md`…) must be kept in sync **in the same change** that makes it stale — updating it is part of the task, not a follow-up.
- **Map, not territory**: this file is always-loaded — link to docs and read them on demand; don't paste doc content here (oversized context degrades the model and busts the cache). Doc-search/RAG tools are for large *external* corpora only; your own repo is read natively.

## Updating this file

This file is living. When Claude gets something **project-specific** wrong, add the rule here. If the rule is cross-cutting, propose it for the global CLAUDE.md instead.

## Notes

Project bootstrapped with [groundrules](https://github.com/lozit/groundrules) on {{DATE}}.
