<!-- generated-by: starter-kit v0.1.0 -->
# CLAUDE.md — {{PROJECT_NAME}}

This file guides Claude Code when working in this project. Read it fully before any non-trivial session.

## Project description

{{DESCRIPTION}}

## Tree and key file locations

- `README.md` — public presentation, installation, usage
- `CLAUDE.md` — this file: instructions for you
- `PLAN.md` — active plan/todo (if present). Keep it up to date during work.
- `docs/` — project documentation
  - `docs/decisions/` — ADRs (Architecture Decision Records). One file per structural decision.
  - `docs/LEARNINGS.md` — learnings throughout the project (flat file, reverse-chronological)
  - `docs/ARCHITECTURE.md` — snapshot of current architecture (if present)
  - `docs/GLOSSARY.md` — domain vocabulary (if present)
- `brief/` — upstream notes, raw specs, emails, brainstorms. Read at session start for domain context.
- `media/` — visual assets (images, mockups, videos)

## Conventions

### Commits

Conventional Commits:
- `feat:` new feature
- `fix:` bug fix
- `chore:` maintenance, config
- `docs:` documentation
- `refactor:` refactoring without behavior change
- `test:` test add/modify

Prefer small atomic commits. Don't mix refactoring and feature in one commit.

### Code

{{STACK}}

Prefer readability over cleverness. Avoid premature abstractions: three similar lines beat a conjectural abstraction.

## When to document

### ADR — propose a new document

As soon as a **structural decision** is made (tech choice, pattern, tradeoff), propose creating an ADR in `docs/decisions/`.

Format: copy `docs/decisions/0000-template.md` to `NNNN-title-kebab.md` (increment number). Fill Context, Decision, Consequences. Keep it short (< 1 page).

### LEARNINGS — add an entry

When a **non-trivial learning** emerges (a pitfall avoided, a convention discovered, a subtle bug), add a dated entry at the top of `docs/LEARNINGS.md`.

Format:
```
## YYYY-MM-DD — Short title
What was learned, why it matters.
```

Only write an entry if it has real value for a future reader. No noise.

### PLAN.md — keep updated

If present, update `PLAN.md` continuously:
- Check off completed tasks
- Add emerging tasks
- Note blockers

## Git workflow

- Only commit on explicit request (never auto-commit at the end of a task)
- Before committing, verify no secrets or debug files are included
- Feature branch for non-trivial changes

## Don't

- Don't add dependencies without confirming with the user
- Don't create new documentation files without need (prefer enriching existing ones)
- Don't generate code comments that paraphrase the code (the "what"). Reserve comments for non-obvious "why".
- Don't do opportunistic refactoring mid-feature

## Tech stack

{{STACK}}

## Notes

This project was bootstrapped with [starter-kit](https://github.com/guillaumeferrari/starter-kit) on {{DATE}}.
