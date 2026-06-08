<!-- generated-by: groundrules v1.3.2 -->
# PLAN — groundrules

**Active** plan/todo for the project. Maintained by Claude during work.

This file differs from the long-term roadmap: it describes what is happening **now**.

## In progress

- [ ] End-to-end test of V0.6 `/groundrules:verify-bootstrap` on the dogfood itself (this run will be the validation)
- [ ] End-to-end real-world test on a **fresh project** (not the dogfood) for the full V0.5+V0.6 flow

## Up next

- [ ] V0.7 — Decide whether to implement the PreToolUse hook for `{{KEY}}` validation (cf. `docs/best-practices-pending.md`). verify-bootstrap now catches this post-hoc, so the hook is lower priority — but pre-write catch is still cleaner.
- [ ] V0.7 — Decide on `/watch-bootstrap` command (low priority, niche)
- [ ] Extend `/groundrules:migrate` to rename `00-VISION.md`/`00-INTENT.md` → `VISION.md`/`INTENT.md` on upgrade of pre-0.7 projects (cf. ADR 0007)
- [ ] Teach `/groundrules:verify-bootstrap` about adopted projects: tolerate `bootstrappedWithVersion: null`, validate `adoptedFiles` paths exist (cf. ADR 0008)

## Waiting / blocked

- [ ] ...

## Recently done

- [x] Hardened plugin-update docs (two-step: marketplace ≠ plugin) in README + Phase 0 notices; LEARNINGS + AGENT-EVALS capture of the trap — under `[Unreleased]` (2026-06-08)
- [x] New skill `/groundrules:slim` — propose CLAUDE.md optimizations to stay <200 lines (ADR 0024); verify-bootstrap points to it; no CLAUDE.md bloat — under `[Unreleased]` (2026-06-08)
- [x] Team portability: bootstrap + adopt suggest project-scope install (ADR 0023); README note; no CLAUDE.md bloat — under `[Unreleased]` (2026-06-08)
- [x] New skill `/groundrules:checkpoint` (manual capture ritual) + README "Capturing knowledge as you go" + wired the manual trigger into the CLAUDE.md convention (ADR 0022) — under `[Unreleased]` (2026-06-08)
- [x] Dogfooded the checkpoint ritual before pushing: added own `docs/AGENT-EVALS.md` + a LEARNINGS rule (anchor rituals to observable events) — under `[Unreleased]` (2026-06-08)
- [x] Agent-memory article → adopted session-close ritual (CLAUDE.md templates) + optional `docs/AGENT-EVALS.md` (ADR 0022); rejected journal/`.claude/memory`/`@import` auto-load — under `[Unreleased]` (2026-06-08)
- [x] Evaluated graphify (GraphRAG) → interop pointer in `docs/CONTEXT-ECONOMY.md` + optional large-codebase hint in `adopt` (no dependency) — under `[Unreleased]` (2026-06-08)
- [x] Context-economy study → `docs/CONTEXT-ECONOMY.md` + ADR 0021 + "map, not territory" note in CLAUDE.md templates (index over doc-search for own docs) — under `[Unreleased]` (2026-06-08)
- [x] README restructured pitch-before-install (superpowers-inspired) + MIT license — under `[Unreleased]` (2026-06-08)

- [x] V1.1.0 — adopt consolidate mode (ADR 0018) + heyjoe harvest (ADR 0019) + repo-is-the-only-memory (ADR 0020), validated E2E on crm-heyjoe (2026-06-07)
- [x] Post-release: npm name secured (`groundrules@0.0.1` placeholder published, pointer stub) + formal TMview check archived in ADR 0017 (2026-06-06)
- [x] V1.0.0 — full rebrand starter-kit → groundrules RELEASED: repo renamed lozit/groundrules (harness-neutral), manifests, 7 skills + legacy handling, templates, migrate V1.0 pass, dogfood self-migration (2026-06-06)
- [x] V0.12 — best-effort update check (Phase 0, ADR 0015) + marketplace renamed `claude-code-starter-kit` (ADR 0016) + public email + groundrules decision (ADR 0017) (2026-06-06)
- [x] V0.11 — renamed `brief/` → `intake/` (templates, skills, dogfood `git mv`) + migrate rename logic + ADR 0014 (2026-06-06)
- [x] V0.10 — fix: `adopt` always offers optional/specialized docs (Call 3b); add "living docs" maintenance rule to generated CLAUDE.md (2026-06-04)
- [x] V0.9 — moved `media/` → `docs/media/` (avoid collision with project media/public) + migrate move logic + ADR 0013 (2026-06-04)
- [x] V0.7 — optional specialized docs in `bootstrap` (DATA_MODEL, SECURITY, DESIGN_SYSTEM, ROADMAP, I18N) + ADR 0006 (2026-06-03)
- [x] V0.7 — de-number entry docs: `00-VISION.md`→`VISION.md`, `00-INTENT.md`→`INTENT.md` + ADR 0007 (2026-06-03)
- [x] V0.7 — new skill `/starter-kit:adopt` (brownfield) + broadened planning detection (case-insensitive/nested/multiple + collision guard) + ADR 0008 (2026-06-03)
- [x] V0.8 — English-only: dropped FR templates + `{{LANG}}` logic, single `.tpl` per file, all skills/docs translated to English + ADR 0012 (2026-06-04)
- [x] V0.7 — global/enterprise CLAUDE.md awareness: detection + lean template (`CLAUDE.lean.md.tpl`) + `{{GLOBAL_CLAUDE_NOTE}}` + ADR 0009 (2026-06-03)
- [x] V0.7 — defer to tool-managed project CLAUDE.md (no generation, opt-in docs pointer into free zone) + ADR 0010 (2026-06-03)
- [x] V0.7 — detect "no AI attribution" policy → `policies.noAiAttribution` + adapt suggested/made commits (bootstrap/adopt/migrate) + ADR 0011 (2026-06-03)
- [x] V0.6 — `/starter-kit:verify-bootstrap` skill (report ✅/⚠️/❌ + `--fix` for trivial signature bumps) (2026-05-11)
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
