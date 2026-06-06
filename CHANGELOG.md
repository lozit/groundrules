<!-- generated-by: groundrules v1.0.0 -->
# Changelog

All notable changes to this project are documented in this file.

Format inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
versions follow [Semantic Versioning](https://semver.org/).

## [1.0.0]

### BREAKING — plugin renamed `starter-kit` → `groundrules` (V1.0.0, ADR 0017)

*Ground rules: the rules a team agrees on at the start and lives by afterwards — applying best practices of documentation and configuration is what this plugin is about.*

- **Slash commands**: `/starter-kit:<skill>` → **`/groundrules:<skill>`** (all 7 skills; skill names unchanged).
- **State file**: `.starter-kit.json` → **`.groundrules.json`**, key `starterKitVersion` → `groundrulesVersion`. `migrate` renames it (`git mv`) and rewrites the key; all skills read the legacy file as fallback and point to `migrate`.
- **Signatures**: new files carry `<!-- generated-by: groundrules vX.Y.Z -->`. The legacy `starter-kit` form is still recognized everywhere (resume mode, `verify-bootstrap` — reported as ⚠️ legacy, fixable with `--fix`; `migrate` offers a grouped rewrite).
- **Marketplace & repo**: marketplace `claude-code-starter-kit` → **`claude-code-groundrules`** (the Claude Code distribution channel); repo `lozit/claude-code-starter-kit` → **`lozit/groundrules`** — harness-neutral on purpose: extending groundrules to other harnesses is a post-1.0 direction (GitHub redirects old URLs). Install spec: `/plugin install groundrules@claude-code-groundrules`. Users must re-add the marketplace / reinstall the plugin.
- **Migration path**: in each project, run `/groundrules:migrate` — it chains all historical renames and the V1.0 rename pass (state file, signatures, stale name references, command-prefix mentions) with per-step confirmation.
- Manifests: English descriptions, "formerly starter-kit" noted, keywords extended.

### Decisions
- ADR 0017 implemented (was accepted in 0.12.0). ADR index, README, meta docs and dogfood fully rebranded (the repo migrated itself: `.groundrules.json`, signatures, prefix).

## [0.12.0]

### Added
- **Best-effort plugin update check (Phase 0)** in `bootstrap`, `adopt` and `migrate`: compares the installed version against the latest published tag (`git ls-remote`, ~3s timeout, fail-silent offline) and prints a notice with the update commands when a newer version exists. `migrate` additionally warns that migrating with a stale plugin only brings the project up to the installed version. See ADR 0015.
- README: new "Updating the plugin" section (manual marketplace update, auto-update toggle, project update via `migrate`).

### Changed
- Contact email in `plugin.json` (`author`) and `marketplace.json` (`owner`) switched to the public address `guillaume.ferrari@protonmail.com`.
- **Marketplace renamed `starter-kit-local` → `claude-code-starter-kit`** (matches the GitHub repo; the old name was a leftover from the first local test). Install spec is now `starter-kit@claude-code-starter-kit`. Users who added the marketplace under the old name keep it locally (their `update` command still uses `starter-kit-local`) or can remove/re-add to pick up the new name. See ADR 0016.
- Plugin version bumped 0.11.0 → 0.12.0 across `plugin.json`, `marketplace.json`, all template/doc signatures, and `.starter-kit.json` (`starterKitVersion` + new migration entry).

### Decisions
- ADR `0015-best-effort-update-check.md` — why an in-skill check rather than a SessionStart hook or auto-update alone.
- ADR `0016-rename-marketplace.md` — marketplace rename rationale.
- ADR `0017-plugin-rename-at-v1.md` (**Accepted**) — the plugin will be renamed `starter-kit` → **`groundrules`** as the defining breaking change of V1.0.0 (namespace verified free: npm, PyPI, GitHub). `starter-kit` stays for the whole 0.x series; ~20 candidate names evaluated and recorded with verdicts (runner-up: `charter`).

## [0.11.0]

### Changed
- **`brief/` renamed to `intake/`** — the upstream-notes folder is now generated as `intake/` ("intake" = material received before processing), a clearer name than "brief" which suggests a single document. Template renames (`brief-INTENT.md.tpl` → `intake-INTENT.md.tpl`, `brief-README.md.tpl` → `intake-README.md.tpl`), `{{INTENT_SOURCE}}` values, and all path references updated across `bootstrap`/`adopt`, the generated templates, the public README, and the dogfood (`git mv brief intake`). See ADR 0014.
- `/starter-kit:migrate` learns the rename: for a pre-rename project it offers `git mv brief intake`, fixes `.starter-kit.json` paths, and flags stale `brief/` references in the project docs. Renames chain (a pre-0.7 `brief/00-INTENT.md` lands directly at `intake/INTENT.md`).
- Plugin version bumped 0.10.1 → 0.11.0 across `plugin.json`, `marketplace.json`, all template/doc signatures, and `.starter-kit.json` (`starterKitVersion` + new migration entry).

### Decisions
- ADR `0014-rename-brief-to-intake.md` — rationale and alternatives considered (`intent/`, `inbox/`, `upstream/`, …).

## [0.10.1]

### Changed
- Meta: documented the **batch-small-changes** release cadence in the root `CLAUDE.md` (accumulate under `[Unreleased]`; bump/tag/release only on explicit request).

## [0.10.0]

### Fixed
- **`/starter-kit:adopt` now always offers the optional/specialized docs.** Call 3 was gated on scan detection, so when nothing was detected the question was skipped and docs like `DATA_MODEL`/`SECURITY`/`DESIGN_SYSTEM`/`ROADMAP`/`I18N`/`ARCHITECTURE`/`GLOSSARY`/`CHANGELOG` were never proposed. Split into Call 3a (core missing docs) + **Call 3b (mandatory multiSelect listing all optional docs)** — detection only pre-checks, it no longer hides the list.

### Added
- **"Living docs" rule in the generated `CLAUDE.md`** (full + lean templates): every generated doc (`VISION`, `ARCHITECTURE`, `DATA_MODEL`, `SECURITY`, `README`, `CHANGELOG`, …) must be kept in sync **in the same change** that makes it stale — maintaining it is part of the task, not a follow-up.

### Changed
- Plugin version bumped 0.9.0 → 0.10.0 across `plugin.json`, `marketplace.json`, all template/doc signatures, and `.starter-kit.json` (`starterKitVersion` + new migration entry).

## [0.9.0]

### Changed
- **`media/` moved to `docs/media/`** — the asset folder is now generated under `docs/` instead of at the project root, to avoid colliding with a project's own top-level `media/` or `public/`. Updated across `bootstrap` (scan + mapping), `adopt`, the `CLAUDE.md`/`README` templates, and the dogfood (`media/README.md` → `docs/media/README.md` via `git mv`). See ADR 0013.
- `/starter-kit:migrate` learns the move: for a pre-0.9 project it offers to `git mv` a starter-kit `media/` to `docs/media/` (leaves a project's own unrelated `media/`/`public/` untouched).
- Plugin version bumped 0.8.0 → 0.9.0 across `plugin.json`, `marketplace.json`, all template/doc signatures, and `.starter-kit.json` (`starterKitVersion` + new migration entry).

### Decisions
- ADR `0013-media-under-docs.md` — rationale for moving the asset folder under `docs/`.

## [0.8.0]

### Changed
- **English-only** — dropped the bilingual FR/EN support. All `*.fr.tpl`/`*.fr.md` templates removed; English is now the single template set (one `.tpl` per file, no language suffix; `adr-template.md`). Removed the `{{LANG}}` placeholder, the "language" interview question, and all per-language template selection across `bootstrap`/`adopt`/`migrate`/`add-adr`/`learn`. The 7 `SKILL.md` files and the dogfood docs (README, root CLAUDE.md, VISION, INTENT, rules, best-practices-pending) were translated to English. Rationale: all projects are done in English; maintaining two language variants was overhead for no benefit. See ADR 0012.
- Plugin version bumped 0.7.0 → 0.8.0 across `plugin.json`, `marketplace.json`, all template/doc signatures, and `.starter-kit.json` (`starterKitVersion` + new migration entry; obsolete `answers.lang` dropped).

### Migration note
- `/starter-kit:migrate` on a pre-0.8 (bilingual) project does **not** overwrite French content with English: it reports language-change files for manual review and offers the new English template as `<file>.new`.

### Decisions
- ADR `0012-english-only.md` — rationale for dropping the bilingual FR/EN templates and the `{{LANG}}` logic.

## [0.7.0]

### Added
- **Optional specialized docs in `bootstrap`** (new interview call "Appel 2b", multiSelect): the skill can now generate, on demand, any of:
  - `docs/DATA_MODEL.md` — entities, relationships, row-level access rules, indexes, migrations
  - `docs/SECURITY.md` — authentication, authorization, personal data & GDPR, secrets, attack surface
  - `docs/DESIGN_SYSTEM.md` — colors/tokens, typography, spacing, components, accessibility
  - `docs/ROADMAP.md` — long-term milestones (distinct from the active `PLAN.md`)
  - `docs/I18N.md` — supported languages, translation organization, localized formats
- Templates added (FR + EN): `DATA_MODEL`, `SECURITY`, `DESIGN_SYSTEM`, `ROADMAP`, `I18N` (10 files).
- New `bootstrap` placeholders: `{{HAS_DATA_MODEL}}`, `{{HAS_SECURITY}}`, `{{HAS_DESIGN_SYSTEM}}`, `{{HAS_ROADMAP}}`, `{{HAS_I18N}}`.
- **"No AI attribution" policy detection** — `bootstrap`/`adopt` read (read-only) the project + global `CLAUDE.md` for a rule forbidding AI attribution (`no AI attribution`, `Co-Authored-By`, `Generated with Claude`…) and set `policies.noAiAttribution` in `.starter-kit.json`. When set, commits made (`bootstrap`) or suggested (`adopt`, `migrate`) carry **no AI attribution trailer/footer**, overriding the agent's default. Skills still never auto-commit beyond `bootstrap`'s own commit. See ADR 0011.
- **Deference to a tool-managed project CLAUDE.md** — when `bootstrap` (resume) / `adopt` find a `CLAUDE.md` already present (no starter-kit signature, often tool-managed e.g. a corporate `claude-manager`), starter-kit **never generates or overwrites** it. It detects management markers + a free zone (`END MANAGED` / `## Project-Specific Notes`) and offers (opt-in) to append a discoverability pointer to the starter-kit docs **into the free zone only**; if no free zone, it skips. Conflicts between managed rules and starter-kit conventions (e.g. commit AI-attribution) are surfaced, not resolved. Records `adoptedFiles["CLAUDE.md"]`. Takes precedence over the lean logic below. See ADR 0010.
- **Global/enterprise CLAUDE.md awareness** — `bootstrap`/`adopt` detect a global CLAUDE.md (`~/.claude/CLAUDE.md` + OS-managed policy paths). When present, the generated project CLAUDE.md **defers** to it: a new **lean** template pair (`CLAUDE.lean.md.{fr,en}.tpl`) keeps only project-specific sections + a deference header ("loaded in addition to the global; on conflict the global/enterprise rule wins"), and the full template gains a `{{GLOBAL_CLAUDE_NOTE}}` placeholder (filled when a global is detected, empty otherwise). No enterprise file is ever overwritten (different path) or silently diluted (content). See ADR 0009.
- **New skill `/starter-kit:adopt`** — onboards an existing (brownfield) project: scans, maps existing files to starter-kit roles (README, PLAN, backlog, intent-source, superpowers-interop), captures intent from existing docs, generates only what's missing, backfills `.starter-kit.json` with `adopted: true` + `adoptedFiles`. Never overwrites/deletes; no git init/remote; supports `--dry-run`. Fills the brownfield gap that `migrate` (refuses non-managed projects) and `bootstrap` (treats existing files as foreign) left open. See ADR 0008.
- **Pre-existing planning detection** in `bootstrap` Phase 1 (and reused by `adopt`): detects `PLAN.md` aliases — now **case-insensitive** (`plan.md`), **nested** (`docs/gtd/todos.md`), and **multiple** at once (`TODO.md`, `todos.md`, `TASKS.md`, `BACKLOG.md`…). When found, Appel 3 asks a reconciliation question (adopt existing / create alongside / port content into `PLAN.md`) instead of the standard yes/no — never overwrites, never deletes the alias. **Case-collision guard**: never generates `PLAN.md` when a case-variant exists (avoids a cross-platform git hazard). `docs/superpowers/plans/` is explicitly *not* treated as an alias (different altitude); `PLAN.md` is kept and should point to the active superpowers plan.

### Changed
- **De-numbered the entry docs** (dropped the `00-` prefix): `brief/00-INTENT.md` → `brief/INTENT.md`, `docs/00-VISION.md` → `docs/VISION.md`. The partial numbering scheme (only VISION/INTENT carried a number, no other doc did) provided no real ordering benefit. Updated across `bootstrap`/`apply-best-practices`/`verify-bootstrap` SKILLs, `brief-INTENT` templates, `README.md`, `.starter-kit.json` (`generatedFiles`), and the dogfood files themselves. Historical references (CHANGELOG `[0.5.0]`, ADR 0005, the migration `note`, the peer-structure quote) kept verbatim.
- Plugin version bumped 0.6.0 → 0.7.0 across `plugin.json`, `marketplace.json`, all template/doc signatures, and `.starter-kit.json` (`starterKitVersion` + new migration entry).
- `bootstrap/SKILL.md`: Phase 1 scan list, Phase 2 interview (new Appel 2b), Phase 5 placeholders and conditional file mapping updated.
- `README.md`: detailed "Fichiers générés" section extended with the 5 specialized docs.
- `CLAUDE.md.{fr,en}.tpl`: added a conditional "Interop with superpowers" note clarifying that starter-kit's durable project docs and [superpowers](https://github.com/obra/superpowers)' per-feature `docs/superpowers/specs|plans/` live at different altitudes (no duplication); `PLAN.md` should reference the active superpowers plan rather than duplicate tasks.

### Decisions
- ADR `0006-optional-specialized-docs.md` — rationale for adding these docs as opt-in conditional templates (and for excluding `tickets/`, Salesforce-style and project-specific docs).
- ADR `0007-denumber-entry-docs.md` — rationale for dropping the `00-` prefix on VISION/INTENT.
- ADR `0008-adopt-brownfield-projects.md` — rationale for a dedicated `/starter-kit:adopt` skill + broadened planning detection.
- ADR `0009-global-claude-md-awareness.md` — rationale for global CLAUDE.md detection + lean project CLAUDE.md.
- ADR `0010-managed-project-claude-md-deference.md` — rationale for deferring to an existing tool-managed project CLAUDE.md.
- ADR `0011-detect-no-ai-attribution-policy.md` — rationale for detecting a no-AI-attribution policy and adapting suggested commits.

## [0.6.0]

### Added
- New skill **`/starter-kit:verify-bootstrap`** — validates the coherence of a starter-kit-bootstrapped project:
  - Per-file checks: existence, `<!-- generated-by -->` signature presence, version match against `.starter-kit.json.starterKitVersion`, no unsubstituted `{{KEY}}` placeholders.
  - Structural checks: `.git/` present, `CLAUDE.md` ≤ 200 lines, JSON validity of `.starter-kit.json`/`.claude/settings.json`/`.claude-plugin/plugin.json`, intent ↔ vision coherence.
  - Output: ✅/⚠️/❌ checklist grouped by category.
  - `--fix` mode: corrects safe issues (signature version mismatches via `Edit`). Other issues remain manual (missing files, placeholders, invalid JSON, oversized CLAUDE.md).
  - Read-only by default; `--fix` requires explicit `AskUserQuestion` confirmation before applying.

### Changed
- Plugin version bumped 0.5.0 → 0.6.0 across `plugin.json`, `marketplace.json`, all template signatures, `.starter-kit.json`.
- `docs/best-practices-pending.md`: the `/verify-bootstrap` recommendation is marked as implemented (struck through).
- `.starter-kit.json`: V0.5 apply-best-practices `appliedPractices` entry updated — `verify-bootstrap` item moved from `deferred` to `applied (V0.6)`.

## [0.5.0] — internal, never released

### Added
- **Intent capture in `bootstrap`** (new Phase 3): the skill now asks if the user has a brief, accepts paste, file path, or in-interview questions (goal, users, constraints, non-goals, acceptance criteria). Produces:
  - `brief/00-INTENT.md` — raw source (when paste or file path)
  - `docs/00-VISION.md` — structured synthesis (always, unless skipped)
  - Templates: `brief-INTENT.md.{fr,en}.tpl`, `docs-VISION.md.{fr,en}.tpl`
- New skill **`/starter-kit:apply-best-practices`** — fetches `https://github.com/shanraisshan/claude-code-best-practice` via WebFetch, passes the project's `docs/00-VISION.md` as context, returns recommendations grouped by category (CLAUDE.md sections, `.claude/rules/`, settings.json permissions, hooks, custom skills) with High/Medium/Low priority. User picks via multi-select. Safe items applied automatically; hooks and custom skills saved to `docs/best-practices-pending.md` for manual review.
- `.starter-kit.json` schema extended with `intent` field (source, goal, users, constraints, nonGoals, acceptanceCriteria) and `appliedPractices` (array of `{appliedAt, source, items[]}`).

### Changed
- `bootstrap/SKILL.md` renumbered: Phase 3 (Intent) inserted, former Phase 3-7 shifted to Phase 4-8. Final recap (Phase 8) now suggests running `/starter-kit:apply-best-practices`.
- Plugin version bumped 0.4.0 → 0.5.0 across `plugin.json`, `marketplace.json`, all template signatures, `.starter-kit.json`.

### Dogfood
- Backfilled `brief/00-INTENT.md` retroactively from the original prompt that started this project.
- Synthesized `docs/00-VISION.md` capturing goal, 6 constraints, 5 non-goals, 7 acceptance criteria.
- `.starter-kit.json` records the V0.2 manual integration of shanraisshan/howborisusesclaudecode best practices under `appliedPractices` (so a future `/starter-kit:apply-best-practices` run can diff against them and propose new items).

## [0.4.0] — internal, never released

### Added
- New skill `/starter-kit:migrate` — upgrades a starter-kit-bootstrapped project to the current plugin version (diff per file, overwrite/keep/save-as-`.new`, `--dry-run` support, refuses downgrade).
- `.starter-kit.json` schema extended: `bootstrappedWithVersion` (immutable) + `migrations` array (append-only).

## [0.3.0] — internal, never released

### Added
- `/starter-kit:add-adr` — auto-incremented ADR creation with index update.
- `/starter-kit:learn` — dated entry prepended to `docs/LEARNINGS.md`.
- First two ADRs: `0001-marketplace-json-location.md`, `0002-plain-text-placeholder-substitution.md`.

## [0.2.0] — internal, never released

### Added
- `CLAUDE.md.{fr,en}.tpl` restructured to integrate best practices from `shanraisshan/claude-code-best-practice` and `howborisusesclaudecode.com`:
  - "Setup / Build / Test" section at the top
  - "Mettre à jour ce fichier" philosophy (Boris Cherny)
  - References to `.claude/settings.json`, `.claude/rules/*.md`, `<important if="...">` tags
  - "Vérifier le travail" / "Prove to me this works" section
  - "Workflow Claude Code" section: plan mode, `/compact`, `/clear`, git worktrees, delegation model
- EN variants for all previously FR-only templates
- `adr-template.md` split into `adr-template.{fr,en}.md`

### Fixed
- `marketplace.json` moved from repo root into `.claude-plugin/`
- V0.1 gap: LANG=en producing FR-content files for non-CLAUDE templates

## [0.1.0] — internal, never released

### Added
- Initial scaffolding: `.claude-plugin/plugin.json`, `marketplace.json`, `skills/bootstrap/SKILL.md` with 7-phase interactive workflow, 15 templates covering CLAUDE.md, README, ADR, LEARNINGS, brief, media, ARCHITECTURE, GLOSSARY, CHANGELOG, PLAN.
- Two-layer architecture (plugin sources vs project docs), dogfood applied to the repo itself.
