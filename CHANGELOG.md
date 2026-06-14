<!-- generated-by: groundrules v1.5.0 -->
# Changelog

All notable changes to this project are documented in this file.

Format inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- **M1 brick 3 — new skill `/groundrules:realize`**. The forward bridge from an approved plan to an executable backlog: ingests a plan (paste · a PRD's *Build plan* · `PLAN.md` tasks), classifies each task `[loop]` (atomic · isolatable · verifiable · invariant-aware · no embedded decision) vs `[supervised]`, **refuses to tag `[loop]` anything without a re-runnable stop condition** (the reflection-side back pressure), and on explicit confirmation writes the `[loop]` tasks into `loop/backlog.md` (maker-consumable, append/merge, idempotent) while tagging `[supervised]` in `PLAN.md` in place. Conservative default-to-`[supervised]`, never auto-promotes (could-act ≠ cleared-to-act, ADR 0027 §4). Preconditions: requires loop scaffolding (offers inline generation if absent); **defers to superpowers** when present. Brick 3 only checks a stop condition *exists* — the TDD acceptance-test gate is brick 4. PRD `docs/prd/realize-skill.md`.
- **M1 brick 2 — opt-in loop scaffolding in `bootstrap`/`adopt`**. A dedicated, off-by-default question (bootstrap Call 2c / adopt Call 3c) generates a `loop/` namespace from the validated brick-1 contract: `maker.md`, `verifier.md` (independent, distrusts the maker's report, two-stage spec-then-quality, *can reject a too-weak test*), `LOOP.md`, a capped `run-loop.sh` (hard `MAX`), `backlog.md` (loop-safe tasks only — the loop reads this, never `PLAN.md`), `loop/.gitignore`, and a `loop/README.md`. Adds a conditional `## Invariants` section to the generated `CLAUDE.md` (the verifier enforces it each iteration). The 3 brick-1 contract fixes are baked in (separate-context verifier · reject-too-weak-test · stage-the-diff-not-`git add -A`). **Not offered when superpowers is detected** (defer the whole realization). `.groundrules.json` gains `loop.scaffolded`; resume-safe (missing-only). Structure: [ADR 0030](docs/decisions/0030-loop-namespace-and-backlog.md). PRD `docs/prd/loop-scaffolding-bootstrap-adopt.md`. `/groundrules:realize` (auto-fill the backlog) is the next brick.
- **M1 brick 1 — minimal runnable loop prototype** (`docs/prototypes/loop/`, **not shipped**, not wired into `bootstrap`/`adopt` yet). The maker/verifier loop contract as pure Markdown prompts (ADR 0002/0025): `maker.md` (4-status protocol DONE/DONE_WITH_CONCERNS/BLOCKED/NEEDS_CONTEXT), `verifier.md` (two-stage ordered review — spec THEN quality — that distrusts the maker's report and re-derives from the diff), `LOOP.md` (the per-iteration replay), a capped `run-loop.sh` (mandatory `MAX` anti-runaway), the `blocked.md` convention (the realization→reflection backward crossing), and a `slugify` fixture + pre-written acceptance test. **Validated by subagent simulation** on all three paths: good (converge), adversarial (verifier REJECTs a green-but-gamed diff), block (maker parks instead of guessing). Verdict + contract fixes captured in `docs/LEARNINGS.md`. PRD `docs/prd/loop-minimal-runnable.md`. See ADR 0027 / ROADMAP M1.

### Changed
- **README `## Built for the age of loops`** (after *Why*) — explains how groundrules fits the *"write loops, not prompts"* shift: the loop paradigm's "the model forgets, the repo remembers" is groundrules' own thesis (same context-rot evidence), groundrules generates the durable on-disk state a loop re-reads each iteration (*loop-ready*), and it's the antidote to the **comprehension debt** loops create ("loops write the code fast; groundrules keeps the understanding"). Honest about present (memory + reflection layer) vs roadmap (loop scaffolding — ADR 0027 / M1). Also added `.gitattributes` so GitHub Linguist shows Markdown, not "Go Template" (the `{{KEY}}` templates were mis-detected).
- **Skill `description:` fields rewritten WHEN-first (CSO)** — all 12 skill descriptions now state *when to use* the skill, not a workflow summary (a summary can make Claude follow the description and skip the SKILL body — superpowers' `writing-skills`, see `docs/LEARNINGS.md`). New authoring rule in `.claude/rules/plugin-meta.md`; `vision` is the reference shape.
- **AGENT-EVALS guard hardening format** — the `AGENT-EVALS.md.tpl` and the `checkpoint` skill now document an optional **rationalization table** (excuse-under-pressure → rebuttal) + **red-flag stop-line** for a *stubborn* guard that keeps getting rationalized away (borrowed from superpowers; formalizes the eval→guard loop, ADR 0022).

### Decisions
- ADR `0030-loop-namespace-and-backlog.md` — for M1 brick 2: a single visible top-level `loop/` is the loop's namespace; the loop reads `loop/backlog.md` (loop-safe tasks only), **never `PLAN.md` directly** (which only points to it). Rejected a hidden `.groundrules/loop/` (treats the prompts as a black box, against handoff-not-gospel), `docs/loop/` (wrong altitude for an executable), and a `[loop]`-tagged section of `PLAN.md` (the loop would race the human's surface + need a perfect tag-filter; our "compare by altitude" learning says separate the volatile/agent-touched from the durable/human-curated).

## [1.5.0]

### Added
- **`adopt` → opt-in `docs/ADOPTION-LOG.md`** — at the end of an adopt run, offer to write a dated, frozen **record of the run**: what was here, what groundrules did (and *why* — skips/deferrals included), plus a **Remarks** section to annotate. Purpose: a **field → plugin feedback channel** — share the annotated log back to improve groundrules. Built from the scan + `.groundrules.json` (no new data, no network). New template `ADOPTION-LOG.md.tpl`. Distinct from `AGENT-EVALS` (agent behaviour) and `apply-best-practices` (external recs). Spec'd in `docs/prd/adoption-log.md`.
- **New skill `/groundrules:vision`** — builds or refreshes `docs/VISION.md` through a **guided interview** (goal · users · constraints · V1 non-goals · acceptance criteria), reusing `docs-VISION.md.tpl`. **Create-if-absent / refine-if-present** (section-by-section, never silent overwrite). On-demand: for adopt/brownfield projects with no vision, or to deepen a thin one — **complements `bootstrap`** (no refactor of it). Borrows superpowers' interview discipline (2-3 framings + a recommendation, decompose over-scope, a pre-write self-review) while keeping groundrules' propose-don't-impose register. Spec'd in `docs/prd/vision-skill.md`. See ADR 0027 (method) + `docs/LEARNINGS.md` (borrowed patterns).

### Changed
- **Content-aware CLAUDE.md tailoring — `CLAUDE.lean.md.tpl` retired** (ADR 0029, supersedes 0009). The project CLAUDE.md no longer defers to a global by a *boolean of presence* (which left **holes** when the global was thin). Now there's **one** template (`CLAUDE.md.tpl`): `bootstrap`/`adopt` **read the global's content** and omit **only the sections it actually covers** (conservative set: Commits · Permissions · Verifying · Claude Code workflow · Git workflow; `## Don't` always kept), always keeping groundrules' signature conventions (Posture, capture ritual, when-to-document, repo-is-memory, living docs) — bias-to-keep, with a **user-facing omission list + veto**. `adopt`'s additions to an existing managed CLAUDE.md are now **gap-driven** (only what's missing). A thin global → output ≈ full; a rich global → ≈ the old lean; no holes.
- **Superpowers research captured** (`docs/LEARNINGS.md`) — borrowable patterns (two-stage ordered verifier, distrust-the-report, evidence-before-claim gate, no-placeholder acceptance bar, maker four-status protocol; CSO authoring rule; interview principles) and explicitly-rejected ones (mandatory TDD, coercive gates, always-on bootstrap — conflict with handoff-not-gospel / no-runtime). `docs/ROADMAP.md` M1 gains a "verifier/maker contract" design note; M3 (cross-project dashboard, companion-tool) added.

### Removed
- **`skills/bootstrap/templates/CLAUDE.lean.md.tpl`** — replaced by content-aware tailoring of the single `CLAUDE.md.tpl` (see Changed / ADR 0029).

### Decisions
- ADR `0029-content-aware-claude-md-tailoring.md` — retire the lean template; tailor one template against the global's *content* (omit only what it covers, bias-to-keep, omission list + veto). **Supersedes ADR 0009** (presence-based lean), the disciplined way (header on 0009, index updated). Template-over-code (ADR 0002) preserved — the tailoring lives in SKILL instructions, not a template engine.
- Plugin version bumped 1.4.0 → 1.5.0 across manifests, signatures (74 files), and `.groundrules.json` (+ migration entry). Shipped as boundary commits (ADR 0028) with consistent `Co-Authored-By` attribution.

## [1.4.0]

### Added
- **`## Posture` in the generated `CLAUDE.md`** (full + lean) — tells the agent to **push back** (challenge off-strategy/wrong/inconsistent plans, surface tradeoffs, ask before guessing, no sycophancy) and **stay reversible** (confirm before hard-to-undo actions; lean on git + `/rewind`). Harvested from `intake/principles-claude-code.md`. See ADR 0026.
- **New skill `/groundrules:prd`** — writes a per-feature PRD (problem, success criteria, scope in/out, constraints, build plan, risks) to `docs/prd/<feature>.md` before building. **Superpowers-aware**: defers to superpowers' per-feature spec workflow when that plugin is present, provides the PRD itself when it isn't. New template `PRD.md.tpl`. See ADR 0026.
- **New skill `/groundrules:idea`** — parks a one-line idea in `PLAN.md`'s **"Ideas — to triage"** inbox (creates the section if absent; append-only). Prospective capture (forward ideas), the operational tool of the *capture-before-it's-lost* discipline and the complement to `/groundrules:checkpoint` (retrospective). `PLAN.md.tpl` gains the inbox section by default. See ADR 0027.

### Changed
- **README**: removed the version-by-version **Roadmap** (history lives in `CHANGELOG.md`); added a **"What the research says"** section mapping each design choice to published findings across three fields — language-model behavior (context rot, lost-in-the-middle, sycophancy, Anthropic's <200-line guidance), software-engineering economics (Boehm 1981, cost-of-defect → per-feature PRD), and usability (Nielsen heuristic #3 "user control and freedom" → reversibility) — and a separate **"Established practices we adopt"** section (ADRs/Nygard, Keep a Changelog, Conventional Commits, SemVer) that owns the recognized *standards* so they're never dressed up as lab science, plus a matching **"References"** bibliography. Makes explicit that the choices are evidence-driven, not marketing.

- **README `## Already using superpowers?`** — a section for superpowers users: the two work at different altitudes (superpowers owns realization; groundrules adds the durable *why*, the PRD-altitude above, and the cross-cutting "now"), framed as "superpowers builds the loop, groundrules keeps you the engineer".
- **Sharpened superpowers interop** (verified against the `obra/superpowers` source) — superpowers creates **specs + TDD plans** (`docs/superpowers/specs|plans/`), not "PRDs", and imposes TDD + a maker/verifier; its spec omits **risks / measurable success criteria / problem framing**. So `/groundrules:prd` now: defers the *whole realization* (not just a spec), offers a **thin PRD above** for the missing altitude, and **asks instead of presuming** when the (overridable) detection path is absent. The generated `CLAUDE.md` interop note gains the "PRD altitude above" line; ROADMAP M1 notes loop scaffolding is the *non-superpowers* case. Facts captured in `docs/LEARNINGS.md`.
- **`checkpoint` skill — 4th bucket "shipped a user-facing surface → sync the doc"** — the capture ritual now also nudges to keep `README.md`/docs in sync when a command, output, or config option ships (living docs), in the doc's existing voice (no regeneration). README gained the missing `docs/prd/` row in *What's generated*. The meta `CLAUDE.md` release rule now also runs a mechanical `ls skills/` ↔ README skill-list drift check.
- **Generated `CLAUDE.md.tpl` git workflow** — replaced the dogmatic *"feature branch for non-trivial changes"* with a **neutral, fillable branching note** (trunk-based vs. feature-branch + PR, "pick one"), consistent with *handoff-not-gospel* and *no opinionated config*. The meta `CLAUDE.md` now also **states the dogfood's own model** (trunk-based on `main`), removing the template-vs-practice inconsistency. Lean template unchanged (git is deferred to the global CLAUDE.md there).

- **New `docs/ROADMAP.md`** (dogfood) — long-term milestones distinct from `PLAN.md`'s "now": **M1 loop-readiness** (loop scaffolding opt-in in bootstrap/adopt, `/groundrules:realize`, triage convention) and **M2 multi-harness support**. Multi-harness moved here out of `PLAN.md` to avoid duplication.

### Decisions
- ADR `0026-posture-and-per-feature-prd.md` — the two additions, the superpowers-aware deferral, and why the reversibility *tooling* (deny-list / PreToolUse hook) is a pointer, not generated (ADR 0025 consistency).
- ADR `0028-git-workflow-conventions.md` — git practices for the repo: **neutral branching** (trunk-based dogfood), **boundary commits** (completed chunks + Conventional Commits + tag at release, not a mega-commit per release nor per-trivial-change; message references the CHANGELOG), and **AI attribution by default deferring to any forbidding rule** (global CLAUDE.md / `policies.noAiAttribution`, à la ADR 0011). No history rewrite. Consolidates the 3 git-workflow points incl. point 1 (branching), previously only in templates/CHANGELOG.
- ADR `0027-reflection-realization-interactive-loop.md` — the working-method + product model: **reflection vs realization** phases; the reflection doc as a **method-agnostic contract** consumed by an **interactive _or_ loop** realization regime; the **bidirectional frontier** crossed on purpose (plan mode = native enforcement on the interactive side; a loop hitting a decision re-enters reflection); **PRD (build) vs ADR (decision)** both as reflection outputs; the **"could-act ≠ cleared-to-act" guard** as the back pressure of reflection (and inside a loop's verifier). Sets **loop-readiness** as a product direction (ADR 0025-consistent: no runtime hook; convention + on-demand skill), implementation deferred to PRDs. Validates the 2026-06-13 AGENT-EVALS guard entry.
- Plugin version bumped 1.3.3 → 1.4.0 across manifests, signatures (71 files), and `.groundrules.json` (+ migration entry). First release under the **boundary-commit** convention (ADR 0028): the work shipped as 9 thematic commits with consistent `Co-Authored-By` attribution.

## [1.3.3]

### Decisions
- ADR `0025-no-runtime-hook-no-watch.md` — closed two long-standing backlog ideas as **won't-do**: the PreToolUse `{{KEY}}` hook (runtime machinery against "template over code"; verify-bootstrap covers it) and `/watch-bootstrap` (niche). `docs/best-practices-pending.md` queue is now empty.
- Plugin version bumped 1.3.2 → 1.3.3 across manifests, signatures, and `.groundrules.json` (+ migration entry).

### Fixed
- **`verify-bootstrap` false-positive on `.gitignore`** — the signature check exempted only JSON, but `.gitignore` (generated from the plain `gitignore.minimal`, no HTML-comment signature) IS in a real project's `generatedFiles`, so every freshly-bootstrapped project got a spurious "signature missing". Now exempted, with the rule generalized to non-Markdown plain files. Caught by the **first fresh-project E2E** (the dogfood couldn't reveal it — its `.gitignore` is a foreign/skipped file).

### Changed
- **`verify-bootstrap` placeholder check sharpened** — the "leftover placeholder" rule is now explicit: a placeholder **in backticks** (`` `{{KEY}}` ``) is a documentation reference and is ignored; only a **bare** occurrence is a real unsubstituted placeholder. Avoids false positives on self-referential projects whose own `CHANGELOG.md`/`PLAN.md` mention groundrules placeholders by name. Surfaced by running the E2E on the dogfood (15/15 coherent).

## [1.3.2]

### Changed
- README: added a **"What it buys you"** benefits summary under the *Why* section (sharper agents, knowledge that survives, lower token cost, no lock-in, docs that don't rot).
- Plugin version bumped 1.3.1 → 1.3.2 across manifests, signatures, and `.groundrules.json` (+ migration entry).

## [1.3.1]

### Changed
- **README "Updating the plugin" hardened** — the two-step update is now explicit (refresh the marketplace catalog **then reinstall the plugin**; `marketplace update` alone does **not** update the installed plugin), with a "check your installed version" tip (`ls ~/.claude/plugins/cache/…`) and the new-skill-needs-a-full-restart note. The Phase 0 update notices in `bootstrap`/`adopt`/`migrate` got the same clarification.

### Fixed
- `adopt`: stale `Starter-kit role` table header → `groundrules role` (rename leftover).

### Dogfood
- Captured the "marketplace update ≠ plugin update" trap that kept the maintainer on plugin 1.1.0 across two releases: a `docs/LEARNINGS.md` rule + a `docs/AGENT-EVALS.md` recurrence entry ("just restart" advised without verifying the installed version).
- Plugin version bumped 1.3.0 → 1.3.1 across manifests, signatures, and `.groundrules.json` (+ migration entry).

## [1.3.0]

### Added
- **New skill `/groundrules:slim`** — analyzes `CLAUDE.md` and proposes concrete optimizations to stay under the ~200-line budget (extract a bulky section to `docs/`, move file-type rules to `.claude/rules/` with `paths:`, de-duplicate, compress), **moving** content never deleting it. `verify-bootstrap`'s size warning now points to it. The generated `CLAUDE.md` is left untouched (no bloat). See ADR 0024.
- **Team-portability guidance** — `bootstrap` (Phase 8) and `adopt` (Phase 6) now suggest installing groundrules at **Project scope** (committed to `.claude/settings.json`, so collaborators are prompted to install on clone), only when not already done and never blocking. README Installation documents it. The generated `CLAUDE.md` is left untouched (no bloat — the advice lives in the skills' one-time output). See ADR 0023.

### Decisions
- ADR `0023-project-scope-for-team-portability.md` — why project-scope install (not CLAUDE.md manual-fallback prose, not vendoring skills into the repo).
- ADR `0024-slim-skill-claude-md-budget.md` — a dedicated skill (not extending verify, not a CLAUDE.md pointer) to operationalize the 200-line budget.

### Changed
- Plugin version bumped 1.2.0 → 1.3.0 across `plugin.json`, `marketplace.json`, all template/doc signatures, and `.groundrules.json` (`groundrulesVersion` + new migration entry).

## [1.2.0]

### Added
- **New skill `/groundrules:checkpoint`** — runs the capture ritual on demand (the manual complement to the agent's proactive trigger): gathers what changed since the last tag, then routes *decided* → ADR, *learned*/*blocked* → `LEARNINGS`, *agent drift* → `AGENT-EVALS` (offers to create it if absent). Described in the README ("Capturing knowledge as you go"). See ADR 0022.
- **Checkpoint-capture ritual** in the generated `CLAUDE.md` (full + lean): the agent proactively proposes a 3-question capture (*decided* → `add-adr`, *learned* / 30+ min blocker → `learn`, *agent mistake/hallucination/drift* → `AGENT-EVALS.md`) at boundaries it can perceive — **before a `git push`/tag/release** (also wired into the `RELEASE.md` pre-release checklist) or a completed `PLAN.md` milestone. Anchored to those events because an agent can't perceive "session end". See ADR 0022.
- **`docs/AGENT-EVALS.md`** — a new optional doc (placeholder `{{HAS_AGENT_EVALS}}`, wired into bootstrap Call 2b + adopt Call 3b + verify whitelist): a log of the agent's **own** failure modes on the project (mistakes, hallucinations, drifts) + the guard added. Distinct from `LEARNINGS.md`. Harvested (with the ritual) from an agent-memory article — its `journal.md`, `.claude/memory/` location and `@import` auto-load were deliberately *not* adopted (ADRs 0020, 0021). See ADR 0022.
- **`docs/CONTEXT-ECONOMY.md`** — a guide settling the "index vs documentation-search plugin" debate and "is too much context counterproductive?": separate *storage* (exhaustive, on disk) from *loading* (minimal, on-demand); an index + native `Read` wins for a project's own docs, doc-search/RAG is for large external corpora only; backed by the 2025 context-rot / lost-in-the-middle findings + Anthropic's < 200-line guidance. See ADR 0021.
- **"Map, not the territory" note** in the generated `CLAUDE.md` templates (full + lean): keep the always-loaded file an index, read docs on demand, don't paste content "to be safe"; doc-search tools are for external corpora.

### Changed
- **Interop pointer for graph/RAG tools** — `docs/CONTEXT-ECONOMY.md` now names the external-corpus tool class (doc-search MCP, GraphRAG/knowledge-graph tools such as [graphify](https://github.com/safishamsi/graphify)) for the case it covers, and `adopt` gains an **optional, dependency-free hint** to suggest such a tool when scanning a large unfamiliar codebase (upstream comprehension only — no graphify dependency, no generated artifact).
- README: new **"Why"** section after the hook — the method's justification grounded in the context-rot / lost-in-the-middle research and Anthropic's own < 200-line guidance, linking to `docs/CONTEXT-ECONOMY.md`.
- **README restructured** (pitch-before-install, inspired by obra/superpowers): new narrative **"How it works"** before installation, a numbered lifecycle **"The workflow"**, a **"Philosophy"** section surfacing the principles from the ADRs, and a short **"Contributing"** section.
- **License: MIT** — added `LICENSE` file + `license` field in `plugin.json` (was "To be defined").
- `plugin.json`: dropped the "Formerly starter-kit" tail from the description (no external users to transition).
- README: "Generated files" section restructured — a "folders" table explaining `intake/` → `docs/` → `docs/decisions/` + `docs/media/` and the flow between them, then a single unified file table (the three tables merged; "Condition" and "When to check it" merged into one "When created" column).
- README: removed all legacy `starter-kit` transition messaging ("formerly" banner, old marketplace names note, roadmap phrasing) — the plugin had no external users before the rename, so there is no one to transition.
- Dogfood: local folder and project name aligned on **groundrules** (was `Starting-Claude`) — doc titles, `.groundrules.json` `projectName`, meta CLAUDE.md paths. Historical ADRs untouched.
- Memory hygiene (ADR 0020 applied to ourselves): machine-local project memories reduced to a single cross-project pointer — everything else was already recorded in the repo.
- Plugin version bumped 1.1.0 → 1.2.0 across `plugin.json`, `marketplace.json`, all template/doc signatures, and `.groundrules.json` (`groundrulesVersion` + new migration entry).

### Fixed
- **`/groundrules:learn` produced the old `Context/Lesson` format** while the `LEARNINGS.md` template moved to the rule format (*Why* + *When to apply*) back in ADR 0019 — the skill was never updated. Now aligned: it collects Title / Why / When to apply and inserts a rule-format entry (date inside *Why*, not the title).

### Dogfood
- groundrules now runs its own checkpoint-capture ritual: added `docs/AGENT-EVALS.md` (first entry: "asserts/trusts without verifying") and a `docs/LEARNINGS.md` rule ("anchor agent rituals to observable events, never to session end") — captured before this push, as the ritual prescribes.

### Decisions
- ADR `0021-context-economy-index-over-doc-search.md` — why groundrules generates an index + on-demand reads rather than a doc-search/RAG layer for a project's own docs.
- ADR `0022-agent-evals-and-session-close.md` — the two ideas adopted from an agent-memory article (session-close ritual, agent-evals log) and the three mechanics rejected (`journal.md`, `.claude/memory/` location, `@import` auto-load).

## [1.1.0]

### Added
- **`adopt` adoption strategy**: new Call-1 question — `Map in place` (default, previous behavior: duplicates tolerated and documented) or **`Consolidate`** (new Phase 4b: migrate role-mapped files to the canonical paths via `git mv`/merge, per-file confirmation, optional reformat to template structure, internal-reference sweep). `.groundrules.json` gains `adoptionMode` + `migratedFiles`. See ADR 0018.
- **Two new optional docs** (bootstrap Call 2b + adopt Call 3b, placeholders `{{HAS_PROCESS}}`/`{{HAS_RELEASE}}`): `docs/PROCESS.md` (working-method contract: phases, validation gates, interview style) and `RELEASE.md` (operational runbook: environments, commands, checklist, rollback, fragilities — offered only when the project deploys). See ADR 0019.
- **"The repo is the only memory" convention** in the generated `CLAUDE.md` (full + lean): all project knowledge lives in the repo docs — never in machine-local agent memory/plans; no `~/.claude/*` references in repo docs; plan files worth keeping get copied in. Born from repatriating crm-heyjoe's external memories. See ADR 0020.

### Changed
- **`LEARNINGS.md` template reworked**: entries are now actionable **rules** with *Why* (story + cost) and *When to apply* (triggers), instead of journal notes (Context/Lesson). Harvested from a real project. See ADR 0019.
- **`CLAUDE.md` templates** (full + lean): new **"Session start — read first, in order"** section (PLAN → LEARNINGS → VISION → in-progress artifacts).
- `PLAN.md` template: status vocabulary (`[~]` delivered/in review; annotate reverts and key commits).
- `intake/` README: explicit **read-only** convention + binaries welcome.
- Plugin version bumped 1.0.0 → 1.1.0 across `plugin.json`, `marketplace.json`, all template/doc signatures, and `.groundrules.json` (`groundrulesVersion` + new migration entry).

### Decisions
- ADR `0018-adopt-consolidation-mode.md` — adoption strategies rationale.
- ADR `0019-heyjoe-inspired-doc-improvements.md` — what was harvested from crm-heyjoe and what was deliberately not.
- ADR `0020-repo-is-the-only-memory.md` — why agent-local project knowledge is forbidden.

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
