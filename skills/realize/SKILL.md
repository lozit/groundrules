---
name: realize
description: Use when you have an approved plan and want to hand part of it to an autonomous loop. It partitions the plan into loop-safe ([loop]) vs human-supervised ([supervised]) tasks, refuses to loop anything without a re-runnable stop condition, and writes the loop-safe ones into loop/backlog.md. Requires loop scaffolding; defers to superpowers when present. The forward crossing from an approved plan to an executable backlog.
disable-model-invocation: true
allowed-tools: Read, Edit, Write, Bash, AskUserQuestion
---

# /groundrules:realize

You will turn an **approved plan** into a **partitioned backlog**: classify each task as **`[loop]`**
(safe for an autonomous maker/verifier loop) or **`[supervised]`** (needs a human), write the `[loop]`
tasks into `loop/backlog.md`, and **refuse to loop anything without a real, re-runnable stop condition**.
This is the *forward crossing* of [ADR 0027](../../docs/decisions/0027-reflection-realization-interactive-loop.md) §3 —
plan-mode output is ephemeral; realize is the step that **persists** it into something a loop can run.
All output is in **English**.

> **You are the reflection-side back pressure.** Having a plan is not clearance to loop it. Default to
> `[supervised]` on any doubt; **never auto-promote** a task to `[loop]` — the user confirms each one.
> Looping a task that hides a decision or has no stop condition is the single most expensive loop
> failure (the maker would guess and commit).

## Phase 0 — Preconditions

1. **Superpowers present?** If `docs/superpowers/plans/` exists → **defer and stop**: superpowers already
   *is* a maker/verifier realization pipeline; realize does not duplicate it. Tell the user groundrules
   contributes the memory layer (ADR/LEARNINGS/VISION) instead, and exit.
2. **Loop scaffolding present?** Read `.groundrules.json` → `loop.scaffolded`, and check the `loop/`
   directory exists. If **missing**, `AskUserQuestion`: `Generate loop/ now (inline)` / `I'll run
   bootstrap/adopt opt-in first` / `Cancel`.
   - `Generate inline` → create the `loop/` namespace by **following `bootstrap` Phase 5's loop
     file-mapping verbatim** (the single source of truth — `README.md.tpl` substituted; `maker.md`/
     `verifier.md`/`LOOP.md`/`run-loop.sh`/`backlog.md`/`gitignore` copied verbatim; runner `chmod +x`;
     insert `## Invariants` into `CLAUDE.md` after the last child of `## Conventions`). Don't re-specify
     the mapping here — read it from bootstrap so the two never drift. Set `loop.scaffolded: true` in
     `.groundrules.json`.
   - `bootstrap/adopt first` or `Cancel` → stop (no backlog target without scaffolding).
3. Otherwise continue.

## Phase 1 — Ingest the plan

`AskUserQuestion` for the source (one question): `Paste an approved plan` / `A PRD (give its path)` /
`Tasks already in PLAN.md`.

- **Paste** → ask the user to paste the approved plan; extract its discrete tasks.
- **PRD** → ask for the path (`docs/prd/<feature>.md`), `Read` it, take the tasks from its **Build plan**
  (and any task-like Success criteria).
- **PLAN.md** → `Read` `PLAN.md`, take the unchecked tasks from **In progress** / **Up next**.

Produce a flat **candidate task list**. If a "task" is really several, note it for decomposition (Phase 2).

## Phase 2 — Classify each task against the `[loop]` bar

Read `CLAUDE.md` → `## Invariants` first (so you can judge invariant-awareness). A task is `[loop]`
**only if it meets all five**:

1. **Atomic** — one unit of work; no "and also". A compound task → propose splitting it (below).
2. **Isolatable** — a bounded blast radius (a file/module), not a cross-cutting change rippling through
   the codebase.
