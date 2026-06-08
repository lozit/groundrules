<!-- generated-by: groundrules v1.3.2 -->
# Agent evals — groundrules

> A log of the **agent's own** observed failure modes while developing this plugin —
> recurring mistakes, hallucinations, drifts — and the guard added for each.
> Reverse-chronological. This is **meta**: about how the agent behaves *here*, not about the
> plugin's domain. Project/domain lessons go in `docs/LEARNINGS.md`.

Fed by the checkpoint-capture ritual (cf. `CLAUDE.md` → "Capture at checkpoints", typically
before a push/release).

---

## 2026-06-08 — "Just restart" advised without verifying the installed plugin version (recurrence)

**Observed**: when the user reported `/groundrules:checkpoint` then `/groundrules:slim` not appearing, the agent repeatedly advised "restart Claude Code" — without checking which plugin version was actually *installed*. On disk the installed plugin was still **1.1.0** (cache capped there); the user had only run `/plugin marketplace update` (catalog), never updated the plugin. A restart just reloaded 1.1.0. Only after inspecting `~/.claude/plugins/cache/…` did the real cause surface.

**Pattern**: **recurrence** of "asserts/trusts without verifying" (see entry below) — diagnosing a symptom from a mental model ("new skill ⇒ restart") instead of checking ground truth first.

**Guard**: when a command/skill "doesn't appear", **verify the installed version on disk before advising** (`ls ~/.claude/plugins/cache/<marketplace>/<plugin>/`) — distinguish *marketplace catalog* (updated) from *installed plugin* (often not). The README "Updating the plugin" section and the skills' Phase 0 notices now spell out the two-step update explicitly.

**Status**: watching — the prior guard ("verify before assert") didn't fire here; this strengthens it toward *environment/installation* claims specifically.

## 2026-06-08 — Asserts / trusts without verifying first

**Observed** (two instances, one session):
1. Labelled the new session-close ritual a *"forcing function"* without checking whether any
   trigger could fire it — it couldn't (the agent can't perceive session end). The user
   caught the over-claim.
2. Echoed graphify's star count from a WebFetch AI summary that had **hallucinated** inflated
   figures; only a direct GitHub API call gave the real numbers. (Caught before asserting to
   the user, but the first draft trusted the summary.)

**Pattern**: stating something *works* / *is true* on the strength of a plausible-sounding
source (own reasoning, an AI summary) before verifying against ground truth.

**Guard**: before asserting a mechanism works or quoting an external metric — verify it.
For Claude Code behavior, check the docs (the `claude-code-guide` agent); for external repo
metrics, hit the API, not a WebFetch summary; for a "this will trigger/fire" claim, name the
concrete event that fires it. "Verify before you assert" is now also reflected in the
`CLAUDE.md` "Verifying the work" discipline.

**Status**: watching — re-evaluate over the next few sessions.
