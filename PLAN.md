<!-- generated-by: groundrules v1.5.0 -->
# PLAN — groundrules

**Active** plan/todo for the project. Maintained by Claude during work.

This file differs from the long-term roadmap: it describes what is happening **now**.

## In progress

- [ ] **M1 — Loop-readiness OPENED** (2026-06-14). Building brick by brick (each its own PRD). Order: **(1) minimal runnable loop** → (2) wire scaffolding into bootstrap/adopt → (3) `/groundrules:realize` → (4) TDD-gate → (5) backward-crossing → (6) template refinement. Full milestone in [`docs/ROADMAP.md`](docs/ROADMAP.md) (M1).
  - [ ] **Brick 1 — Minimal runnable loop** (PRD `docs/prd/loop-minimal-runnable.md`, draft). Prototype maker/verifier + LOOP.md + capped runner + blocked.md, validated by subagent simulation on a fixture (good path + adversarial reject + block) **before** productizing. *(reflection done → build next, awaiting go)*

## Up next


> **Long-term milestones moved to [`docs/ROADMAP.md`](docs/ROADMAP.md)** — M1 *Loop-readiness* (loop scaffolding opt-in, `/groundrules:realize`, triage convention; ADR 0027) and M2 *Multi-harness support*. They enter "In progress" here, and get a PRD/ADR, only when actively tackled.

<!-- Triaged 2026-06-08: stale items removed (already implemented): migrate 00-VISION rename; verify-bootstrap adopted projects.
     Closed as won't-do (ADR 0025): PreToolUse {{KEY}} hook; /watch-bootstrap. -->

## Ideas — to triage

Raw ideas, captured before they're lost. Not yet vetted. Each gets triaged later → a **decision** (ADR), a **build** (PRD), a **milestone** (ROADMAP), or dropped.

- [ ] *(empty — both 2026-06-14 authoring wins done: CSO description audit + AGENT-EVALS guard hardening format → Recently done)*

<!-- 2026-06-13 first batch triaged: #1 dashboard -> ROADMAP M3; #2 vision & #3 adopt-analysis -> Up next; #4 superpowers research -> done (LEARNINGS + ROADMAP M1). -->


## Waiting / blocked

- [ ] ...

## Recently done

- [x] **2 authoring wins (from superpowers research)** — (1) **CSO audit**: all 12 skill `description:` rewritten WHEN-first (not workflow summaries) + durable rule in `.claude/rules/plugin-meta.md`; (2) **AGENT-EVALS guard hardening**: optional rationalization-table + red-flag format in `AGENT-EVALS.md.tpl` + `checkpoint`. Both Ideas-batch items cleared — under `[Unreleased]` (2026-06-14)

- [x] **Released V1.5.0** — vision skill, content-aware tailoring (retire lean), adoption-log, superpowers research. 74 signatures swept, pushed + tagged + GitHub release. (2026-06-14)

