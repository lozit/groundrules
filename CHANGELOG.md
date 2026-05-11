<!-- generated-by: starter-kit v0.6.0 -->
# Changelog

All notable changes to this project are documented in this file.

Format inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased — 0.6.0]

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
