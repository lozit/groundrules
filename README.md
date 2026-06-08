# groundrules

**groundrules lays the documentation backbone of a software project — and keeps it alive.** A Claude Code plugin that interviews you, captures the project's intent, and generates a tailored, opinionated doc structure (vision, decisions, learnings, architecture…), then gives you the skills to maintain it as the project evolves.

> Interview → tailored project structure → `git init` → first commit → optional remote.

## Why

Coding agents rarely fail for lack of information — they fail for lack of the *right* information, structured and at hand. Two forces make that hard, and groundrules is built to answer both:

- **More context isn't better — it's measured.** Research on [*context rot*](https://www.understandingai.org/p/context-rot-the-emerging-challenge) (Chroma, 2025) found every frontier model tested — Claude included — degrades as the input grows; the classic *lost in the middle* effect drops accuracy **30%+** for anything buried mid-window. [Anthropic's own guidance](https://code.claude.com/docs/en/memory) agrees: keep `CLAUDE.md` **under 200 lines**, because "larger files produce lower adherence." Stuffing everything into context actively hurts.
- **Knowledge evaporates.** Decisions, conventions, and hard-won lessons end up in chat logs and an agent's volatile memory — gone by the next session, invisible to the next contributor.

groundrules' answer is a *method*, not just a folder of templates: **write everything down on disk, load almost none of it.** It generates a small always-loaded index (`CLAUDE.md`) that points to exhaustive docs read **on demand**, an ADR trail for the *why*, a rule-format learnings journal, and the discipline that **the repo is the only memory**. Exhaustive storage, minimal loading — the agent gets precisely what each task needs and nothing it doesn't.

**What it buys you:**

- **Sharper agents** — a small, current index plus on-demand reads keeps attention undiluted and adherence high, instead of a bloated always-on file.
- **Knowledge that survives** — decisions, conventions and lessons live in the repo, available to the next session, the next contributor, and any agent — not trapped in one chat.
- **Lower token cost** — exhaustive on disk, minimal in context: you don't pay to carry the whole project every turn.
- **No lock-in** — it's plain markdown; the structure stays readable and useful even without the plugin.
- **Docs that don't rot** — living-docs discipline, checkpoint capture, and `/groundrules:slim` keep the backbone current and under budget over time.

The full reasoning and token economics: [`docs/CONTEXT-ECONOMY.md`](docs/CONTEXT-ECONOMY.md) ([ADR 0021](docs/decisions/0021-context-economy-index-over-doc-search.md)).

## How it works

It starts the moment you run `/groundrules:bootstrap` in a fresh folder.

groundrules **interviews you** — a handful of grouped questions about the project's name, type, stack, and intent. It captures that intent (you paste a brief, point to a file, or answer an interview), synthesizes it into a `docs/VISION.md`, and generates a documentation backbone *tailored to your answers*: a `CLAUDE.md` that fits the project, an ADR folder for decisions, a learnings journal, a plan, and only the specialized docs you actually need (data model, security, design system, release runbook…). Then it `git init`s, makes the first commit, and — if you asked — creates the remote.

From there, **the project is alive**. As you work, `learn` and `add-adr` capture knowledge where it belongs; `apply-best-practices` pulls fresh practices from the community and tailors them to your vision; `verify-bootstrap` checks coherence; and when the plugin itself improves, `migrate` brings your project up to date without ever overwriting your work. Already have a project? `adopt` brings it under management — and can consolidate an existing layout onto the canonical one.

The throughline: **knowledge lives in the repo, structured and current** — not in scattered notes or an agent's volatile memory.

## Installation

In Claude Code:

```bash
/plugin marketplace add https://github.com/lozit/groundrules
/plugin install groundrules
```

From a local clone, or for fast iteration without installing:

```bash
/plugin marketplace add /path/to/groundrules
/plugin install groundrules@claude-code-groundrules
# or, dev mode:
claude --plugin-dir /path/to/groundrules
```

> **Working in a team / shared repo?** Install at **Project scope** (choose *Project*, not *User*, during `/plugin install`). This commits the plugin reference to `.claude/settings.json`, so anyone who clones and trusts the repo is prompted to install it — the `/groundrules:*` commands then work for everyone. The plugin does **not** travel with a `git clone` otherwise; a user-scope install is per-machine. (The generated docs are plain markdown and remain readable without the plugin — only the slash-command ergonomics need it. See [ADR 0023](docs/decisions/0023-project-scope-for-team-portability.md).)

> groundrules is a Claude Code plugin today. Support for other harnesses is on the [roadmap](#roadmap) — the repo is named `groundrules` (harness-neutral) for that reason.

## The workflow

Seven skills ordered by a project's lifecycle, plus two cross-cutting maintenance skills:

1. **`bootstrap`** — *new, empty folder.* Interview + intent capture (paste / file / interview) + from-scratch generation of the whole structure, `git init`, optional remote.
2. **`adopt`** — *existing (brownfield) project.* Scans, maps existing files to roles, generates only what's missing, backfills `.groundrules.json`. Never overwrites; supports `--dry-run` and a **consolidate** mode that migrates an existing layout onto the canonical paths.
3. **`learn`** — *after a correction or a discovery.* Adds an actionable rule to `docs/LEARNINGS.md` (*Why* + *When to apply*).
4. **`add-adr`** — *a structural decision is made.* Creates a numbered ADR and updates the index.
5. **`apply-best-practices`** — *want outside input.* Fetches the up-to-date `shanraisshan/claude-code-best-practice` and proposes recommendations tailored to your `docs/VISION.md`. (The only skill that needs the network.)
6. **`verify-bootstrap`** — *sanity check.* Validates signatures, leftover `{{KEY}}` placeholders, CLAUDE.md size, valid JSON, git. `--fix` for trivial corrections.
7. **`migrate`** — *the plugin has a new version.* Per-file diff, never overwrites without confirmation, chains historical renames, `--dry-run`.
8. **`checkpoint`** — *any time, especially before a push.* Runs the capture ritual (see below).
9. **`slim`** — *when `CLAUDE.md` approaches 200 lines.* Proposes concrete optimizations to stay under budget — extract a bulky section to `docs/`, move file-type rules to `.claude/rules/` (loaded on demand), compress, de-duplicate. Moves content, never deletes it. (`verify-bootstrap` points here when it flags the size.)

## Capturing knowledge as you go

Knowledge is worthless if it evaporates. groundrules captures it at the moments that matter, routed to where it belongs:

- **Decided** something structural → an **ADR** (`docs/decisions/`)
- **Learned** something, or **blocked 30+ min** → a rule in `docs/LEARNINGS.md` (*Why* + *When to apply*)
- **Caught the agent** repeating a mistake, hallucinating, or drifting → `docs/AGENT-EVALS.md` (optional doc) + a guard in `CLAUDE.md`

This **checkpoint-capture ritual** fires two ways. The agent **proposes it proactively** at the boundaries it can perceive — **before a `git push`, tag, or release** (the most reliable moment, also wired into the `RELEASE.md` pre-release checklist) or at a completed `PLAN.md` milestone. And **you can trigger it yourself any time** with **`/groundrules:checkpoint`**. (There's no "end of session" trigger: an agent can't perceive a session ending — so capture is anchored to events it *can* see. See [ADR 0022](docs/decisions/0022-agent-evals-and-session-close.md).)

## What's generated

groundrules gives a project a clear geography.

| Folder | Role |
|---|---|
| **`intake/`** | **Raw upstream inputs**, captured as received: client specs, emails, scoping notes, spreadsheets, brand assets. **Read-only** (don't "fix" inputs — synthesize them into `docs/`), binaries welcome. The draft side. |
| **`docs/`** | The **living, synthesized documentation**: vision, architecture, learnings, specialized docs. Where stable knowledge lives and is kept in sync. |
| **`docs/decisions/`** | The **ADRs**: one file per structural decision — context, decision, alternatives, tradeoffs. The *why*, frozen at decision time. |
| **`docs/media/`** | **Visual assets** supporting the docs: mockups, screenshots, diagrams (with their editable sources). |

The flow: `intake/` (raw, untouched) → `docs/` (synthesized, living) → `docs/decisions/` (the why, frozen). Root files (`README.md`, `CLAUDE.md`, `PLAN.md`, `CHANGELOG.md`, `RELEASE.md`) are the operational surface.

| File | When created | Content |
|---|---|---|
| `README.md` | Always | Public project presentation: title, description, install, usage, structure, doc links. Skeleton to flesh out per the stack. |
| `CLAUDE.md` | Always | Instructions for Claude Code. Mutable and iterative (target < 200 lines): session-start reading order, Setup/Build/Test commands, conventions, "repo is the only memory". |
| `.gitignore` | Always | Minimal, stack-agnostic list: OS (`.DS_Store`…), editors (`.vscode/`, `.idea/`…), logs, `.env`, and common build folders to adapt. |
| `docs/decisions/README.md` | Always | Explains the ADR format (after Michael Nygard): naming convention `NNNN-kebab-title.md` and when to create an ADR. |
| `docs/decisions/0000-template.md` | Always | ADR template to copy: Context, Decision, Alternatives considered, Consequences, Status. |
| `docs/LEARNINGS.md` | Always | Rules learned from corrections: one entry = an actionable rule with *Why* (the story + cost) and *When to apply* (triggers). Fed by `/groundrules:learn`, re-read at session start. |
| `intake/README.md` | Always | Explains the role of `intake/` and its conventions (read-only, binaries welcome, explicit names). |
| `docs/media/README.md` | Always | Explains the role of `docs/media/` with naming and format conventions. |
| `.groundrules.json` | Always | Plugin manifest (not meant for manual editing): version, chosen options, intent, generated/adopted/migrated files. Used by resume mode and `migrate`/`verify-bootstrap`. |
| `PLAN.md` | On by default | **Active** todo maintained by Claude during work: In progress / Up next / Waiting / Recently done, with the `[~]` in-review status vocabulary. Distinct from the long-term roadmap. |
| `docs/VISION.md` | Intent not skipped | **Structured synthesis** of the intent: Goal, Users/personas, Constraints, V1 non-goals, Acceptance criteria. Required by `/groundrules:apply-best-practices`. |
| `intake/INTENT.md` | Intent captured (paste/file) | **Raw source** of the project intent (paste, email, call transcript, PO doc…) before synthesis. |
| `docs/ARCHITECTURE.md` | Code project | **Living** snapshot of the architecture: overview, stack, components and responsibilities. The *why* goes in `docs/decisions/`. |
| `docs/GLOSSARY.md` | Domain jargon | Domain vocabulary, one entry per term, alphabetical — so a new dev (or Claude) understands the domain language. |
| `CHANGELOG.md` | Versioned releases | Change tracking in [Keep a Changelog](https://keepachangelog.com/) + SemVer format. |
| `docs/DATA_MODEL.md` | The project has a database | Entities/tables and their fields, relationships, row-level access rules (RLS), indexes, migrations. |
| `docs/SECURITY.md` | Sensitive / personal data | Authentication, authorization, personal data & GDPR compliance, secrets, attack surface, incident procedure. |
| `docs/DESIGN_SYSTEM.md` | Project with a UI | Principles, colors (tokens), typography, spacing/grid, components, accessibility, where tokens live in the code. |
| `docs/ROADMAP.md` | Long-term trajectory | Milestone breakdown (goal, scope, exit criteria, status). Distinct from `PLAN.md` (active todo). |
| `docs/I18N.md` | Multilingual project | Supported languages and fallback, translation organization, localized formats, translation process. |
| `docs/PROCESS.md` | Phased way of working | The working-method contract: phases, validation gates, interview style, where artifacts live. Claude follows it and never skips a phase. |
| `RELEASE.md` | Project deploys somewhere | Operational release runbook: TL;DR commands, environments table, pre-release checklist, secrets, rollback, known fragilities. |
| `docs/AGENT-EVALS.md` | Long agent-driven project | A log of the **agent's own** failure modes here (recurring mistakes, hallucinations, drifts) + the guard added for each. Distinct from `LEARNINGS.md` (project/domain). Fed by the checkpoint-capture ritual (before a push/release). |

Every generated file carries a `<!-- generated-by: groundrules -->` signature, which enables **resume mode**: re-run a skill on a non-empty folder with no overwrite risk.

## Philosophy

- **Template over code** — plain `{{KEY}}` text substitution, never a template engine or application logic ([ADR 0002](docs/decisions/0002-plain-text-placeholder-substitution.md)).
- **The repo is the only memory** — project knowledge lives in the repo docs, never in an agent's machine-local memory or scattered notes ([ADR 0020](docs/decisions/0020-repo-is-the-only-memory.md)).
- **Living docs** — every generated doc is kept in sync *in the same change* that makes it stale; maintenance is part of the task, not a follow-up.
- **Never overwrite without confirmation** — resume mode detects what exists and offers skip / overwrite / save-as-`.new`; your edits are safe.
- **Offline-first** — only `apply-best-practices` needs the network; the rest works offline (the update check fails silent).
- **A handoff, not gospel** — a generated `CLAUDE.md` is a starting point you edit and enrich, not absolute truth.

The full reasoning behind every structural choice lives in [`docs/decisions/`](docs/decisions/).

## Updating the plugin

Updating is **two steps** — and skipping the second is the most common trap.

```
# 1. Refresh the marketplace catalog — this does NOT update your installed plugin
/plugin marketplace update claude-code-groundrules

# 2. Update the installed plugin itself — the step people miss
/plugin install groundrules@claude-code-groundrules     # re-installing pulls the new version
# (or: /plugin → select groundrules → Update)
```

Then **restart Claude Code**. A *new* skill ships in its own directory and only registers on a **full restart** — `/reload-plugins` alone surfaces edits to existing skills, not a brand-new command.

> **Why two steps?** `/plugin marketplace update` only refreshes the *catalog*; your *installed* plugin stays on its old version until you explicitly reinstall/update it. If a new command (e.g. `/groundrules:slim`) doesn't appear even after a restart, you almost certainly did step 1 but not step 2. Check the version you actually have: `ls ~/.claude/plugins/cache/claude-code-groundrules/groundrules/`.

To avoid the trap entirely, turn on auto-update: `/plugin` → **Marketplaces** tab → select `claude-code-groundrules` → **Enable auto-update**.

`bootstrap`, `adopt` and `migrate` also run a **best-effort update check** when invoked (single `git ls-remote`, ~3s timeout, silent when offline) and print a notice if a newer version is published. To update an already-bootstrapped **project** after updating the plugin, run `/groundrules:migrate` in that project.

## Requirements for the remote

- `gh` CLI for GitHub: https://cli.github.com/
- `glab` CLI for GitLab: https://gitlab.com/gitlab-org/cli

If absent, the plugin shows the ready-to-paste commands for manual execution.

## Plugin structure

```
groundrules/
├── .claude-plugin/plugin.json       # manifest
├── .claude-plugin/marketplace.json  # mono-plugin marketplace
└── skills/<name>/SKILL.md           # one slash command per skill
    bootstrap also has templates/    # Markdown templates
```

## Contributing

Issues and pull requests are welcome. A few conventions:

- **Structural changes go through an ADR** — propose one with `/groundrules:add-adr` (or describe the decision in the PR so it can become one).
- **The plugin dogfoods itself** — this repo uses its own generated structure (`docs/`, `intake/`, ADRs, `PLAN.md`), so changes should keep the dogfood coherent.
- **Templates are plain text** — `{{KEY}}` substitution only, no engine.

## Roadmap

- [x] V0.1 — from-scratch bootstrap + resume mode
- [x] V0.2 — `CLAUDE.md` template restructured with best practices (Boris Cherny, shanraisshan)
- [x] V0.3 — skills `/groundrules:add-adr` (auto-incremented ADR) and `/groundrules:learn` (dated LEARNINGS entry)
- [x] V0.4 — skill `/groundrules:migrate` (per-file diff, `.new` fallback, `--dry-run`)
- [x] V0.5 — intent capture in `bootstrap` + skill `/groundrules:apply-best-practices` (fetch shanraisshan, tailored to the vision)
- [x] V0.6 — skill `/groundrules:verify-bootstrap` (report + `--fix`)
- [x] V0.7 — optional specialized docs in `bootstrap` (`DATA_MODEL`, `SECURITY`, `DESIGN_SYSTEM`, `ROADMAP`, `I18N`); VISION/INTENT de-numbering; superpowers interop; broadened planning detection; skill `/groundrules:adopt` (brownfield); global/enterprise CLAUDE.md awareness
- [x] V0.8 — English-only: dropped the bilingual FR/EN templates and the `{{LANG}}` logic (less maintenance, all projects in English)
- [x] V0.9 — `media/` moved under `docs/media/` (avoid collision with project `media/`/`public/`)
- [x] V0.10 — `adopt` always offers the optional docs; generated `CLAUDE.md` gets a "living docs" maintenance rule
- [x] V0.11 — `brief/` renamed to `intake/` (clearer name for raw upstream material); `migrate` learns the rename
- [x] V0.12 — best-effort update check in `bootstrap`/`adopt`/`migrate`; plugin rename decided for V1.0.0 (ADR 0017)
- [x] V1.0 — plugin renamed to **`groundrules`** (ADR 0017): command prefix `/groundrules:`, state file `.groundrules.json`, `migrate` handles the full legacy transition
- [x] V1.1 — `adopt` consolidate mode (migrate a brownfield layout onto the canonical paths); `PROCESS.md` + `RELEASE.md` optional docs; LEARNINGS rule format + Session Start protocol (harvested from a real project); "repo is the only memory" convention
- [x] V1.2 — context economy guide (ADR 0021); agent-evals + checkpoint-capture ritual + `/groundrules:checkpoint` (ADR 0022); graphify interop; MIT license; README pitch-before-install + "Why"
- [x] V1.3 — `/groundrules:slim` (CLAUDE.md 200-line optimizer, ADR 0024); team-portability project-scope guidance in `bootstrap`/`adopt` (ADR 0023)
- [ ] Post-1.0 — extend groundrules beyond Claude Code to other harnesses (repo name is harness-neutral by design)
- [x] Public marketplace published on GitHub: [lozit/groundrules](https://github.com/lozit/groundrules)

## License

[MIT](LICENSE) © 2026 Guillaume Ferrari.