3. **Verifiable by a behavioural acceptance test** — there is a **pre-written acceptance test** that
   (a) **exercises the task's specified behaviour** (a build/lint/typecheck is necessary but **not
   sufficient** — it doesn't prove the behaviour); (b) was **authored separately from the loop's maker**
   (by the human or this reflection session — writer ≠ maker, so the maker can't grade its own work);
   and (c) is **currently red** (fails before any implementation — red-first proves the test actually
   constrains). No such test yet → see *author-the-test* (Phase 3); a green or maker-authored test does
   **not** qualify.
4. **Invariant-aware** — implementing it won't require breaking a `## Invariants` rule.
5. **No embedded decision** — it doesn't hide a choice the plan/spec leaves open (how to handle an
   un-specified input, an API shape, a product behaviour).

**Classification rules:**
- Fails 1, 2, 4, or 5 → **`[supervised]`**, with the specific reason.
- Meets 1/2/4/5 but **has no red behavioural acceptance test** → it is a **`[loop]` candidate pending a
  test**: offer *author-the-test* (Phase 3). If the user declines to author one (or only a build/lint
  exists) → **`[supervised]`**, reason: *"no behavioural acceptance test — a loop can't verify the
  behaviour."* (Non-negotiable gate.)
- A test that is **already green** → not back pressure. Distinguish the two reasons: if the behaviour
  **already exists** (the task is effectively done) → **drop it** from the backlog (it's neither `[loop]`
  nor `[supervised]` — it's done); if the test is merely **too weak** (asserts nothing real, trivially
  green) → offer *author-the-test* to **strengthen it to red** (Phase 3); declined → `[supervised]`.
- Loop-worthy but **too big** → **propose a decomposition** into atomic sub-tasks (interactively). If the
  user declines to decompose → it stays `[supervised]`.
- **Any doubt → `[supervised]`.** Conservative by default.

> **TDD here is the loop-regime precondition only**, not a global rule (handoff-not-gospel, ADR
> 0010/0023). The interactive/`[supervised]` path needs no pre-written test — the human is its back
> pressure.

## Phase 3 — Propose the partition (the confirmation gate)

Show a clear per-task table: **task · proposed label · one-line rationale** (and the refusal reason for
any `[supervised]`-because-unverifiable). Then `AskUserQuestion` to confirm.

- The user may **veto / downgrade** any `[loop]` → `[supervised]` freely.
- The user may ask to **promote** a `[supervised]` → `[loop]`, but it must meet the bar: if it lacks a
  red behavioural acceptance test, **you still refuse** unless author-the-test (below) produces one.
- **Never write a `[loop]` task the user has not explicitly confirmed.**

### Author-the-test (for a `[loop]` candidate pending a test)

For each candidate that meets the structural bar (1/2/4/5) but lacks a red behavioural acceptance test —
whether it has **no test** or only a **weak/green** one — offer to author or strengthen one **now**.
This is the reflection-side, writer-≠-maker step that gives the loop its back pressure:

1. **Draft from the spec**: restate the task's behaviour as concrete cases (input → expected), then
   draft (or strengthen) the acceptance test in the project's existing test location/framework (read a
   sibling test to match the convention). When the stack is unobvious, propose the cases and let the
   **user write/paste** the test — authorship may be theirs; the gate is *a red test exists*, not who
   typed it.
2. **Confirm red — and red for the right reason**: run the test command; it **must fail**. Prefer a test
   that fails on a **behavioural assertion** (a wrong/absent value), not merely a missing import: a red
   that is only `ModuleNotFoundError`/`ImportError` proves the symbol is *absent*, not that the cases
   *constrain* behaviour — acceptable as a first red in greenfield, but the test must contain real
   assertions that would fail if the behaviour were wrong, not just if it's missing. If the test **can't
   be run here** (env not ready), accept the user's explicit "confirmed red" as their assertion.
