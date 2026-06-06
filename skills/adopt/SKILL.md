---
name: adopt
description: Adopt an existing (brownfield) project into groundrules — scan, map the existing files to groundrules roles, capture intent from existing docs, generate only what's missing, backfill .groundrules.json. Never overwrites.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion
---

# /groundrules:adopt

You will bring an **existing project** (already has code, docs, a git repo) under groundrules management, **without breaking anything**. Different from `bootstrap` (from-scratch) and `migrate` (updating an already-managed project). All generated files are in **English** (the plugin is English-only).

If `$ARGUMENTS` contains `--dry-run` (or `dry-run`): run all analysis phases but **write no file**; end with a "would have done" report.

## Phase 0 — Guardrails

1. If `.groundrules.json` (or a legacy pre-1.0 `.starter-kit.json`) exists in the cwd → *"This project is already managed by groundrules. Use `/groundrules:migrate` to update it."* Stop.
2. If the folder is **empty** (excluding `.git`) → *"Empty folder: use `/groundrules:bootstrap`."* Stop.
3. Otherwise → this is indeed a brownfield case, continue.
4. **Plugin update check (best-effort, never blocking)**: read `version` from `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json` → INSTALLED, then run via Bash with a **short timeout (~3s)** `git ls-remote --tags --refs --sort=-v:refname https://github.com/lozit/groundrules.git 'v*' | head -1`. If the latest tag is semver-greater than INSTALLED, show an informational note: *"📦 groundrules vX.Y.Z is available (installed: vINSTALLED). To update: `/plugin marketplace update claude-code-groundrules`, then `/plugin` + `/reload-plugins`."* **Fail silent** on timeout / no network / any error — this is the only network access in this skill and it is best-effort (cf. ADR 0015).

## Phase 1 — Scan & classification (role mapping)

1. `ls -la` + stack detection: `package.json` (Node/Nuxt/Vite…), `pyproject.toml`/`requirements.txt`, `Cargo.toml`, `go.mod`, etc. Also note: `.git/` + `git remote -v` (GitHub/GitLab), `.env`/`.env.*` (secrets), `i18n/`/`locales/` (multilingual), a data ORM/SDK (Prisma, Supabase, Drizzle…), a UI folder (`components/`, `app.vue`…).
   - **Global / enterprise CLAUDE.md**: `~/.claude/CLAUDE.md` + managed policy (`/Library/Application Support/ClaudeCode/CLAUDE.md` macOS, `/etc/claude-code/CLAUDE.md` Linux). If present → `HAS_GLOBAL_CLAUDE=true` (never overwrite it). Very common in enterprise contexts — precisely where the project CLAUDE.md must **defer**.
   - **AI attribution policy**: **read-only**, look in the detected CLAUDE.md files (project + global) for a rule forbidding AI attribution (`no AI attribution`, `Co-Authored-By`, `Generated with Claude`…). If found → `NO_AI_ATTRIBUTION=true`. Common in enterprise (some managed CLAUDE.md files forbid it explicitly).
2. **Detect superpowers**: presence of `docs/superpowers/plans/` or `specs/`. If so → different altitude, **do not** treat as root planning (see interop in the `CLAUDE.md` template).
3. **Detect `PLAN.md` equivalents** (see "Planning detection" below) — there may be **several**, possibly nested.
4. **Classify each existing item** into a groundrules role. Build a table:

