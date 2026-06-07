# groundrules

> **Formerly `starter-kit`** (renamed at V1.0.0 — see ADR 0017). Existing projects: run `/groundrules:migrate`.

A Claude Code plugin that **bootstraps** a new project via an interactive slash command, applying best practices of documentation and configuration.

> Interview → tailored project structure → `git init` → first commit → optional remote.

All generated files are in **English**.

## Slash commands provided

- `/groundrules:bootstrap` — interview + intent capture (brief paste / file / interview) + from-scratch generation of a new project
- `/groundrules:adopt` — bring an **existing project** (brownfield) under groundrules management: scans, maps existing files to roles (plan→PLAN, business doc→intake, todos→backlog, superpowers→interop), generates only what's missing, backfills `.groundrules.json`. Never overwrites, supports `--dry-run`
- `/groundrules:apply-best-practices` — fetches the up-to-date `shanraisshan/claude-code-best-practice` and proposes recommendations tailored to the project's `docs/VISION.md`
- `/groundrules:add-adr` — create a new ADR with an auto number, index updated
- `/groundrules:learn` — add a dated entry to `docs/LEARNINGS.md`
- `/groundrules:migrate` — update an existing project to the current plugin version (per-file diff, never overwrites without confirmation, supports `--dry-run`)
- `/groundrules:verify-bootstrap` — validate the coherence of a groundrules project (version signatures, leftover `{{KEY}}` placeholders, CLAUDE.md size, valid JSON, git). Supports `--fix` for trivial corrections (signature bumps).

## What `/groundrules:bootstrap` does

`/groundrules:bootstrap` runs a short interview (4-8 grouped questions) then generates:

- `README.md`, `CLAUDE.md`, `.gitignore` — always
- `docs/decisions/` (Michael Nygard ADR), `docs/LEARNINGS.md` — always
- `intake/`, `docs/media/` — always, with explanatory READMEs
- `PLAN.md`, `docs/ARCHITECTURE.md`, `docs/GLOSSARY.md`, `CHANGELOG.md` — depending on your answers
- optional specialized docs — `docs/DATA_MODEL.md`, `docs/SECURITY.md`, `docs/DESIGN_SYSTEM.md`, `docs/ROADMAP.md`, `docs/I18N.md`
- `git init` + first commit
- Remote repo creation via `gh` (GitHub) or `glab` (GitLab) if you pick a provider

Every generated file carries a `<!-- generated-by: groundrules -->` signature to enable **resume mode**: you can re-run the command on a non-empty folder without overwrite risk.

## Generated files (detail)

### Always created

| File | Content |
|---|---|
| `README.md` | Public project presentation: title, description, install, usage, structure, doc links. Skeleton to flesh out per the stack. |
| `CLAUDE.md` | Instructions for Claude Code. Mutable and iterative (target < 200 lines): description, Setup/Build/Test commands, key files and folders, project conventions. |
| `.gitignore` | Minimal, stack-agnostic list: OS (`.DS_Store`…), editors (`.vscode/`, `.idea/`…), logs, `.env`, and common build folders to adapt. |
| `docs/decisions/README.md` | Explains the ADR format (Architecture Decision Records, after Michael Nygard): naming convention `NNNN-kebab-title.md` and when to create an ADR. |
| `docs/decisions/0000-template.md` | ADR template to copy: Context, Decision, Alternatives considered, Consequences (positive / tradeoffs), Status. |
| `docs/LEARNINGS.md` | Journal of non-trivial learnings, reverse-chronological. One entry = dated title + Context + Lesson. Fed by `/groundrules:learn`. |
| `intake/README.md` | Explains the role of the `intake/` folder: upstream notes and raw specs (client specs, brainstorms, emails, scoping notes) before migrating to `docs/`. |
| `docs/media/README.md` | Explains the role of the `docs/media/` folder: visual and binary assets (images, mockups, screenshots, diagrams), with naming and format conventions. |
| `.groundrules.json` | Bootstrap manifest (not meant for manual editing): plugin version, chosen options, intent source, generated/ignored files. Used by resume mode and the `migrate`/`verify-bootstrap` skills. |

### Created based on your answers

