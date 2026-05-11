<!-- generated-by: starter-kit v0.5.0 -->
# PLAN — Starting-Claude

**Active** plan/todo for the project. Maintained by Claude during work.

This file differs from the long-term roadmap: it describes what is happening **now**.

## In progress

- [ ] End-to-end real-world test: bootstrap a brand-new project at V0.5 to validate the intent capture flow (brief paste path AND interview path) + run `apply-best-practices` to validate the WebFetch + multi-select + apply flow
- [ ] Optional ADR 0005 — V0.5 intent capture and apply-best-practices architecture decisions

## Up next

- [ ] Optional V0.6 — hook (pre-commit?) that auto-bumps `<!-- generated-by -->` signatures when migrating

## Waiting / blocked

- [ ] ...

## Recently done

- [x] V0.5 — intent capture in `bootstrap` (Phase 3) + new skill `/starter-kit:apply-best-practices` + dogfood backfill of `brief/00-INTENT.md` + `docs/00-VISION.md` (2026-05-11)
- [x] Published to GitHub: https://github.com/lozit/claude-code-starter-kit (public marketplace) (2026-05-11)
- [x] ADR 0003 — multi-skill architecture rationale (2026-05-11)
- [x] ADR 0004 — `.starter-kit.json` schema with `bootstrappedWithVersion` and `migrations` (2026-05-11)
- [x] V0.4 — skill `/starter-kit:migrate` with diff-per-file + `.new` fallback + `--dry-run` (2026-05-11)
- [x] V0.3 — skills `/starter-kit:add-adr` and `/starter-kit:learn` (2026-05-11)
- [x] First two ADRs written: `0001-marketplace-json-location.md`, `0002-plain-text-placeholder-substitution.md` (2026-05-11)
- [x] V0.2 — `CLAUDE.md.{fr,en}.tpl` restructured with Boris Cherny / shanraisshan best practices (2026-05-11)
- [x] V0.1.1 — EN variants for all FR-only templates (2026-05-11)
- [x] V0.1 — Project bootstrapped, skill + 15 templates + dogfood (2026-05-11)

---

**Convention**: Claude updates this file at the start/end of each session. Completed tasks stay in "Recently done" for ~1 week then are archived (deleted or moved to CHANGELOG).
