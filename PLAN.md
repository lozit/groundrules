<!-- generated-by: starter-kit v0.6.0 -->
# PLAN — Starting-Claude

**Active** plan/todo for the project. Maintained by Claude during work.

This file differs from the long-term roadmap: it describes what is happening **now**.

## In progress

- [ ] End-to-end test of V0.6 `/starter-kit:verify-bootstrap` on the dogfood itself (this run will be the validation)
- [ ] End-to-end real-world test on a **fresh project** (not the dogfood) for the full V0.5+V0.6 flow

## Up next

- [ ] V0.7 — Decide whether to implement the PreToolUse hook for `{{KEY}}` validation (cf. `docs/best-practices-pending.md`). verify-bootstrap now catches this post-hoc, so the hook is lower priority — but pre-write catch is still cleaner.
- [ ] V0.7 — Decide on `/watch-bootstrap` command (low priority, niche)

## Waiting / blocked

- [ ] ...

## Recently done

- [x] V0.6 — `/starter-kit:verify-bootstrap` skill (rapport ✅/⚠️/❌ + `--fix` for trivial signature bumps) (2026-05-11)
- [x] First real-world run of `/starter-kit:apply-best-practices` on the dogfood (2026-05-11)
- [x] ADR 0005 — Intent capture in bootstrap + separate apply-best-practices skill (2026-05-11)
- [x] V0.5 — intent capture in `bootstrap` + new skill `apply-best-practices` + dogfood backfill of brief/vision (2026-05-11)
- [x] Published to GitHub: https://github.com/lozit/claude-code-starter-kit (public marketplace) (2026-05-11)
- [x] ADRs 0003 (multi-skill architecture) + 0004 (.starter-kit.json schema) (2026-05-11)
- [x] V0.4 — skill `/starter-kit:migrate` with diff-per-file + `.new` fallback + `--dry-run` (2026-05-11)
- [x] V0.3 — skills `/starter-kit:add-adr` and `/starter-kit:learn` (2026-05-11)
- [x] ADRs 0001 + 0002 (2026-05-11)
- [x] V0.2 — `CLAUDE.md.{fr,en}.tpl` restructured with Boris Cherny / shanraisshan best practices (2026-05-11)
- [x] V0.1 — Project bootstrapped, skill + 15 templates + dogfood (2026-05-11)

---

**Convention**: Claude updates this file at the start/end of each session. Completed tasks stay in "Recently done" for ~1 week then are archived (deleted or moved to CHANGELOG).
