# `AGENTS.md` canonical, a bootstrap without questions, and a `ticket` skill

> From `gitlab:lozit/cockpit`, 2026-11-25 — the operator's architecture point (cockpit ADR 0006). His
> words: *« il faut qu'on passe à Agent.md … un Claude.md qui va dire : Regarde dans Agent.md »*, and
> on the bootstrap: *« il faut qu'il puisse tout créer sans poser la question »*. Three things to
> obtain, in this order of value for him.

## 1. `AGENTS.md` carries the project context; `CLAUDE.md` is one line

ADR 0047 measured the only shape Claude Code loads alongside another harness: **`CLAUDE.md`
containing `@AGENTS.md`**. ADR 0049 parked `AGENTS.md` last in M2 because nothing depended on it.
Something does now: the operator's company works on **several harnesses at once** — Claude Code for
him, Codex and ChatGPT for the second person, OpenCode under study — and the project context must be
read by all of them without a copy per harness. So:

- `bootstrap` generates **`AGENTS.md`** (today's `CLAUDE.md` content, harness-neutral wording per
  ADR 0049 step 2) and a **`CLAUDE.md` of one line, `@AGENTS.md`**, plus whatever is truly
  Claude-Code-only (the `.claude/` tree section) if ADR 0049's neutral wording leaves any.
- `adopt`, `migrate`, `slim`, `verify-bootstrap` learn the second filename; `slim`'s 200-line budget
  applies to `AGENTS.md`; `verify-bootstrap` checks that `CLAUDE.md` imports it.
- `migrate` offers the move for existing projects: rename, write the one-line `CLAUDE.md`, keep
  the generator signature.

Re-run ADR 0047's three-directory test before shipping (the behaviour is Claude Code's, not ours),
and record the decision in the ADR 0047 named as its own.

## 2. A bootstrap that asks nothing when it is given a context file

Today `bootstrap` asks its questions through `AskUserQuestion` (eleven call sites). An agent running
in Multica, told *"create the repository for project X"*, must not stop at a question nobody will
answer. To obtain:

- **An input file replaces the interview.** When the invocation names a context file — the vault's
  `_context.md` of the project (see the `vault-template` brief of the same date), or any Markdown
  with the same fields: project name, one-line purpose, stack, repository slug, Multica project key
  and agent name, policies (no AI attribution, language) — `bootstrap` takes every answer from it
  and **asks nothing**. Missing optional fields take the documented defaults (no optional docs, no
  loop scaffolding). A missing required field is an error that names the field, not a question.
- The same for `adopt` on an existing repository.
- **The bootstrap also creates the Multica project link**: it writes the project key and agent
  name into `AGENTS.md` (a `## Where the work is` section: repository, Multica project, vault
  folder) so an agent opening the repository knows where its issues are. Creating the Multica
  project itself is the vault side's job (it exists before the repository); the bootstrap records it.

Claude Code's interactive behaviour must not change; the eval suite is the check.

## 3. A `ticket` skill — an issue an agent can complete

The operator wants Multica issues *« le plus complètes possible pour que le travail puisse être
réalisé »*. One skill, `ticket`, that turns a conversation into an issue body with a fixed shape:
**context** (what exists, measured), **to obtain** (observable outcome), **acceptance** (how the
agent and the reviewer check it), **out of scope**, **delivery** (branch, commit, **push**, open a
merge request, report in the issue — the word *push* explicit: a 2026-11-24 issue said *commit* and
the work sat unpushed for an hour). The skill writes the body; it does not call Multica (that is
the MCP's job, cockpit `docs/specs/mcp-multica.md`), so it stays a Markdown skill like the others.

## Acceptance

- A fresh directory + a `_context.md` → `bootstrap` runs to completion with zero prompts, produces
  `AGENTS.md`, a one-line `CLAUDE.md`, the standard docs; `verify-bootstrap` passes.
- A fresh `claude -p` in that directory loads the context (ADR 0047's test).
- `ticket` produces a body with the five sections; the eval suite covers it.
- Nothing changes for an interactive bootstrap without a context file.
