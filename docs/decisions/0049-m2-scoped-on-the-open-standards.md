<!-- generated-by: groundrules v1.13.0 -->
# 0049 — M2 scoped on the open standards: conformance and wording, not per-harness adapters

**Date**: 2026-10-09
**Status**: Accepted (scopes [M2](../ROADMAP.md); builds on [ADR 0047](0047-agents-md-deferred-to-m2.md))

## Context

[M2](../ROADMAP.md) — *support harnesses beyond Claude Code* — asked its own ADR to settle three
things when tackled: **which harnesses first**, **how the Markdown skills port versus need
per-harness adapters**, and **the per-harness distribution model**, on the premise that *"there is no
universal plugin"*. It also named Windsurf as a target. Both premises have aged since they were written.

### What changed outside, checked against primary sources on 2026-10-09

- **The skill format is an open standard, and ours already is it.**
  [Agent Skills](https://agentskills.io/specification) defines `SKILL.md` with YAML frontmatter:
  `name` and `description` required; `license`, `compatibility`, `metadata` optional; and
  `allowed-tools` — *"a space-separated string of tools that are pre-approved to run.
  **Experimental.** Support for this field may vary between agent implementations."* The spec does
  **not** fix a discovery directory; `.agents/skills/` is the de-facto shared one.
- **Our fifteen skills validate unchanged.** `gh skill publish . --dry-run` (gh 2.101.0) against
  this repository: **zero errors, exit 0**, and one warning per skill — the optional `license` field
  is missing.
- **There is a universal plugin manifest now.** [Agent Plugins
  v1.0.0](https://agent-plugins.org/specification) standardises `plugin.json` plus `skills/` and MCP
  servers — and stops there on purpose: *"Commands, hooks, agents, rules, and LSP servers remain too
  client-specific for a stable portable contract."*
- **Other harnesses read the manifests we already ship.** Codex's source lists
  `.claude-plugin/marketplace.json` among the marketplace paths it reads
  (`codex-rs/core-plugins/src/marketplace.rs`); Devin and Copilot are reported to read
  `.claude-plugin/plugin.json` as well (research report, not re-verified here).
- **Command files are being absorbed by skills** (reported by the surveys, from vendor changelogs). Amp removed custom commands, Codex removed
  `~/.codex/prompts/`, Cursor's commands URL now redirects to its *migrate commands to skills* page.
  This plugin ships fifteen skills and no command files, so there is nothing to migrate.
- **Windsurf no longer exists as a product.** It is now Devin Desktop; `.windsurf/` survives only as
  a fallback behind `.devin/`. Roo Code shut down on 2026-05-15. Neither is cited anywhere in this
  repository except M2's own target list.

### What was measured here

- **The skills are ~86% harness-neutral by content** (206 of 1,411 non-empty lines name a Claude
  Code mechanism; 6% for `realize` to 25% for `migrate`). A second, narrower count — lines naming
  `Claude Code`, `CLAUDE.md`, `.claude/` or `/groundrules:` — gives 154 lines, **128 of them in six
  skills**: `bootstrap`, `adopt`, `apply-best-practices`, `verify-bootstrap`, `migrate`, `slim`. Both
  are regex counts: an order of magnitude, not a precision.
- **ADR 0047's three-directory test was re-run and holds**: `AGENTS.md` alone is read, `AGENTS.md`
  beside `CLAUDE.md` is ignored, an `@AGENTS.md` import loads both. Claude Code's documentation now
  states this default and adds a user setting, `claude-md-and-agents-md`, that reads both files.
- **Two dependencies sit in the logic, not the vocabulary.** `$ARGUMENTS` is read by **8** skills
  (`add-adr`, `adopt`, `close`, `idea`, `learn`, `migrate`, `prd`, `verify-bootstrap`) — Codex lists
  it as unsupported. `AskUserQuestion` appears in **14** skills' `allowed-tools`, and the phased,
  grouped-question flow is built around it. No other harness has a tool by that name.

## Decision

**1. The porting target is the Agent Skills standard, not a list of harnesses.** No per-harness
adapter is written. Harnesses that read `.claude/skills/` (Cursor, OpenCode, Copilot, Amp, Devin)
take the skills as they are; those that read only `.agents/skills/` (Codex, Gemini CLI, Zed) take a
copy, and copying is the installer's job, not ours.

**2. The work is conformance plus wording, in this order:**

1. **Spec conformance** — add `license: MIT` to the fifteen skills, and write `allowed-tools`
   space-separated. Claude Code's skills reference accepts *"a space- or comma-separated string, or a
   YAML list"*, so the separator change costs Claude Code nothing.
2. **Neutral wording** — skill bodies name **the act and the place** (*record the decision as an ADR
   in `docs/decisions/`*) and give the command as a shortcut, starting with the six skills that hold
   most of the coupling. This is ADR 0047's argument, which stood on its own before M2.
3. **Graceful degradation of the two logic dependencies** — each skill reading `$ARGUMENTS` treats
   it as *"what the user passed when invoking"* and falls back to asking; each phase built on
   `AskUserQuestion` says *ask the user — with `AskUserQuestion` where available* — so the flow
   survives as prose questions elsewhere. Claude Code behaviour must not change; the eval suite is
   the check.
4. **`AGENTS.md`** last, as ADR 0047 parked it — re-measured then, decided in its own ADR. The
   generated output's 77 references to `CLAUDE.md` are its cost, and nothing above depends on it.

**3. Distribution: no new channel, no new manifest.** The Claude Code marketplace stays the primary
channel. Cross-harness installation already exists without our code — `gh skill install` targets
~50 harnesses and validates against the spec — and the README points at it once a harness is
measured. A root Agent Plugins `plugin.json` is **not** added: it would be a second manifest whose
version must be kept in step with `.claude-plugin/plugin.json`, for harnesses that already read the
latter. It becomes worth its upkeep when a target harness reads only the root form.

**4. "Supported" means measured, one harness at a time.** A harness is claimed in the README only
after the eval suite has run in it. **OpenCode is first**: it is the one installed here, it reads
`.claude/skills/` and turns each skill into `/<name>`, so it measures the wording and the degradation
work without any copying in between. Codex follows when available, because it is the hardest case —
`.agents/skills/` only, no `$ARGUMENTS`.

**5. The locks do not travel unmeasured.** `disable-model-invocation` is outside the spec. It is
reported as honoured by Cursor, Copilot, Zed and Crush, and **not** by Codex (which uses its own
`agents/openai.yaml` `policy.allow_implicit_invocation`) nor Gemini CLI (which asks consent at every
activation instead). The five skills [ADR 0045](0045-the-lock-was-scoped-to-four-skills.md) keeps
locked because a wrong firing damages a project — `bootstrap`, `migrate`, `adopt`, `slim`,
`apply-best-practices` — are the safety question of M2. **Whether a harness honours the lock is
measured before that harness is claimed**, and where it does not, the gap is stated, not hidden.

## Alternatives considered

- **Per-harness adapters** (a build step emitting `.cursor/`, `.gemini/commands/*.toml`,
  `.opencode/`…), the shape M2 originally assumed. Rejected: the formats it would target are the
  ones being retired, every adapter is upkeep against someone else's release cycle, and it breaks
  *template over code* ([ADR 0002](0002-plain-text-placeholder-substitution.md)) by introducing a generator.
- **Rename `CLAUDE.md` to `AGENTS.md` first**, since it is the most visible harness signal. Rejected
  as the first move: it is the costliest change (77 references), it is independent of the skills
  porting, and ADR 0047 already said it needs its own measured decision.
- **Add the Agent Plugins root `plugin.json` now**, since it is one file. Rejected for decision 3's
  reason: one file is also one more version to forget at release, bought for no harness we target.
- **Claim the 46 clients the standard lists.** Rejected: a spec listing a client is not that client
  running our skills well. A support claim this repository cannot reproduce is the failure class
  `docs/AGENT-EVALS.md` keeps recording.

## Consequences

### Positive
- M2 shrinks from *build adapters for N harnesses* to *conform to one spec and stop naming the
  harness* — work that improves the Claude Code experience too.
- Nothing is generated per harness, so nothing drifts per harness.
- The first support claim will rest on a run, not on a compatibility table.

### Negative / Tradeoffs
- **`allowed-tools` is a pre-approval in Claude Code, and nothing elsewhere.** It fails safe — a
  harness that ignores it asks permission more often, never less — but the smoother experience does
  not travel.
- **The grouped-question flow loses its shape outside Claude Code.** Prose questions keep the
  substance; whether they keep the quality is an open measurement, not a promise.
- Neutral wording is a sweep across fifteen skills, and every sweep of that size risks a behaviour
  change in Claude Code. The eval suite must run on that PR (as it must on any PR touching
  `skills/**`).
- Facts from the research reports that were not re-verified here (Devin and Copilot manifest
  precedence, per-harness lock behaviour) stay *reported* until a measurement makes them load-bearing.

### Neutral
- The generated project files do not change under this ADR; only the skills' wording and frontmatter
  do. `AGENTS.md` is the step that touches generated output, and it has its own decision coming.

## Notes

- Research run 2026-10-09 by two delegated surveys; the load-bearing claims above were re-checked
  against primary sources or measured on this machine before being written here.
- Related: [ADR 0047](0047-agents-md-deferred-to-m2.md) (`AGENTS.md`, step 4),
  [ADR 0045](0045-the-lock-was-scoped-to-four-skills.md) (the locked skills),
  [ADR 0002](0002-plain-text-placeholder-substitution.md) (no generator),
  [ADR 0037](0037-executable-evals-over-agent-config.md) (the eval suite as the check).