- [x] **`adopt` → opt-in `docs/ADOPTION-LOG.md`** (idea #3 — reframed during PRD: a **feedback log**, not a structural audit). Records what was here + what groundrules did (with *why*) + a Remarks section to annotate and share back to improve the plugin. New `ADOPTION-LOG.md.tpl`, Phase 5b in `adopt`, README row. PRD `docs/prd/adoption-log.md`. **Fresh-subagent E2E** (fresh + resume): self-contained + honest log, resume-safe (`.new`, original intact); caught 2 instruction gaps (generatedFiles destination, `.new`-branch recording), fixed — under `[Unreleased]` (2026-06-14)

- [x] **Content-aware CLAUDE.md tailoring — lean template retired** ([ADR 0029](docs/decisions/0029-content-aware-claude-md-tailoring.md), supersedes 0009). Rewrote `bootstrap` Phase 5 (read global content → omit only covered sections, bias-to-keep, omission list + veto) + `adopt` (content-aware + gap-driven free-zone additions); deleted `CLAUDE.lean.md.tpl`; 0009 superseded-header + index; meta `CLAUDE.md` fixed. **Fresh-subagent E2E** on no/thin/rich globals: all correct (thin → no holes; rich → 5 sections omitted, signature kept, `## Don't` kept) + caught 4 instruction frictions (dead generic-Don'ts clause, coverage threshold, orphan parent heading, leading-newline), all fixed — under `[Unreleased]` (2026-06-14)

- [x] **New skill `/groundrules:vision`** (idea #2) — guided VISION interview, create-if-absent / refine-if-present; PRD `docs/prd/vision-skill.md`; README workflow (skill↔README drift 12/12) + CHANGELOG. **Fresh-subagent E2E** (superpowers #10) on no-vision + thin-vision fixtures: both flows correct (create → clean VISION, name from README H1; refine → no overwrite, `.new`) and it **caught a real bug** (Phase 3 rebuild contradicted Phase 1 edit-in-place on refine) + 3 frictions, all fixed. Captured the authoring lesson in LEARNINGS — under `[Unreleased]` (2026-06-13)

- [x] **Superpowers research (idea #4)** — reviewed its 13 skills + reviewer prompts; borrowable patterns + rejected ones captured in `docs/LEARNINGS.md`; verifier/maker contract design note added to ROADMAP M1; 2 authoring-win ideas spawned (CSO description audit, rationalization-table guards) — under `[Unreleased]` (2026-06-13)

- [x] **Triaged the 2026-06-13 idea batch** — #1 dashboard → ROADMAP M3 (companion-tool, archi caveat); #2 vision skill & #3 adopt-analysis → Up next (PRD); #4 superpowers research → done — (2026-06-13)

- [x] **Git workflow review closed — [ADR 0028](docs/decisions/0028-git-workflow-conventions.md)**: (1) branching neutral in template + trunk-based dogfood; (2) **boundary commits** (completed chunks, Conventional Commits, tag at release — not a mega-commit per release); (3) **AI attribution by default, deferring to any forbidding rule** (global CLAUDE.md / `policies.noAiAttribution`). No history rewrite. Meta `CLAUDE.md` Git workflow section updated — under `[Unreleased]` (2026-06-13)

- [x] **New skill `/groundrules:idea`** — parks a one-line idea in `PLAN.md`'s "Ideas — to triage" inbox (append-only, creates section if absent); `PLAN.md.tpl` + README workflow updated; dogfooded the skill↔README drift check (11/11) — under `[Unreleased]` (2026-06-13)

- [x] **superpowers interop sharpened + README section** for superpowers users; LEARNINGS (verified facts), ROADMAP M1 deferral, `/groundrules:prd` thin-PRD-above + ask-on-doubt — under `[Unreleased]` (2026-06-13)

- [x] **Method captured — [ADR 0027](docs/decisions/0027-reflection-realization-interactive-loop.md)**: reflection vs realization phases; interactive vs loop regimes; the doc as method-agnostic contract; bidirectional frontier crossed on purpose; PRD (build) vs ADR (decision) as reflection outputs; the "could-act ≠ cleared-to-act" guard (back pressure of reflection, reappears in the loop verifier); plan mode as native enforcement. Spun from the *Write Loops, Not Prompts* + variolab intake docs. Created `docs/ROADMAP.md` (M1 loop-readiness, M2 multi-harness); validated the 2026-06-13 AGENT-EVALS guard entry — under `[Unreleased]` (2026-06-13)

- [x] Git workflow point 1 — `CLAUDE.md.tpl` branching note made neutral/fillable + meta `CLAUDE.md` states trunk-based; release-time README-review rule added to meta Versioning — under `[Unreleased]` (2026-06-13)

- [x] README: dropped the Roadmap; added "What the research says" + "References" to show choices are science-driven. Enriched to 5 rows across 3 fields — LLM behavior (context rot, lost-in-middle, sycophancy, <200-line), software-engineering economics (Boehm 1981 → PRD), usability (Nielsen #3 → reversibility) — with two honest caveats labelling established standards (ADRs/Changelog/Conventional Commits) as such, not science — under `[Unreleased]` (2026-06-13)

- [x] Harvested the four-principles doc (intake): `## Posture` (pushback + reversibility) in CLAUDE.md templates + new `/groundrules:prd` skill (superpowers-aware), ADR 0026 — under `[Unreleased]` (2026-06-13)

- [x] **E2E on a fresh project** (kitchen-sink bootstrap in /tmp, all docs) → bootstrap→verify **23/23 PASS**; caught & fixed a real `verify-bootstrap` false-positive on `.gitignore` the dogfood couldn't reveal + a LEARNINGS rule (validate on a fresh bootstrap) (2026-06-08)

- [x] E2E `verify-bootstrap` on the dogfood: **15/15 coherent** after sharpening the placeholder check with an explicit **backtick rule** (backticked `{{KEY}}` = doc reference, ignore; only bare = real leftover) — surfaced 2 false positives in own CHANGELOG/PLAN (2026-06-08)

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
