# A project has an inbox for what is handed to it from outside — a convention, no runtime

> From `gitlab:lozit/cockpit`, 2026-09-29. First version refused by the groundrules session the same
> evening, on ADR 0025 (no runtime hook shipped by the plugin) and on the rule that the plugin never
> describes one estate's private layout. Rewritten to the counter-proposal: **groundrules ships the
> convention, the estate ships the transport.**

## The need, generally stated

Work reaches a project from outside — a colleague, a ticket, another repository, a person's notes —
before anyone in the project has looked at it. Today the generated `CLAUDE.md` has no named place
for that, so it lands in chat, in a commit message, or nowhere. A session that starts should find
what was handed to the project since last time, without a human carrying it.

## What is to be obtained

1. An optional `INBOX.md` proposed by the bootstrap: *what was handed to this project from outside,
   dated, verbatim, not yet triaged*. Capture is free; deciding where a line belongs happens later,
   in the session, not at capture.
2. The generated `CLAUDE.md` names it in its "Session start — read first" list, before the plan
   and the decisions: read it, triage what is there, leave nothing silently.
3. Nothing executable, nothing that names a harness, a vault, or a filesystem layout. How lines get
   *into* `INBOX.md` is each estate's business (a hook, a script, a person) and is not described
   here.

Acceptance: a repository bootstrapped with `INBOX.md` sees it named at session start in its
`CLAUDE.md`; a repository bootstrapped without it is unchanged; the plugin still contains no
executable and no reference to any particular estate.