| File | Condition | Content |
|---|---|---|
| `PLAN.md` | On by default | **Active** todo maintained by Claude during work: In progress / Up next / Waiting / Recently done. Distinct from the long-term roadmap. |
| `docs/ARCHITECTURE.md` | Code project | **Living** snapshot of the architecture: overview, stack, components and responsibilities. The *why* goes in `docs/decisions/`. |
| `docs/GLOSSARY.md` | Domain jargon | Domain vocabulary, one entry per term, alphabetical. Short definitions so a new dev (or Claude) understands the domain language. |
| `CHANGELOG.md` | Versioned releases | Change tracking in [Keep a Changelog](https://keepachangelog.com/) + SemVer format: Added / Changed / Deprecated / Removed / Fixed / Security. |
| `intake/INTENT.md` | Intent captured (paste/file) | **Raw source** of the project intent (paste, email, call transcript, PO doc…) before synthesis. |
| `docs/VISION.md` | Intent not skipped | **Structured synthesis** of the intent: Goal, Users/personas, Constraints, V1 non-goals, Acceptance criteria. Required by `/groundrules:apply-best-practices`. |

### Specialized docs (optional, checked during the interview)

| File | When to check it | Content |
|---|---|---|
| `docs/DATA_MODEL.md` | The project has a database | Entities/tables and their fields, relationships, row-level access rules (RLS), indexes, migrations. |
| `docs/SECURITY.md` | Sensitive / personal data | Authentication, authorization, personal data & GDPR compliance, secrets, attack surface, incident procedure. |
| `docs/DESIGN_SYSTEM.md` | Project with a UI | Principles, colors (tokens), typography, spacing/grid, components, accessibility, where tokens live in the code. |
| `docs/ROADMAP.md` | Long-term trajectory | Milestone breakdown (goal, scope, exit criteria, status). Distinct from `PLAN.md` (active todo). |
| `docs/I18N.md` | Multilingual project | Supported languages and fallback, translation organization, localized formats, language detection, translation process. |
| `docs/PROCESS.md` | Phased way of working | The working-method contract: phases, validation gates, interview style, where artifacts live. Claude follows it and never skips a phase. |
| `RELEASE.md` | Project deploys somewhere | Operational release runbook: TL;DR commands, environments table, pre-release checklist, secrets, rollback, known fragilities. |

## Installation

### From this repo (local)

```bash
# In Claude Code:
/plugin marketplace add /path/to/groundrules
/plugin install groundrules@claude-code-groundrules
```

### From GitHub

```bash
/plugin marketplace add https://github.com/lozit/groundrules
/plugin install groundrules
```

### Dev mode (fast iteration without install)

```bash
claude --plugin-dir /path/to/groundrules
```

## Updating the plugin

Marketplaces added from GitHub or a local path do **not** auto-update by default. To update manually:

```
/plugin marketplace update claude-code-groundrules
```

then install the new version via `/plugin` (Discover tab) and run `/reload-plugins` (or restart Claude Code). To make it automatic: `/plugin` → **Marketplaces** tab → select the marketplace → **Enable auto-update**.

> **Note**: the marketplace was named `starter-kit-local` before v0.12 and `claude-code-starter-kit` before v1.0 (when the plugin itself was renamed from `starter-kit` to `groundrules`). If you added it under an old name, use that name in the command above (check `/plugin` → Marketplaces) — or simply remove and re-add the marketplace from GitHub to pick up the current name and plugin.

`bootstrap`, `adopt` and `migrate` also perform a **best-effort update check** when invoked (single `git ls-remote` on this repo, ~3s timeout, silent when offline) and print a notice if a newer version is published. To update an already-bootstrapped **project** after updating the plugin, run `/groundrules:migrate` in that project.

## Usage

In the empty folder of a new project:

```bash
cd ~/Projects/my-new-project
claude
```

Then in Claude Code:

```
/groundrules:bootstrap
```

Answer the questions. The structure is generated, git is initialized, and (if requested) the remote repo is created.

## Plugin structure

```
groundrules/
├── .claude-plugin/plugin.json    # manifest
├── .claude-plugin/marketplace.json  # mono-plugin marketplace
└── skills/<name>/SKILL.md        # one slash command per skill
    bootstrap also has templates/  # Markdown templates
```

## Requirements for the remote

- `gh` CLI for GitHub: https://cli.github.com/
- `glab` CLI for GitLab: https://gitlab.com/gitlab-org/cli

If absent, the plugin shows the ready-to-paste commands for manual execution.

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
- [x] V0.12 — best-effort update check in `bootstrap`/`adopt`/`migrate`; marketplace renamed `claude-code-starter-kit`; groundrules rename decided for V1.0.0 (ADR 0017)
- [x] V1.0 — plugin renamed `starter-kit` → **`groundrules`** (ADR 0017): new command prefix `/groundrules:`, state file `.groundrules.json`, `migrate` handles the full legacy transition
- [x] V1.1 — `adopt` consolidate mode (migrate a brownfield layout onto the canonical paths); `PROCESS.md` + `RELEASE.md` optional docs; LEARNINGS rule format + Session Start protocol (harvested from a real project); "repo is the only memory" convention
- [ ] Post-1.0 — extend groundrules beyond Claude Code to other harnesses (repo name is harness-neutral by design)
- [x] Public marketplace published on GitHub: [lozit/claude-code-groundrules](https://github.com/lozit/groundrules)

## License

To be defined.
