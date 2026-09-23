<!-- generated-by: groundrules v1.12.0 -->
# 0047 — `AGENTS.md`: deferred to M2, with the measurements taken now

**Date**: 2026-09-23
**Status**: Accepted (the decision is to defer; the trigger is named below)

## Context

[`AGENTS.md`](https://agents.md) is an open specification for a single, predictable file carrying
project context for AI coding agents — *a README for agents*. Formalised in August 2025 under
OpenAI's lead with Google, Cursor and Factory, donated to the Linux Foundation's Agentic AI
Foundation in December 2025, and reported at 60,000+ repositories and 20+ supporting tools. Plain
Markdown, **no required schema**: the spec says *"use any headings you like; the agent simply parses
the text you provide."* In a monorepo the nearest file in the tree wins.

This plugin generates `CLAUDE.md` and has **no mention of `AGENTS.md` anywhere**, while
[M2](../ROADMAP.md) states the harness-neutral direction outright: *"keep the generated output
harness-agnostic; only the delivery of the skills changes per harness."* That is a gap between a
recorded direction and what the plugin ships, and it surfaced from a third-party guide that merely
named the file without arguing for it.

**The spec does not settle the question**: it says nothing about coexisting with tool-specific files
like `CLAUDE.md`. Only the harness does, so the behaviour was measured rather than read.

### Measured on 2026-09-23, Claude Code 2.1.280

Three throwaway directories, each with distinctive markers, queried by a fresh `claude -p` with all
read tools disabled — so the answer comes from what was *loaded*, not from what it could open:

| Files present | Loaded |
|---|---|
| `AGENTS.md` alone | `AGENTS.md` |
| `AGENTS.md` **and** `CLAUDE.md` | **`CLAUDE.md` only** — the other is ignored |
| `CLAUDE.md` containing `@AGENTS.md` | **both** |

**This kills the cheapest-looking option.** An `AGENTS.md` pointing at `CLAUDE.md`, sitting beside
it, is **read by no Claude Code session**. It would serve other tools only, while looking installed
to anyone reading the repository — the failure class this repository has logged twice this week.

### The other two measurements

**Content**: of the 199 lines of `CLAUDE.md.tpl`, **~86% owe nothing to Claude Code**. The
harness-bound lines are 9 citing a `/groundrules:*` command and 18 citing the interface or the
`.claude/` tree, and they **cluster** — `### Permissions and settings`, `## Claude Code workflow`,
and the `.claude/` subtree under `## Key files and folders`. It is not a diffusion.

**Cost**: `CLAUDE.md` is referenced **77 times across 10 skills** (`bootstrap` 20, `adopt` 17,
`slim` 11, `migrate` 10…) and in 10 templates. A rename is invasive and would need a migration for
every existing project. The import pattern is additive, but not free: `slim` measures a 200-line
budget that would then span two files, and `verify-bootstrap` would need to know about the second.

## Decision

**Defer. Nothing changes in the plugin now.** No `AGENTS.md` is generated, no template splits, no
skill learns a second filename.

**The trigger is [M2](../ROADMAP.md) — *support harnesses beyond Claude Code*.** M2's own ADR is the
place this belongs, because the question is only worth answering alongside *which harnesses first*
and *how the skills are delivered per harness*. Answering it alone would commit the output format
before the delivery model it is meant to serve exists.

**What the measurements buy, and why they are recorded rather than re-derived**: they expire slowly
(a spec and a file layout), while the effort to obtain them is a guide-agent round trip plus three
`claude -p` runs. Re-deriving them at M2 would cost the same again and risk a different answer from
a different method.

**The recommendation to carry into M2, should it be taken**: `CLAUDE.md` **imports** `@AGENTS.md`,
which holds the portable content; `CLAUDE.md` keeps the import line and the three harness-bound
blocks. Not a pointer — measured dead. Not a rename — cost without a matching benefit today.

**One argument found along the way that stands on its own**, independent of any harness: the
methodology's entry points are currently written *as commands* (*"decided → `/groundrules:add-adr`"*),
which is meaningless to any other tool and to a human reading the repository without the plugin
installed. Splitting the file forces the portable half to state **the act and the place** — *record
the decision as an ADR in `docs/decisions/`* — with the command as a shorthand beside it. That is a
better generated file whatever happens to `AGENTS.md`, and it would probably never be written
without this constraint. **It does not need M2**; if M2 is never tackled, it is still worth doing.

## Alternatives considered

- **Generate a pointer `AGENTS.md` now** — rejected on measurement, not on taste: with a `CLAUDE.md`
  present it is read by nothing, and a file that looks installed and is inert is worse than its
  absence.
- **Rename the generated file to `AGENTS.md`** — rejected for now: 77 references across 10 skills,
  10 templates, and a migration for every bootstrapped project, to serve a portability nobody has
  yet asked for. Reconsider at M2, where the delivery model makes it a real question.
- **Adopt the import pattern now** — the option this ADR recommends *for later*, rejected *now* for
  lack of demand. Its cost is small but not zero, and `slim`'s budget across two files is a design
  question that deserves M2's context rather than an afternoon's.
- **Say nothing and revisit from scratch at M2** — rejected. The three measurements are the
  expensive part and they do not spoil; discarding them is how the same afternoon gets spent twice.

## Consequences

### Positive
- The gap between M2's stated direction and what ships is now **recorded rather than latent**.
- M2 starts with the harness behaviour already measured and the cost already counted.
- The command-versus-act wording problem is named, and can be fixed without waiting for M2.

### Negative / Tradeoffs
- **A generated project stays Claude-Code-shaped** for anyone using another tool on the same
  repository. That is the status quo, now with a reason attached instead of an omission.
- Deferred decisions rot: the spec may move, and the precedence rule measured here is a *product
  behaviour*, not a contract. **Re-run the three-directory test before acting on this ADR** — the
  numbers in it are a snapshot, not a guarantee.

### Neutral
- No change to any skill, template, or generated file.

## Notes

- Spec: <https://agents.md>. Surfaced by a third-party guide that named the file without arguing it;
  everything load-bearing here came from reading the spec and measuring the harness.
- **One claim in the investigation was not verifiable from this machine** and is therefore not
  load-bearing: that `AGENTS.md` support depends on server-side feature flags and is absent on
  Bedrock, third-party providers and telemetry-disabled sessions. It came from documentation via a
  subagent. It would argue *against* making `AGENTS.md` the sole entry point — which the recommended
  import pattern does not do, so the recommendation holds either way. Verify it at M2 if it matters.
- Related: [ADR 0023](0023-project-scope-for-team-portability.md) (portability of the output),
  [ADR 0021](0021-context-economy-index-over-doc-search.md) (why duplicated context is a cost),
  [`docs/ROADMAP.md`](../ROADMAP.md) M2.
