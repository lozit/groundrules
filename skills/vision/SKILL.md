---
name: vision
description: Use when a project needs a strong docs/VISION.md and doesn't have one (e.g. an adopted/brownfield project), or when an existing vision is thin and you want to deepen or refresh it through a guided interview. On-demand; complements bootstrap's intent capture, does not replace it.
disable-model-invocation: true
allowed-tools: Read, Write, Bash, AskUserQuestion
---

# /groundrules:vision

You will build — or refresh — the project's **`docs/VISION.md`** through a **guided interview**, so the project has a strong anchor (goal, users, constraints, non-goals, acceptance criteria) instead of a half-filled template. All output is in **English**.

> This **complements** `bootstrap` (which captures intent at creation) — it does **not** replace it. Use it on-demand: for an `adopt`/brownfield project with no vision, or to deepen a thin one. Raw intent capture (`intake/INTENT.md`) stays `bootstrap`'s job.

## Phase 1 — Detect the existing VISION

Check for `docs/VISION.md`.

- **Absent** → **create flow**: run the full interview (Phase 2), then write.
- **Present** → **refine flow**: read it, spot the **thin/empty sections** (placeholders, "to be defined", one-liners). Tell the user what's already strong and what's thin, and interview **only the sections they want to deepen/refresh**, **section by section**. **Never overwrite silently** — apply only confirmed section changes; if the user prefers, write the result to `docs/VISION.md.new` instead (offer skip / overwrite-section / save-as-`.new`).

## Phase 2 — Interview (grouped, by theme)

Use `AskUserQuestion`, **grouped 3-4 per call, by theme** (never one giant prompt). Any item may be answered "to be defined". In the **refine flow**, interview only the section(s) the user chose to deepen (the same questions, scoped). The five sections map 1:1 to the template:

1. **Goal** — the *why*: the problem and the change it makes. One sharp paragraph beats five vague ones.
2. **Users / personas** — who it's for, and what each needs.
3. **Constraints** — technical, time, legal, dependencies.
4. **V1 non-goals** — what is explicitly **out of scope** for V1 (the most-skipped, highest-value section).
5. **V1 acceptance criteria** — how you'll *know* V1 succeeded — make them **measurable**.

Borrowed interview discipline (keep our register — propose, don't impose):
- At a framing fork, **propose 2-3 framings with a recommendation** and the tradeoffs, rather than an open "what's your goal?".
- If the request describes **multiple independent subsystems** (an over-scoped blob), **flag it** and suggest **decomposing** into sub-projects/phases before writing one unbounded vision.
- **Synthesize, don't transcribe** — tighten the user's answers into crisp vision prose.

## Phase 3 — Vision self-review, then write

**Before writing**, run a quick self-review (borrowed from superpowers, see `docs/LEARNINGS.md`):
- **Placeholder scan** — no "TBD / handle later / etc." left in a section the user actually answered.
- **Internal consistency** — goal, users, and acceptance criteria point the same way (no acceptance criterion for a user the goal doesn't serve).
- **Ambiguity** — vague acceptance criteria ("works well", "fast") get pushed to **measurable** form, or marked "to be defined".

Then, **by flow** — the two paths write differently:

**Create flow** (no existing VISION):
1. Read `${CLAUDE_PLUGIN_ROOT}/skills/bootstrap/templates/docs-VISION.md.tpl`.
2. Determine `{{PROJECT_NAME}}` — the `README.md`/`CLAUDE.md` H1, else the repository directory name. Ask only if genuinely ambiguous.
3. Substitute (plain `{{KEY}}` replace): `{{PROJECT_NAME}}`, `{{INTENT_SOURCE}}` = `guided interview (/groundrules:vision), <today>` (get the date via `date +%F`), `{{GOAL}}`, `{{USERS}}`, `{{CONSTRAINTS}}`, `{{NONGOALS}}`, `{{ACCEPTANCE}}`. Use "To be defined" where the user skipped — never fabricate.
4. Write `docs/VISION.md`.

**Refine flow** (existing VISION):
- **Edit only the confirmed section(s) in place** — do **not** rebuild from the template. Leave the header, the `Source:` line, the footer, and every unconfirmed section exactly as they are (don't "upgrade" the file's shape).
- **Never overwrite without confirmation**; if you cannot confirm (or the user prefers), write the result to `docs/VISION.md.new` instead.

## Phase 4 — Recap

- ✅ `docs/VISION.md` created / refreshed.
- 📋 Next: review it; it anchors `docs/` and is required by `/groundrules:apply-best-practices`. Update it when the intent evolves (rare — tactical decisions go in `docs/decisions/`).

**NEVER commit automatically.**

## Important rules

- **Complement, don't replace** `bootstrap` — never touch its flow; don't seed `intake/INTENT.md`.
- **Reuse the existing VISION structure** (`docs-VISION.md.tpl`); no new doc shape.
- **Never overwrite** without confirmation (resume mode: skip / overwrite / `.new`).
- **Propose, don't impose** — borrow superpowers' interview *structure*, never its coercive tone.
- Keep the file's `generated-by` signature as-is.
