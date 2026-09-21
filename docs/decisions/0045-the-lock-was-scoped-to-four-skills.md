<!-- generated-by: groundrules v1.12.0 -->
# 0045 — `disable-model-invocation` was scoped to four skills and inherited by fifteen

**Date**: 2026-09-21
**Status**: Accepted — amends [ADR 0003](0003-multi-skill-architecture.md), which stands. This
narrows its scope to the skills its own argument covers; it reverses nothing.

## Context

ADR 0003 (2026-05-11) settled two questions at once: one skill per concern, and **manual
invocation only**. Its argument for the second is explicit and it is about *side effects*:

> *Both bootstrap and migrate have side effects (file writes, git operations, ADR/learning entries
> persisted on disk). add-adr and learn ask the user for content. In every case, the user is the
> right initiator — there's no scenario where Claude should silently run `bootstrap` because it
> inferred the user "probably wanted that".*

**That reasoning is correct, and it was written when the plugin had four skills.** The plugin now
has fifteen, and every one of them carries `disable-model-invocation: true`. The flag was inherited,
not re-argued: no later ADR extends 0003's scope, and the skills added since were never tested
against its criterion.

**The consequence was measured on 2026-09-21**, on a project that had the plugin installed for three
weeks: `docs/prd/` existed and was **empty**, `loop/backlog.md` existed and was **empty**, and no
loop had ever run. The methodology could not start, because **every entry point into it waits for a
human to type a slash command.** The plugin's own `Don't` list names the mechanism — *"`disable-model-invocation: true` hides the skill from auto-invocation: only the slash command works"* — so this
was understood at the level of the mechanism and never applied at the level of the set.

⚠️ **A methodology that only a human can start is not a methodology, it is a menu.** The repository
already carries the general form of this in its own learnings: a rule written where it is merely
reachable does not fire.

## Decision

**Apply ADR 0003's own criterion per skill, rather than to the set.** The question it asks is:
*does this skill have structural or irreversible side effects, such that the user is the only right
initiator?*

**Opening a skill takes two conditions, not one.** It must be **additive, reversible and under
version control** — the safety condition — **and** its being locked must **block a methodology from
starting** — the reason condition. The first says opening is *harmless*; the second says it is
*worth doing*. Either alone leaves a skill where it is.

**Stay locked** — a wrong firing damages or restructures a project, so the safety condition fails:
`bootstrap` · `migrate` · `adopt` · `slim` · `apply-best-practices`

**Become model-invokable** — both conditions hold:
`prd` · `realize` · `premortem` · `checkpoint` · `learn`

**Untouched** — safe, but nothing is blocked by their being locked, so the reason condition fails:
`add-adr` · `close` · `idea` · `vision` · `verify-bootstrap`

`close` is what proves the second condition is doing work rather than decorating the first. It is
the safest skill in the plugin — it only ever *proposes*, and never writes without a confirmation —
so on the safety condition alone it would be the strongest candidate of the fifteen. It stays locked
because a locked `close` blocks nothing from starting: it reconciles a methodology already running.
[ADR 0034](0034-posture-keep-the-diff-small.md) asks for the smallest change that does the job, and
opening it would not do a job.

The slash command keeps working for all fifteen; this only adds a second way in.

## Consequences

### Positive

- **The cycle can start without a human gesture**: a session that has agreed on a direction can
  write the PRD, partition it, and hand loop-safe tasks to the loop.
- **The back pressure that matters is untouched.** `realize` still refuses to mark any task `[loop]`
  without a re-runnable stop condition, and `run-loop.sh` keeps its mandatory iteration ceiling.
  Those fire by construction; the human signature per task never did more than delay them.
- **`premortem` becomes reachable at the moment it is useful** — before building, which is when a
  model can notice the need and a user usually cannot.

### Negative / Tradeoffs

- **A model may now write a PRD nobody asked for.** The cost is a markdown file in `docs/prd/`, under
  git, deletable in one command. Weighed against three weeks of an empty `docs/prd/`, that is the
  cheaper failure — but it is a real behaviour change for **every user of the plugin**, not only this
  repository, and it is the reason this is an ADR rather than a five-line edit.
- **`checkpoint` and `learn` may fire at boundaries the user did not choose.** Both are interactive:
  they ask before writing. The failure mode is an unwanted question, not an unwanted write.
- **The lock's protection is now per skill, so adding a skill requires the question to be asked
  again.** A new skill that restructures a project must carry the flag deliberately. That is a
  standing obligation this ADR creates and does not automate.
