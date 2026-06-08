---
name: checkpoint
description: Run the capture ritual on demand — decided / learned / agent-drift → routed to ADR, LEARNINGS, AGENT-EVALS. The manual complement to the agent's proactive capture before a push/release.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion
---

# /groundrules:checkpoint

You will run the **checkpoint-capture ritual** for the current project, on demand. This is the user-invoked complement to the convention in the generated `CLAUDE.md` ("Capture at checkpoints"), which the agent also triggers proactively before a `git push`/tag/release or at a completed milestone. All output is in **English**.

> Purpose: before knowledge evaporates, route what happened into the repo — *decided* → an ADR, *learned / blocked* → `docs/LEARNINGS.md`, *agent mistake/drift* → `docs/AGENT-EVALS.md`. The repo is the only memory.

## Phase 1 — Gather what happened (inform the questions)

Best-effort, read-only — to ground the three questions in what actually changed:

1. `git status --short` and the latest tag: `git describe --tags --abbrev=0` (may be absent).
2. Commits since that tag (or the last ~15): `git log <tag>..HEAD --oneline` (or `git log -15 --oneline`).
3. Skim the `[Unreleased]` section of `CHANGELOG.md` and the "In progress" / "Recently done" of `PLAN.md` if present.
4. Note the next ADR number from `docs/decisions/` (highest `NNNN` + 1).

Summarize in 2-3 lines what this work session changed, so the user answers against real context — not a blank prompt.

## Phase 2 — The three questions

One grouped `AskUserQuestion` (multiSelect for "what happened"), then drill into each chosen bucket. Phrase them with the context from Phase 1:

1. **Decided** anything structural (tech, pattern, tradeoff, naming…)? → an **ADR**
2. **Learned** something that changes how to work here — including a **blocker that cost 30+ min** and its fix? → `docs/LEARNINGS.md`
3. **Caught the agent** repeating a mistake, fabricating a fact/API, or drifting from an instruction? → `docs/AGENT-EVALS.md`

If the user says "nothing for this one", skip that bucket. Capturing nothing is a valid outcome — don't manufacture entries.

## Phase 3 — Capture each chosen bucket

### Decided → ADR (`docs/decisions/`)
Mirror `/groundrules:add-adr`: copy `0000-template.md` → `NNNN-kebab-title.md` (next number), fill Context / Decision / Alternatives / Consequences / Status from the user's answer, and add the row to the `docs/decisions/README.md` index. Keep it < 1 page.

### Learned / blocked → `docs/LEARNINGS.md`
Prepend a **rule-format** entry (the current template format, not the old Context/Lesson), right after the first `---`:

```markdown
## {title — states the rule}

**Why**: {the story + what it cost — a revert, a lost CI cycle, a 30+ min block and its fix}.

**When to apply**: {the concrete trigger conditions}.
```

### Agent drift → `docs/AGENT-EVALS.md`
If the file exists, prepend a dated entry:

```markdown
## {YYYY-MM-DD} — {the pattern, stated}

**Observed**: {what the agent did}.
**Pattern**: {the generalizable failure mode}.
**Guard**: {the rule/guard added, and where — CLAUDE.md or .claude/rules/}.
**Status**: watching.
```

If `docs/AGENT-EVALS.md` is **absent** (it's an optional doc): offer to create it from `${CLAUDE_PLUGIN_ROOT}/skills/bootstrap/templates/AGENT-EVALS.md.tpl` (substitute `{{PROJECT_NAME}}`), then add the entry. If the user declines, fold the observation into `docs/LEARNINGS.md` instead.

## Phase 4 — Recap & next step

Show what was captured:
- 🧭 ADR `NNNN` created (if any)
- 📓 LEARNINGS entry added (if any)
- 🔍 AGENT-EVALS entry added (if any)
- ⏭️ nothing captured for the skipped buckets

Then: remind to add a `CHANGELOG.md` `[Unreleased]` line for any notable change, and — if a push/release is next — note that the capture is now done (this is the reliable moment for it).

**NEVER commit automatically.**

## Important rules

- **Don't manufacture entries** — an empty checkpoint is fine; only capture what genuinely happened.
- Keep entries **short**: LEARNINGS is a journal of rules, AGENT-EVALS a log of patterns — not essays. A long decision belongs in an ADR.
- **Never overwrite**: prepend/append; preserve existing entries and each file's `generated-by` signature.
- This skill writes docs only; it never commits, tags, or pushes.
