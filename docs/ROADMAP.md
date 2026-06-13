<!-- generated-by: groundrules v1.3.3 -->
# ROADMAP — groundrules

Long-term direction: the **big milestones** we want to reach. This is the *vision* horizon —
distinct from [`PLAN.md`](../PLAN.md), which holds the **current-milestone** backlog and what's in
progress *now*. A milestone here is spec'd into PRDs (`docs/prd/`) and ADRs only when actually
tackled.

> Convention (cf. [ADR 0027](decisions/0027-reflection-realization-interactive-loop.md)): reflection
> produces the durable docs; realization (interactive **or** loop) consumes them. The repo is the
> only memory.

## Milestones

### M1 — Loop-readiness (groundrules as the reflection layer for loop execution)

Make a groundrules repo executable by an autonomous **loop**, not only by interactive sessions —
while staying the antidote to the *comprehension debt* loops create (ADRs/LEARNINGS/the *why*).
Decision recorded in [ADR 0027](decisions/0027-reflection-realization-interactive-loop.md);
implementation deferred to per-feature PRDs.

> **Defer to superpowers when present.** [superpowers](https://github.com/obra/superpowers) already
> *is* a loop-realization pipeline (spec → TDD plan → subagent maker/verifier). So M1's scaffolding
> targets the **non-superpowers case only**; when superpowers is detected, groundrules defers the
> *whole* realization (not just the PRD) and contributes the layers superpowers lacks: the
> PRD-altitude above (risks, success metrics) and durable memory (ADR/LEARNINGS/VISION). See the
> superpowers learning in `docs/LEARNINGS.md`.

- [ ] **Loop scaffolding, opt-in in `bootstrap`/`adopt`** (once per project): `maker`/`verifier`
      sub-agents, `LOOP.md`, a capped runner, an *Invariants* section in `CLAUDE.md`, the
      `blocked.md` convention. *(PRD needed)*
- [ ] **`/groundrules:realize`** — the forward bridge: transform an approved (plan-mode) plan into a
      *partitioned* backlog (atomic + verifiable + invariant-aware; `[loop]` vs `[supervised]`),
      refusing `[loop]` without a real stop condition. *(PRD needed)*
- [ ] **TDD-before-loop (acceptance test = back pressure).** The loop's verifiable stop condition is
      an **acceptance test authored in *reflection*** — the executable form of the PRD's *Success
      criteria*, written by someone other than the maker (writer/verifier separation). `realize`
      **gates `[loop]` on its existence**: no acceptance test → the task stays `[supervised]`. TDD is
      **not imposed globally** (handoff-not-gospel, ADR 0010/0023) — it is the *precondition of the
      loop regime only*; the interactive regime keeps the human as back pressure. Documentation
      surface: a note in `PRD.md.tpl` *Success criteria*; the `verifier` replays the pre-written
      acceptance test + the maker's unit tests.
      - *Open questions*: who authors the acceptance test when there is **no PRD** (a mini-spec at
        `realize` time?); can the `verifier` **reject a too-weak test** (a test that passes trivially
        is no back pressure)?
- [ ] **Backward crossing** — triage `blocked.md` (re-decompose / decide→ADR / interactive-fix) as a
      **convention** in the generated `CLAUDE.md` first; promote to a skill only if it earns it.
- [ ] **Template refinement** — sharpen "plan mode before any non-trivial task" into
      "interactive non-trivial → plan mode; atomic/testable/isolatable → spec + loop; decision → ADR".

### M2 — Support harnesses beyond Claude Code

The strategic reason the repo is named `groundrules` (harness-neutral). Keep the generated **output**
(docs/, CLAUDE.md, ADRs) harness-agnostic; only the *delivery* of the skills changes per harness
(Cursor, Codex/OpenAI, Gemini CLI, OpenCode…). Scope to be defined in its own ADR when tackled:
which harnesses first, how the Markdown SKILL instructions port vs. need per-harness adapters, and
the per-harness distribution model (there is no universal "plugin").

---

**Convention**: a milestone leaves this file and enters `PLAN.md` "In progress" when actively
worked; it is spec'd into a PRD (build) or ADR (decision) at that point, not before.
