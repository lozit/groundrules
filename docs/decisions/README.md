<!-- generated-by: groundrules v1.2.0 -->
# Architecture Decisions (ADR)

This folder contains the project's **Architecture Decision Records**: each structural decision made during the project is recorded in a file.

## Format

Inspired by [Michael Nygard](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions). See `0000-template.md`.

## Naming convention

`NNNN-title-kebab.md` where NNNN is a 4-digit incremental integer.

Examples:
- `0001-database-choice.md`
- `0002-auth-pattern.md`

## When to create an ADR

When a decision:
- has a **long-term impact** on the architecture
- is **hard to reverse**
- has **explicit tradeoffs** worth documenting
- might be **revisited later** (better to freeze the context now)

No ADR needed for trivial choices or implementation details.

## Index

| # | Title | Status | Date |
|---|---|---|---|
| 0000 | Template | — | — |
| [0001](0001-marketplace-json-location.md) | `marketplace.json` lives in `.claude-plugin/`, not at the repo root | Accepted | 2026-05-11 |
| [0002](0002-plain-text-placeholder-substitution.md) | Plain text placeholder substitution, no templating engine | Accepted | 2026-05-11 |
| [0003](0003-multi-skill-architecture.md) | Multi-skill architecture with `disable-model-invocation: true` | Accepted | 2026-05-11 |
| [0004](0004-starter-kit-json-schema.md) | `.starter-kit.json` schema with `bootstrappedWithVersion` and `migrations` | Accepted | 2026-05-11 |
| [0005](0005-intent-capture-and-apply-best-practices.md) | Intent capture in bootstrap + separate `apply-best-practices` skill | Accepted | 2026-05-11 |
| [0006](0006-optional-specialized-docs.md) | Optional specialized docs in bootstrap (DATA_MODEL, SECURITY, DESIGN_SYSTEM, ROADMAP, I18N) | Accepted | 2026-06-03 |
| [0007](0007-denumber-entry-docs.md) | Drop the numeric prefix on entry docs (VISION / INTENT) | Accepted | 2026-06-03 |
| [0008](0008-adopt-brownfield-projects.md) | Adopt existing (brownfield) projects via a dedicated `/starter-kit:adopt` skill | Accepted | 2026-06-03 |
| [0009](0009-global-claude-md-awareness.md) | Global/enterprise CLAUDE.md awareness + lean project CLAUDE.md | Accepted | 2026-06-03 |
| [0010](0010-managed-project-claude-md-deference.md) | Defer to an existing tool-managed project CLAUDE.md (no generation, opt-in docs pointer) | Accepted | 2026-06-03 |
| [0011](0011-detect-no-ai-attribution-policy.md) | Detect a "no AI attribution" policy and adapt suggested commits | Accepted | 2026-06-03 |
| [0012](0012-english-only.md) | English-only (drop bilingual FR/EN templates) | Accepted | 2026-06-04 |
| [0013](0013-media-under-docs.md) | Move media under docs/ (docs/media/) | Accepted | 2026-06-04 |
| [0014](0014-rename-brief-to-intake.md) | Rename the brief/ folder to intake/ | Accepted | 2026-06-06 |
| [0015](0015-best-effort-update-check.md) | Best-effort plugin update check in skills (Phase 0) | Accepted | 2026-06-06 |
| [0016](0016-rename-marketplace.md) | Rename the marketplace starter-kit-local → claude-code-starter-kit | Accepted | 2026-06-06 |
| [0017](0017-plugin-rename-at-v1.md) | Rename the plugin to groundrules at V1.0.0 | Accepted | 2026-06-06 |
| [0018](0018-adopt-consolidation-mode.md) | adopt: map-in-place vs consolidate strategies | Accepted | 2026-06-06 |
| [0019](0019-heyjoe-inspired-doc-improvements.md) | Doc improvements harvested from a real project (crm-heyjoe) | Accepted | 2026-06-06 |
| [0020](0020-repo-is-the-only-memory.md) | The repo is the only memory (no project knowledge in agent-local state) | Accepted | 2026-06-07 |
| [0021](0021-context-economy-index-over-doc-search.md) | Context economy: index over doc-search for a project's own docs | Accepted | 2026-06-08 |
| [0022](0022-agent-evals-and-session-close.md) | Session-close ritual + optional agent-evals log | Accepted | 2026-06-08 |
