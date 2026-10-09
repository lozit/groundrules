<!-- generated-by: groundrules v1.13.0 -->
# 0048 — An optional `INBOX.md`: the plugin ships the convention, the caller ships the transport

**Date**: 2026-09-29
**Status**: Accepted

## Context

Work reaches a project from outside — a colleague, a ticket, another repository, a note somebody
made away from the desk — before anyone in the project has looked at it. The generated `CLAUDE.md`
had no named place for that, so it landed in a chat message, in a commit body, or nowhere.

The request that surfaced it (`intake/2026-09-29-a-session-reads-its-project-inbox.md`) asked for
something else: a **`SessionStart` hook shipped by the bootstrap**, resolving a project slug,
reaching a private document store through `VAULT_ROOT`, reading `01-projects/<slug>/inbox.md` and
printing its unpicked lines. **It was refused**, on two grounds this repository had already paid
for, and rewritten to what this ADR records.

**It would have been the first thing the plugin generates that runs without being invoked.** A
correction to the first version of this ADR, which claimed it would be *the first executable the
plugin ever generated* — that was false, and the check behind it scanned one directory level while
the claim was about the whole plugin. The plugin does generate an executable: `loop/run-loop.sh`,
`chmod +x`, when the loop scaffolding is opted into.

The true distinction is sharper, and it makes the refusal stronger rather than weaker. `run-loop.sh`
is a **runner the user invokes deliberately**, opt-in, with a hard iteration ceiling; nothing
happens until someone types it. A `SessionStart` hook runs **unasked, in the agent's startup path,
on every session of every bootstrapped project**. [ADR 0025](0025-no-runtime-hook-no-watch.md)
refused that class in its own words — *"a runtime hook is machinery against groundrules' nature (ADR 0002
'template over code'; offline-first; 'pure Markdown + JSON, no runtime')"* — and added that a hook
coupled to one harness's format does not port, which
[ADR 0047](0047-agents-md-deferred-to-m2.md) reaffirmed six days earlier for generated output. The
same line had been applied against this repository's own convenience a week before, when an index
check was sent to CI rather than to a `PostToolUse` hook; a line that holds only when it costs
someone else is not a line.

**And it would have put one estate's private layout into a public plugin.** `VAULT_ROOT` makes the
*root* configurable; `01-projects/<slug>/inbox.md` is still a shape that exists in exactly one
person's store. A bootstrapped project elsewhere would have received a hook reading a directory
convention the plugin documents nowhere. That is the September lesson — an ADR rebuilt from scratch
and a brief neutralised to remove exactly this — returning in a new form.

## Decision

**1. An optional `INBOX.md` at the repository root**, offered by `bootstrap` (Call 2b) and `adopt`,
unchecked by default: *what was handed to this project from outside, dated, verbatim, not yet
triaged.* Capture is free; deciding where a line belongs happens later. Triage **marks** a line
(`→ ADR 0012`, `→ PLAN.md`, `→ dropped`) rather than deleting it: the file is a record of what
arrived, not a queue that empties.

**2. It is named first in the generated `CLAUDE.md`'s session-start list**, before `PLAN.md` —
what arrived can change what the rest of the list means. It needs no conditional: the list already
marks optional entries *(if present)*, so one line serves both cases and nothing has to be dropped
at generation time.

**3. The plugin never fills it.** How lines arrive — typed, pasted, or written by a script of the
user's own — is the caller's business and is described nowhere in the plugin. **This is the whole
decision**: the convention is general and belongs here; the transport is particular and belongs to
whoever has a particular source. The estate that asked for this keeps its hook, in its own
dotfiles, bound to its own layout.

**4. Nothing that runs unasked, and nothing naming a harness or a store.** The one executable the
plugin generates — `loop/run-loop.sh`, opt-in and user-invoked — is unchanged and is not the
category being refused here.

## Alternatives considered

- **Ship the `SessionStart` hook as asked** — refused, per the two grounds above. Reopening ADR
  0025 for a convenience, and re-importing a private layout eight days after removing it, would
  each have been a bad trade on its own.
- **Ship the hook but make the inner path configurable too** — rejected: a second environment
  variable would have hidden the coupling rather than removed it, and the plugin would still be
  shipping an executable it cannot test on any machine but one.
- **Reuse `intake/` instead of a new file** — tempting, and wrong. `intake/` is *upstream material
  gathered before the work starts* — briefs, specs, transcripts — and its README says so. An inbox
  is a **live surface** that fills during the project's life and is triaged line by line. Folding
  them would blur a folder that is currently unambiguous, for one fewer file.
- **Make it non-optional** — rejected: a project where every input passes through the person
  running the session gains an empty file and a line of ritual. ADR 0006's opt-in shape applies.

## Consequences

### Positive
- Work handed to a project has a named place, and a session is told to read it **first**.
- The refusal is recorded with its reasoning, so the next request of this shape is a lookup rather
  than a re-derivation.
- The split — convention here, transport there — is stated as a principle, which is the part that
  generalises beyond inboxes.

### Negative / Tradeoffs
- **A named place is not a filled one.** Nothing guarantees a line reaches `INBOX.md`; the plugin
  deliberately does not provide the mechanism that would. For a caller with no transport, this is a
  file that stays empty — which is why it is optional and unchecked by default.
- **The session-start list is a reminder, not a check** — the distinction this repository keeps
  relearning. It relies on the agent reading a loaded file. That is what a Markdown-only plugin can
  offer; anything stronger is runtime, and runtime is what ADR 0025 declined.
- One more optional doc in Call 2b, which keeps growing.

### Neutral
- Projects that decline it are unchanged, and the generated `CLAUDE.md` gains one line either way.

## Notes

- Source: `intake/2026-09-29-a-session-reads-its-project-inbox.md`, second version. Its header
  records the refusal of the first, which is why the file is worth reading before this ADR.
- Related: [ADR 0025](0025-no-runtime-hook-no-watch.md) (no runtime shipped),
  [ADR 0006](0006-optional-specialized-docs.md) (the opt-in shape),
  [ADR 0047](0047-agents-md-deferred-to-m2.md) (output stays harness-neutral),
  [ADR 0022](0022-agent-evals-and-session-close.md) (`AGENT-EVALS.md`, the closest precedent for
  adding an optional doc).
