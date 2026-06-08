<!-- generated-by: groundrules v1.3.2 -->
# Learnings — groundrules

Non-trivial learnings that emerged during the project. Reverse-chronological order (newest at the top).

One entry per learning. Keep the format simple: title, context, lesson.

---

## Updating a Claude Code plugin is two steps — marketplace update ≠ plugin update

**Why**: 2026-06-08, the maintainer ran `/plugin marketplace update claude-code-groundrules` after each release and restarted — but stayed stuck on plugin **1.1.0 across two releases** (1.2.0, 1.3.0). `marketplace update` refreshes only the *catalog* (`~/.claude/plugins/marketplaces/…`); the *installed* plugin (`~/.claude/plugins/cache/…/<version>/`) is unchanged until you explicitly reinstall/update it. So `/groundrules:checkpoint` and `/groundrules:slim` never appeared, and a restart just reloaded the old version.

**When to apply**: shipping or advising any plugin update — it's **two steps**: (1) `/plugin marketplace update <marketplace>`, then (2) `/plugin install <plugin>@<marketplace>` (or `/plugin` → Update). And a **new skill** (new directory) needs a **full restart**, not just `/reload-plugins`. To diagnose "command missing", check the *installed* version on disk: `ls ~/.claude/plugins/cache/<marketplace>/<plugin>/`. Enabling marketplace auto-update avoids the trap. Captured in the README "Updating the plugin" section + the skills' Phase 0 notices.

## When a template/format changes, sweep the skills that read or write it

**Why**: 2026-06-08, the `LEARNINGS.md` template moved to the rule format (*Why* + *When to apply*) in ADR 0019, but `skills/learn/SKILL.md` kept emitting the old `Context/Lesson` shape — the coupling was missed for two releases, so `/groundrules:learn` silently produced stale-format entries until caught while building `/groundrules:checkpoint`.

**When to apply**: whenever you change a template, a file format, a placeholder, or a `.groundrules.json` field — immediately `grep` for every skill and doc that *produces or consumes* it (here: any skill that writes `docs/LEARNINGS.md`). A format lives in more than one place: the template **and** the skills that fill it. Bump them together.

## Anchor agent rituals to observable events, never to "session end"

**Why**: 2026-06-08, the agent-evals work shipped a "session close" ritual as a passive
`CLAUDE.md` instruction ("before ending a session, capture…") and called it a *forcing
function*. The user pointed out it would never fire: an agent **cannot perceive that a
session is ending** (no model-visible signal; `CLAUDE.md` loads at *start* only; `SessionEnd`
hooks fire too late and can't drive an agent turn). A "forcing function" with no perceivable
trigger forces nothing — it just reads well in the file.

**When to apply**: when designing any agent convention/ritual, anchor it to a **boundary the
agent actually flows through and can act on** — a tool call it's about to make (`git push`,
tag, release), a completed `PLAN.md` milestone — not to an unobservable lifecycle moment.
The fix here: re-anchored capture to "before a push/release", wired concretely into the
`RELEASE.md` pre-release checklist (cf. ADR 0022). Rule of thumb: if the trigger isn't a
thing the agent *does* or *reads*, it won't happen.

## Reference sweeps must exclude historical records

**Why**: during the crm-heyjoe `tasks/` → `docs/specs/` rename (2026-06-07), a blind `tasks/ → docs/specs/` sweep across all Markdown rewrote a **past CHANGELOG entry** — it then claimed the consolidation had moved `docs/specs/todo.md` → `PLAN.md`, a path that never existed at that time. History was falsified silently; caught only by re-reading the diff.

**When to apply**: any bulk path-rename sweep (adopt consolidate, migrate renames, manual refactors). Exclude or hand-review: past CHANGELOG entries, `migrations`/`migratedFiles` records, dated ADRs and logs — they describe old paths *truthfully*. Sweep only living references (current docs, code, configs). The adopt SKILL Phase 4b now carries this guard.


## 2026-06-03 — Ecosystem interop: compare by altitude, not by name

**Context**: Asked whether starter-kit's `PLAN.md` / `docs/VISION.md` duplicate superpowers' `docs/superpowers/plans/` and `specs/`. Both have "plan" and "design/vision" artifacts, so on names they look like duplicates.
**Lesson**: When checking overlap between two tools, compare **altitude (project vs feature) and lifecycle (durable/hand-curated vs volatile/agent-generated)**, not just the noun. starter-kit = durable project memory (the *why*); superpowers = per-feature working docs of a TDD loop (the *how*). The only real friction was `PLAN.md` (one rolling "now" view) vs per-feature plan files — resolved by *referencing* not *duplicating*. Default to documenting the division of labor (a conditional note in the CLAUDE.md template) rather than changing behavior — cheaper and doesn't presume the other tool is present.

## 2026-05-11 — Verify-bootstrap regex must be whitelist, not catch-all

**Context**: First E2E run of `/starter-kit:verify-bootstrap` on the dogfood (V0.6). Initial regex `\{\{[A-Z_]+\}\}` flagged 4 files as having "unsubstituted placeholders" — but they were all *documentation* references like `` `{{KEY}}` `` in backticks (PLAN.md mentioning a future hook, CHANGELOG describing the feature, etc.).
**Lesson**: When validating a templating output, use a **whitelist of real placeholder names** (`PROJECT_NAME`, `DESCRIPTION`, `LANG`, etc.), not a catch-all pattern. Documentation about placeholders is a normal occurrence in a self-aware project; the validator must distinguish "documentation of `{{KEY}}` as a concept" from "actual `{{KEY}}` that should have been substituted."

## 2026-05-11 — YAML frontmatter forces signature placement after closing `---`

**Context**: Same E2E run. `.claude/rules/plugin-meta.md` was flagged as "signature absente" even though it had the right signature — but on line 7, after the YAML frontmatter (`---\npaths:\n  - "..."\n---`). The verify-bootstrap script only scanned `head -6`.
**Lesson**: Rules, skills, and any file requiring YAML frontmatter at line 1 **cannot** carry an HTML signature on line 1. Convention: place the signature on the line **immediately after the closing `---`**, and the validator must scan at least the first **10 lines** to find it. Generators (e.g., `apply-best-practices` creating `.claude/rules/*.md`) must follow the same convention.

<!-- Example:

## YYYY-MM-DD — Short title

**Context**: what we were doing.
**Lesson**: what we learned, and how to apply it next time.

-->
