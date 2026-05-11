<!-- generated-by: starter-kit v0.2.0 -->
# Changelog

All notable changes to this project are documented in this file.

Format inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased — 0.2.0]

### Added
- `CLAUDE.md.{fr,en}.tpl` restructured to integrate best practices from `shanraisshan/claude-code-best-practice` and `howborisusesclaudecode.com`:
  - "Setup / Build / Test" section at the top (executable commands first)
  - "Mettre à jour ce fichier" philosophy: CLAUDE.md is mutable, update it after every Claude mistake (Boris Cherny)
  - References to `.claude/settings.json`, `.claude/rules/*.md` (`paths:` scoping), `<important if="...">` tags
  - "Vérifier le travail" section ("Prove to me this works", behavior diff requirement)
  - "Workflow Claude Code" section: plan mode, `/compact`, `/clear`, git worktrees, delegation model (Opus 4.6+)
- EN variants for all previously FR-only templates (LEARNINGS, brief, media, PLAN, ARCHITECTURE, CHANGELOG, GLOSSARY, adr-template)
- `adr-template.md` split into `adr-template.fr.md` and `adr-template.en.md`; SKILL.md mapping updated to `adr-template.{lang}.md`

### Changed
- Plugin version bumped from 0.1.0 to 0.2.0 in `.claude-plugin/plugin.json`, `marketplace.json`, all template `<!-- generated-by -->` signatures, `.starter-kit.json`, and SKILL.md commit message
- `PLAN.md.tpl` (FR and EN): replaced project-specific placeholder tasks with a neutral "(add the first active tasks here)"

### Fixed
- `marketplace.json` moved from repo root into `.claude-plugin/` (Claude Code expects this exact path)
- V0.1 gap: choosing LANG=en used to produce FR-content files for everything except CLAUDE.md/README.md/decisions-README

<!--
## [0.2.0] - YYYY-MM-DD  (first public release — to date when published)

## [0.1.0] - YYYY-MM-DD  (internal scaffolding, never released)
-->
