---
name: prd
description: Write a per-feature PRD (problem, success criteria, scope, constraints, build plan, risks) before building a non-trivial feature. Defers to superpowers if that plugin is in use.
disable-model-invocation: true
allowed-tools: Read, Write, Bash, AskUserQuestion
---

# /groundrules:prd

You will create a **per-feature PRD** — a short spec written *before* building, so the agent builds the right thing instead of a coherent surprise (cf. "PRD first" — `intake/principles-claude-code.md` if present). All output is in **English**.

> A PRD is **per-feature** (the *how*, for one feature), distinct from `docs/VISION.md` (the project-wide *what/why*). It lives in `docs/prd/<feature>.md`.

## Phase 1 — Superpowers check (defer if present)

Detect whether the project uses **superpowers**: look for `docs/superpowers/plans/` or `docs/superpowers/specs/`. **Caveat**: superpowers lets the user override that location, so path detection can miss it — if superpowers seems in use but the default dirs are absent, **ask** rather than presume.

- **Present** → groundrules **defers the design/plan/TDD realization** to superpowers (its spec → TDD plan → maker/verifier pipeline). Don't duplicate it. A full groundrules PRD is usually redundant — tell the user: *"This project uses superpowers — its spec/plan workflow owns the per-feature design and build."* **One legitimate exception**: superpowers' spec covers context + design + scope but **not** risks, measurable success criteria, or problem/for-whom framing. If the user wants *that* altitude, offer a **thin PRD above** — only those sections, pointing to the superpowers spec for the design (no design duplication). Otherwise proceed below only if the user explicitly insists.
- **Absent** → continue; groundrules provides the full PRD.

## Phase 2 — Interview

If `$ARGUMENTS` is non-empty, use it as the **feature name**. Otherwise ask for it.

Then gather the PRD via `AskUserQuestion` (group 3-4 per call; the user may answer "to be defined" for any):

1. **Problem** — what need, for whom? (the *why*)
2. **Success criteria** — how will we know it's done? Make it **measurable**.
3. **Scope** — what's **in**, and explicitly what's **out**.
4. **Constraints** — technical, time, dependencies.
5. **Build plan** — ordered steps, each with a validation point.
6. **Risks** — what could go wrong + mitigation.
7. **Open questions** — anything still ambiguous (resolve before building).

Keep answers tight; synthesize, don't transcribe walls of text.

## Phase 3 — Generate

1. Read `${CLAUDE_PLUGIN_ROOT}/skills/bootstrap/templates/PRD.md.tpl`.
2. Substitute (plain `{{KEY}}` replace): `{{FEATURE}}`, `{{DATE}}` (today, ISO), `{{PROBLEM}}`, `{{SUCCESS}}`, `{{SCOPE_IN}}`, `{{SCOPE_OUT}}`, `{{CONSTRAINTS}}`, `{{BUILD_PLAN}}`, `{{RISKS}}`, `{{OPEN_QUESTIONS}}`. Use bullet lists where natural; "To be defined" rather than fabricated content where the user skipped.
3. Create `docs/prd/` if absent. Write to `docs/prd/<feature-kebab>.md`. **Never overwrite** an existing PRD without confirmation (offer skip / overwrite / save as `.new`).

## Phase 4 — Recap

- ✅ PRD created: `docs/prd/<feature>.md`
- 📋 Next: review it, resolve the open questions, then **build against it in plan mode** (`shift+tab`) — propose a step plan and wait for validation before writing code.

**NEVER commit automatically.**

## Important rules

- **Defer to superpowers when present** — don't duplicate the per-feature altitude it owns.
- PRD is a **starter**, fillable: structure provided, content from the user; `<fill in>` / "To be defined" over fabricated specifics.
- One PRD per feature; keep it short (it's a spec, not a novel). The project-wide vision stays in `docs/VISION.md`.
- Keep the file's `generated-by` signature as-is.