3. Only a **red-confirmed** test promotes the candidate to `[loop]`; the backlog task names its command.
   No red test → stays `[supervised]`. Never edit the test afterwards to fit the implementation (that is
   the maker's forbidden move, and yours too).

> **What this gate does and doesn't guarantee.** It ensures the maker can't grade its own work
> (writer ≠ maker) and that the test actually constrains (red-first). It does **not** validate that the
> spec/test is *correct* — a wrong spec yields a wrong-but-green test. Catching a wrong spec is
> reflection's job (the human, upstream), not something realize can enforce.

## Phase 4 — Write the backlog

On confirmation:

1. **`[loop]` tasks → `loop/backlog.md`** (the loop reads only this file). Format each in the loop-safe
   shape brick 2's `maker.md` consumes, appended under `## Tasks`:
   ```
   - [ ] **<what> in `<where>`.** Acceptance test: `<command>` → exit 0 = green.
         Behaviour: <the precise, unambiguous spec>. Out of scope: <what NOT to touch>.
   ```
   - **Append in place with `Edit`** (don't Read-then-Write the whole file — that's an overwrite and
     races a concurrently-edited file). Add the new task lines under `## Tasks`. **Best-effort
     idempotence**: skip a task whose `<what>` + `<where>` already appears under `## Tasks` (exact-ish
     match — there are no task IDs, so a lightly-edited line may not be recognised; say so in the
     recap rather than promising a guarantee). If the placeholder line (`- [ ] <fill in your first
     loop-safe task>`) or the `<!-- Example shape ... -->` comment is still present, remove it.
2. **`[supervised]` tasks** — **tag `[supervised]` in place** so the partition is visible, and **persist
   the reason** (the partition's rationale is the valuable output — don't lose it):
   - From `PLAN.md` → prefix the task line in place: `[supervised] <task> — <why not looped>`.
   - From a paste/PRD → add them to `PLAN.md` under **## Up next** (freshly-ingested, not yet active),
     each as `[supervised] <task> — <why not looped>`.
   - If a task fails **several** bars, record the **primary** reason and note the others briefly.
   - Don't move or restructure anything else; use `Edit`, not a full rewrite.
3. **Never commit** (the user commits on their own; cf. groundrules git convention).

## Phase 5 — Recap

- **Looped** (N): list them → `loop/backlog.md`.
- **Supervised** (M): list them + the reason each wasn't looped (esp. the "no stop condition" refusals).
- **Commit the acceptance test(s) first** (and the `loop/backlog.md` you just wrote): each `[loop]`
  task's pre-written red test is the *frozen spec* — it must be **committed before the loop runs**, both
  so the spec is durable and so the verifier's "test untampered" check (which compares via `git diff`)
  has a tracked baseline. An untracked test = a guard that guards nothing. Remind the user (you don't
  commit — Phase 4 §3).
- **Next — run the loop. Two executors, choose by stakes** ([ADR 0031](../../docs/decisions/0031-goal-interop-swappable-loop-executor.md)):
  - **High-fidelity (the whole backlog):** `bash loop/run-loop.sh --max <N>` from the project root —
    fresh context per iteration, the verifier *re-runs the oracle*, parks decisions. The `MAX` cap is the
    anti-runaway.
  - **Light (one task, in-the-box):** Claude Code's `/goal` — paste a **command-based** condition
    derived from that task's acceptance command, e.g. `` /goal "the command `<test command>` exits 0" ``.
    Quicker, but its evaluator judges the *transcript*, not an independent re-run — see `loop/README.md`
    → *Two ways to run the loop*. For each `[loop]` task, **print its ready-to-paste `/goal` line** here.
  - realize itself does **not** create `loop/blocked.md`; *once you have run the loop* it may have parked
    decisions there — triage them then (re-decompose / decide → ADR / fix interactively — the backward
    crossing).

## Important rules

- **The guard** (ADR 0027 §4): could-act ≠ cleared-to-act. Propose; the user confirms each `[loop]`.
  Default `[supervised]` on doubt. The unverifiable-task refusal is non-negotiable.
- **Never overwrite** `loop/backlog.md` or `PLAN.md` — append / tag in place; idempotent on re-run.
- **Never commit**; **English-only**; this skill needs no network.
- realize only **produces** the backlog — it never launches the loop.
