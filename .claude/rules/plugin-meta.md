---
paths:
  - ".claude-plugin/**"
  - "skills/**"
  - "**/*.tpl"
---
<!-- generated-by: starter-kit v0.8.0 -->

# Plugin meta-development rules

Auto-loaded when Claude touches plugin sources (manifests, skills, templates).

## Template over code

This repo is a Claude Code plugin, not an application. All logic lives in **Markdown instructions** in `skills/*/SKILL.md` that Claude executes on demand. For user templates (`*.tpl`), plain text `{{KEY}}` substitution only — never a template engine (Jinja, Handlebars...) nor application-code generation. Cf. ADR 0002.

## Dogfooding and two layers

The repo has **two disjoint layers** (cf. ADR 0003 + the root `CLAUDE.md`):
- **Layer A** = published sources (`.claude-plugin/`, `skills/`)
- **Layer B** = self-applied project docs (`README.md`, root `CLAUDE.md`, `docs/`, `brief/`, `media/`, `PLAN.md`...)

When you change something, ask: "layer A (sources) or layer B (dogfood)?". The paths never overlap.

## English-only

The plugin generates **English-only** output (cf. ADR 0012). There is one `.tpl` per file, no language suffix and no `{{LANG}}` logic. Don't reintroduce French templates or a language interview question.

## User handoff

Any `CLAUDE.md` produced by `bootstrap` is a **starter**, not a final truth. The user edits and enriches it. The template sections (Setup/Build/Test, Verifying the work, etc.) must be **fillable**: explicit placeholders (`<fill in>`), no fabricated values. Same for ADRs, LEARNINGS and VISION: structure provided, content fillable by the user.

## Versioning and signatures

Every generated file carries `<!-- generated-by: starter-kit vX.Y.Z -->`. Bump the version in `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, and the signature in **all** templates at each significant release. Cf. the root CLAUDE.md "Versioning" section.

## Idempotence and resume mode

All side-effecting skills (`bootstrap`, `adopt`, `migrate`, `apply-best-practices`) must support **re-running** without damage: detect what already exists, offer "skip / overwrite / save as .new", never silently overwrite.