| Existing | Starter-kit role | Proposed action |
|---|---|---|
| `README.md` | README | adopt as-is; if **boilerplate** (GitHub/GitLab "Getting started…" template) → offer to regenerate |
| `plan.md` / `TODO.md` / … | PLAN (active view) | reconciliation (Phase 2) — **never** create a `PLAN.md` that collides in case |
| `docs/**/todos.md` | backlog | adopt; document the role in `CLAUDE.md` |
| business doc (`*business-rules*`, `CR-*`, specs…) | intent source | offer as source for `intake/INTENT.md` / `docs/VISION.md` |
| `docs/superpowers/**` | per-feature artifacts | don't touch; note the interop |
| `docs/ARCHITECTURE.md`, `GLOSSARY.md`… already present | project doc | adopt as-is (don't regenerate) |
| `CLAUDE.md` present? | instructions | **absent** → to generate (see Call 3); **present** → never overwrite, see "CLAUDE.md project file already present" |

### CLAUDE.md project file already present (often tool-managed)

If a `CLAUDE.md` already exists at the root (without a groundrules/starter-kit signature):

1. **Never generate or overwrite it.** There can't be two CLAUDE.md; theirs is authoritative.
2. **Detect whether it's tool-managed**: look for markers like `Auto-managed`, `Do not edit`, an enterprise manager name (e.g. `claude-manager`), managed-section fences, or an explicit **free zone** (marker like `END MANAGED` / `below this line is yours` / a `## Project-Specific Notes` heading).
3. **Discoverability pointer (opt-in)**: if a free zone is detected, offer (`AskUserQuestion`) to **append** (via `Edit`, append only) a short pointer to the groundrules docs, so Claude finds them. **NEVER write into the managed sections.** Suggested content:

   ```
   ### Project docs (groundrules)
   - Vision: `docs/VISION.md` · Decisions: `docs/decisions/` · Learnings: `docs/LEARNINGS.md` · Active plan: `PLAN.md`
   ```

4. If **no** free zone is detected (fully managed file with no editable section) → **skip** (write nothing), and report it in the recap.
5. Record in `.groundrules.json` `adoptedFiles["CLAUDE.md"] = "instructions (managed by <tool if known>)"`.

> In a heavily-managed context (the CLAUDE.md already covers commits, security, CHANGELOG, stack…), groundrules' value concentrates on `docs/` (VISION, decisions, LEARNINGS, intake) and `PLAN.md` — not the CLAUDE.md. Don't reintroduce duplicates. **Surface any conflict** spotted between a managed-CLAUDE.md rule and a groundrules convention (e.g. commit attribution), without resolving it yourself.

### Planning detection (broadened)

Search, excluding `node_modules`/`.git`, **case-insensitive**, up to ~3 levels deep:

```bash
find . -path ./node_modules -prune -o -path ./.git -prune -o \
  \( -iname 'plan.md' -o -iname 'todo.md' -o -iname 'todos.md' \
     -o -iname 'tasks.md' -o -iname 'backlog.md' \) -maxdepth 3 -print
```

- Report **all** results (not just the first).
- **Case guard**: **never** generate `PLAN.md` if an equivalent name exists in a different case (e.g. `plan.md`). On a case-sensitive FS (Linux/CI) this would create two files `plan.md`/`PLAN.md` → collision on checkout on macOS/Windows.

## Phase 2 — Brownfield interview (grouped questions, 4 max/call)

### Call 1 — Base
- **Confirm the project name** (suggest the `name` from `package.json` or the folder).

### Call 2 — Intent
*"Which source for the project vision?"* — offer the **detected business docs** first:
- `Use <detected doc>` (e.g. `CR-business-rules.md`) → `Read` then synthesize into `docs/VISION.md` (and copy the source into `intake/INTENT.md`).
- `I'll paste the content` / `Another file (path)` / `Ask me the questions` / `Skip`.

Reuse `bootstrap`'s intent logic (Phase 3) for the synthesis.

### Call 3a — Core docs to generate (multiSelect, missing only)
Pre-check based on the scan. Only offer what **doesn't already exist**:
- `CLAUDE.md` **only if absent** (if it already exists → see "CLAUDE.md project file already present", no generation). If absent and **`HAS_GLOBAL_CLAUDE=true`**: default to the **lean** variant (`CLAUDE.lean.md.tpl`) that complements the global without restating it; otherwise the full variant. Same logic as `bootstrap` Phase 5 "CLAUDE.md template selection" (placeholder `{{GLOBAL_CLAUDE_NOTE}}`).
- `docs/decisions/` (ADR) + `docs/LEARNINGS.md`
- `intake/` + `docs/media/` (explanatory READMEs)

### Call 3b — Optional / specialized docs (multiSelect — ALWAYS ask)

**This question is mandatory and must always be asked** (unless every option already exists on disk). Present a multiSelect listing **all** optional docs below — never silently skip it, and never gate the *list* on detection. Detection only decides what's **pre-checked**; every not-yet-existing option is still offered so the user can pick any of them.

- `docs/ARCHITECTURE.md` — pre-check if a code project
- `docs/GLOSSARY.md` — pre-check if domain jargon detected
- `CHANGELOG.md` — pre-check if releases/versioning detected (or a standard requires it)
- `docs/DATA_MODEL.md` — pre-check if an ORM/SDK/DB is detected
- `docs/SECURITY.md` — pre-check if `.env`/secrets/external APIs detected
- `docs/DESIGN_SYSTEM.md` — pre-check if a UI is detected
- `docs/I18N.md` — pre-check if i18n/locales detected
- `docs/ROADMAP.md` — offered (unchecked by default)

Skip an individual option only if that exact file already exists (then list it under "adopted", not here). If **none** of these exist yet, the full list is shown with the detected ones pre-checked.

### Call 4 — Planning reconciliation (if equivalents detected)
If **one or more** equivalents found:
- **Adopt the existing one** → no `PLAN.md`; record the file(s) with the PLAN role in `.groundrules.json`.
- **Generate `PLAN.md` separately** → only if **no** case collision; the user accepts the coexistence.
- **Consolidate** → carry the existing tasks into the file chosen as canonical; suggest (without doing it) deleting the duplicates.
If several equivalents: clarify their roles (e.g. `plan.md` = active view, `docs/gtd/todos.md` = backlog) and document them in `CLAUDE.md`. If superpowers present: `PLAN.md`/`plan.md` should **point to** the active superpowers plan.

## Phase 3 — Recap & confirmation

Show, in clear text:
- 🆕 Files that will be **created** (missing)
- 🔗 Files **adopted** (existing, mapped to a role, unmodified)
- ⏭️ Files **left as-is** (foreign, unmapped)
- ❗ Warnings (case collision avoided, README boilerplate, fragmented planning)

Then `AskUserQuestion`: `Confirm` / `Cancel`. (In `--dry-run`, stop here with the report.)

## Phase 4 — Generation (missing only)

For each file to create: same mechanics as `bootstrap` Phase 5 (read the template `${CLAUDE_PLUGIN_ROOT}/skills/bootstrap/templates/<tpl>`, substitute `{{KEY}}`, `Write`). **Never overwrite** an existing file; **never delete**.

## Phase 5 — Backfill `.groundrules.json`

Write `.groundrules.json` (bootstrap schema, see ADR 0004) with the adoption markers:

```json
{
  "groundrulesVersion": "<current version>",
  "adopted": true,
  "adoptedAt": "YYYY-MM-DD",
  "bootstrappedWithVersion": null,
  "migrations": [],
  "answers": { ... interview ... },
  "intent": { "source": "file|paste|interview|skipped", ... },
  "appliedPractices": [],
  "policies": { "noAiAttribution": true | false },
  "generatedFiles": [ ... files CREATED by adopt ... ],
  "adoptedFiles": { "<path>": "<role: README|PLAN|backlog|intent-source|...>" },
  "skippedFiles": { "<path>": "<reason>" }
}
```

`adopted: true` + `bootstrappedWithVersion: null` distinguish an adopted project from a bootstrapped one. `adoptedFiles` maps the existing files to roles (info for `migrate`/`verify-bootstrap`).

## Phase 6 — Final recap

- ✅ Created / 🔗 Adopted / ⏭️ Left as-is
- 📋 Next steps:
  1. Flesh out `CLAUDE.md` (Setup/Build/Test from the project scripts, stack, gotchas)
  2. If intent captured: `/groundrules:apply-best-practices`
  3. Re-read `docs/VISION.md`; amend if the synthesis missed something
  4. Decide the fate of fragmented planning (consolidate if relevant)
  5. Commit when ready — **if `NO_AI_ATTRIBUTION=true`**, the commit message must contain **no** AI attribution marker (`Co-Authored-By`, "Generated with Claude Code"…), even if a default agent guideline would add it. adopt **does not commit** itself; it only provides a compliant suggested message.

**No `git init`** (the project already has git) nor remote creation. If `.git/` is absent: report it and suggest `git init`, without imposing it.

## Important rules

- **Never overwrite or delete** without explicit action (and even then, adopt does not delete — it suggests).
- **Case guard**: never create a file that collides in case with an existing one.
- **superpowers**: `docs/superpowers/**` is not root planning — different altitude, don't touch it.
- **Faithfulness to the source** for intent synthesis: don't invent; "To be defined" if the source is thin.
- `--dry-run`: no writes, just the report.
- **Never commit automatically.**
