---
name: bootstrap
description: Interactive bootstrap of a new Claude Code project — interview, project intent, docs/ structure, git init, optional remote.
disable-model-invocation: true
allowed-tools: Read, Write, Bash, AskUserQuestion
---

# /starter-kit:bootstrap

You will bootstrap a Claude Code project in the **current working directory**. Follow these phases in order, without skipping any. All generated files are in **English** (the plugin is English-only).

## Phase 0 — Plugin update check (best-effort, never blocking)

1. Read `version` from `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json` → INSTALLED.
2. Run via Bash with a **short timeout (~3s)**: `git ls-remote --tags --refs --sort=-v:refname https://github.com/lozit/claude-code-starter-kit.git 'v*' | head -1`
3. Extract the tag (`refs/tags/vX.Y.Z`). If semver-greater than INSTALLED, show an informational note (don't ask, don't stop):
   > 📦 starter-kit vX.Y.Z is available (installed: vINSTALLED). To update: `/plugin marketplace update claude-code-starter-kit`, then update the plugin via `/plugin` and `/reload-plugins`.
4. **Fail silent**: on timeout, no network, or any error, continue without mentioning the check. This is the only network access in this skill and it is best-effort (cf. ADR 0015).

## Phase 1 — Scan the folder

1. Run `ls -la` on the cwd.
2. Detect the following markers and note what is present:
   - `.git/` (existing git repo)
   - `.starter-kit.json` (state from a previous invocation — if present, load it and switch to **resume mode**)
   - `CLAUDE.md`, `README.md`, `docs/`, `intake/`, `docs/media/`, `PLAN.md`, `CHANGELOG.md`, `.gitignore`, `docs/VISION.md`, `intake/INTENT.md`
   - optional specialized docs: `docs/DATA_MODEL.md`, `docs/SECURITY.md`, `docs/DESIGN_SYSTEM.md`, `docs/ROADMAP.md`, `docs/I18N.md`
   - **`PLAN.md` equivalents** (planning aliases, **same altitude**) — detection is **case-insensitive** and **nested** (up to ~3 levels, excluding `node_modules`/`.git`): `plan.md`, `TODO.md`, `todo.md`, `todos.md`, `TASKS.md`, `BACKLOG.md`, including under a path (e.g. `docs/gtd/todos.md`). There may be **several** — report all of them. **Case guard**: **never** generate `PLAN.md` if an equivalent name exists in a different case (collision on a case-sensitive FS).
   - `docs/superpowers/plans/` (superpowers **per-feature** plans — **different altitude**, *not* a `PLAN.md` alias)
   - **Global / enterprise CLAUDE.md** (loaded **in addition to** the project CLAUDE.md — NEVER overwrite it): `~/.claude/CLAUDE.md`, and the managed policy if present (`/Library/Application Support/ClaudeCode/CLAUDE.md` on macOS, `/etc/claude-code/CLAUDE.md` on Linux). If at least one exists → `HAS_GLOBAL_CLAUDE=true`.
   - **AI attribution policy**: read (**read-only**) the detected CLAUDE.md files (project + global) for a rule **forbidding** AI attribution — patterns (case-insensitive): `no AI attribution`, `Co-Authored-By`, `Generated with Claude`, `do not add ... attribution`. If found → `NO_AI_ATTRIBUTION=true`. (Read-only: never modify these files.)
   - `package.json` (→ Node stack), `pyproject.toml`/`requirements.txt` (→ Python), `Cargo.toml` (→ Rust), `go.mod` (→ Go)
3. For each file you might create, classify it:
   - **Absent** → to create
   - **Present with a `<!-- generated-by: starter-kit -->` signature at the top** → recognized, offer "ignore / regenerate"
   - **Present without a signature** → foreign file, default "ignore"

If the folder is completely empty → classic bootstrap mode. Otherwise → resume mode (announce it clearly to the user at the start of the interview).

## Phase 2 — Base interview

Group questions by theme via `AskUserQuestion` (max 4 questions per call for good UX).

### Call 1 — Project identity
- **Project name**: use the folder name as the default suggestion, ask for confirmation. (1 question)
- **Short description** (1 sentence — the detailed intent is captured in phase 3) (1 question)
- **Project type**: `Code (app, lib, CLI...)` / `Non-code (docs, research, notes...)` (1 question)

### Call 2 — Stack and docs (if code)
If a code project:
- **Main stack**: pre-fill with what you detected (Node, Python, etc.), offer `Other`, `None in particular` (1 question)
- **`docs/ARCHITECTURE.md`**: Yes (recommended for a code project) / No (1 question)
- **`docs/GLOSSARY.md`**: `Yes, domain jargon` / `No` (1 question)
- **`CHANGELOG.md` (Keep-a-Changelog)**: `Yes, versioned releases planned` / `No` (1 question)

If non-code, only ask the last two (GLOSSARY, CHANGELOG).

### Call 2b — Specialized docs (optional, if code)

A single **multiSelect** `AskUserQuestion`: *"Which specialized docs do you want to generate? (all optional, you can check none)"*

- **`docs/DATA_MODEL.md`** — entities, relationships, access rules. Check if the project has a database.
- **`docs/SECURITY.md`** — auth, access control, personal data & GDPR. Check if sensitive data.
- **`docs/DESIGN_SYSTEM.md`** — colors, typography, components. Check if the project has a UI.
- **`docs/I18N.md`** — multilingual strategy. Check if the project is multilingual.
- **`docs/ROADMAP.md`** — long-term milestone breakdown (distinct from `PLAN.md`).

Adapt suggestions to context: if the stack/intent suggests a UI, pre-suggest `DESIGN_SYSTEM`; a DB → `DATA_MODEL`; etc. Impose nothing: no check = no file.

Only ask this call for a code project. For a non-code project, only `ROADMAP` may make sense — offer it on its own if relevant.

### Call 3 — Steering and git
- **`PLAN.md` at the root** (active todo maintained by Claude): `Yes (recommended)` / `No` (1 question)
- **Git remote**: `GitHub` / `GitLab` / `None for now` (1 question)
- If remote ≠ "None":
  - **Visibility**: `Private (recommended)` / `Public` (1 question)

#### Reconciliation if a `PLAN.md` equivalent already exists

If Phase 1 detected a **planning alias** (`TODO.md`, `TASKS.md`, `BACKLOG.md`…), **do not ask** the standard yes/no `PLAN.md` question. Ask a reconciliation question instead:

- **Adopt the existing one** → do not create `PLAN.md`; `HAS_PLAN=false`. Record `skippedFiles["PLAN.md"] = "existing equivalent: <name>"` in `.starter-kit.json`.
- **Create `PLAN.md` alongside** → `HAS_PLAN=true`, create normally (the user accepts both files).
- **Port the content into `PLAN.md`** → `Read` the alias, create `PLAN.md` from the template carrying over the existing tasks (the "In progress" section), then suggest the user delete the alias. **Never** delete the alias automatically. **Case guard**: if the alias is a `plan.md` (same name, different case), do not create a second file — offer to adopt `plan.md` as-is instead.

If **several** equivalents are detected, list them all and clarify their respective roles (e.g. `plan.md` = active view, `docs/gtd/todos.md` = backlog) in the question. For a more complex project (brownfield, many existing docs), point to `/starter-kit:adopt`.

> **superpowers**: if only `docs/superpowers/plans/` is present (no root alias), it is **not** a `PLAN.md` equivalent (different altitude — see the interop note in the `CLAUDE.md` template). Keep the standard `PLAN.md` question, and note in the recap (Phase 4) that `PLAN.md` should **point to** the active superpowers plan rather than duplicate tasks.

## Phase 3 — Project intent

> Before generating project files, capture the intent (goal, users, constraints, non-goals, acceptance criteria). It is the basis for the `/starter-kit:apply-best-practices` skill which needs it.

`AskUserQuestion`: *"Do you already have a brief or a vision document for this project?"*
- `Yes, I'll paste it now`
- `Yes, it's in a file (path)`
- `No, ask me the questions`
- `Skip for now`

### If "I'll paste it now"

Ask the user to paste the content (can be long: multiple paragraphs accepted).

Save the raw brief:
1. Read `${CLAUDE_PLUGIN_ROOT}/skills/bootstrap/templates/intake-INTENT.md.tpl`
2. Substitute `{{PROJECT_NAME}}` and `{{CONTENT}}` (the brief as-is)
3. Write to `intake/INTENT.md`

Synthesize into a structured vision. Read the brief and extract:
- **Goal**: 1-3 sentences on what success looks like
- **Users**: who uses this
- **Constraints**: deadlines, budget, tech constraints, regulation
- **Non-goals**: what will NOT be done in V1
- **Acceptance criteria**: how we'll know it's done

If some points are ambiguous in the brief, ask **a single** grouped question to clarify the ambiguities.

### If "it's in a file"

Ask for the file path (absolute or relative to the cwd). `Read` that file then treat it like "I'll paste it": copy into `intake/INTENT.md` (via the template), synthesize into `docs/VISION.md`.

### If "No, ask me the questions"

Ask an `AskUserQuestion` with 4-5 questions:
- **Goal**: "What's the goal of the project? What does success look like?" (1-3 sentences)
- **Users / personas**: "Who will use this? (can be 'myself' if solo)"
- **Key constraints**: "What constraints (deadlines, budget, tech, regulation)?"
- **Non-goals**: "What will you **not** do in V1? (useful for scoping)"
- **V1 acceptance criteria**: "How will you know it's done?"

If a question is too broad, the user may answer "skip" or "to be defined later" — don't insist.

In this case, no `intake/INTENT.md` (the answers are already structured). Source = `interview`.

### Generating `docs/VISION.md`

In all cases (except a total Skip), read `${CLAUDE_PLUGIN_ROOT}/skills/bootstrap/templates/docs-VISION.md.tpl`. Substitute:
- `{{PROJECT_NAME}}`
- `{{INTENT_SOURCE}}` — `intake/INTENT.md (paste)` / `intake/INTENT.md (file <path>)` / `interview`
- `{{GOAL}}`, `{{USERS}}`, `{{CONSTRAINTS}}`, `{{NONGOALS}}`, `{{ACCEPTANCE}}` — synthesized text

Write to `docs/VISION.md`.

### If "Skip"

Create neither `intake/INTENT.md` nor `docs/VISION.md`. Note in `.starter-kit.json` that `intent.source = "skipped"`. `/starter-kit:apply-best-practices` will refuse until the vision is created.

## Phase 4 — Recap and confirmation

Show a clear text recap:
- List of files that will be **created** (full path)
- List of files that will be **ignored** (resume mode)
- Planned git actions (`git init`, first commit, remote)

Then a final `AskUserQuestion`: `Confirm and generate` / `Cancel`.

## Phase 5 — File generation

For each file to create:

1. Read the matching template in `${CLAUDE_PLUGIN_ROOT}/skills/bootstrap/templates/`.
2. Replace the `{{KEY}}` placeholders with the collected values. Available placeholders:
   - `{{PROJECT_NAME}}` — project name
   - `{{DESCRIPTION}}` — short description (1 sentence, distinct from the vision)
   - `{{STACK}}` — stack or empty string
   - `{{DATE}}` — today's date in ISO (YYYY-MM-DD)
   - `{{HAS_PLAN}}`, `{{HAS_ARCHITECTURE}}`, `{{HAS_GLOSSARY}}`, `{{HAS_CHANGELOG}}` — `true`/`false`
   - `{{HAS_DATA_MODEL}}`, `{{HAS_SECURITY}}`, `{{HAS_DESIGN_SYSTEM}}`, `{{HAS_ROADMAP}}`, `{{HAS_I18N}}` — `true`/`false` (specialized docs)
   - `{{GLOBAL_CLAUDE_NOTE}}` — deference note to the global CLAUDE.md (see "CLAUDE.md template selection"), or **empty string** if no global detected
   - `{{REMOTE_PROVIDER}}` — `github` / `gitlab` / empty string
   - `{{REMOTE_VISIBILITY}}` — `private` / `public` / empty string
   - `{{CONTENT}}` (intent brief) — raw brief content
   - `{{INTENT_SOURCE}}` — `intake/INTENT.md (paste)` / `intake/INTENT.md (file ...)` / `interview`
   - `{{GOAL}}`, `{{USERS}}`, `{{CONSTRAINTS}}`, `{{NONGOALS}}`, `{{ACCEPTANCE}}` — synthesized text
3. **Plain text substitution**: no template engine, just `replace` on each placeholder.
4. Write the file to its destination with the `Write` tool.

### CLAUDE.md template selection (lean if a global is detected)

- **Priority case — `CLAUDE.md` project file already present** (resume mode, foreign file without a signature, often tool-managed by an enterprise manager like `claude-manager`): **generate nothing**, never overwrite. Detect a **free zone** (marker `END MANAGED` / `Project-Specific Notes` / "below this line is yours") and offer (opt-in) to **append** a pointer to the starter-kit docs (`docs/VISION.md`, `docs/decisions/`, `docs/LEARNINGS.md`, `PLAN.md`) — free zone **only**, never the managed sections. No free zone → skip. (Detailed logic: see `/starter-kit:adopt` § "CLAUDE.md project file already present".)
- If `HAS_GLOBAL_CLAUDE=false` (and no existing project CLAUDE.md) → use `CLAUDE.md.tpl` and substitute `{{GLOBAL_CLAUDE_NOTE}}` with an **empty string** (removes the placeholder line).
- If `HAS_GLOBAL_CLAUDE=true` → ask **1 question**: *"A global CLAUDE.md was detected. The project CLAUDE.md should **complement** it, not restate it."*
  - `Lean (recommended)` → use `CLAUDE.lean.md.tpl` (deference note already built in, generic sections removed).
  - `Full (with deference note)` → use `CLAUDE.md.tpl` and substitute `{{GLOBAL_CLAUDE_NOTE}}` with:
    > `\n> **Relationship with the global CLAUDE.md**: this file is loaded **in addition to** the global CLAUDE.md (\`~/.claude/CLAUDE.md\` + enterprise policy) — it does not replace it. Do not restate its rules; **on conflict, the global/enterprise rule wins.**`

### File mapping (always created)

| Template | Destination |
|---|---|
| `README.md.tpl` | `README.md` |
| `CLAUDE.md.tpl` | `CLAUDE.md` |
| `gitignore.minimal` | `.gitignore` |
| `decisions-README.md.tpl` | `docs/decisions/README.md` |
| `adr-template.md` | `docs/decisions/0000-template.md` |
| `LEARNINGS.md.tpl` | `docs/LEARNINGS.md` |
| `intake-README.md.tpl` | `intake/README.md` |
| `media-README.md.tpl` | `docs/media/README.md` |

### File mapping (conditional)

| Condition | Template | Destination |
|---|---|---|
| `HAS_PLAN=true` | `PLAN.md.tpl` | `PLAN.md` |
| `HAS_ARCHITECTURE=true` | `ARCHITECTURE.md.tpl` | `docs/ARCHITECTURE.md` |
| `HAS_GLOSSARY=true` | `GLOSSARY.md.tpl` | `docs/GLOSSARY.md` |
| `HAS_CHANGELOG=true` | `CHANGELOG.md.tpl` | `CHANGELOG.md` |
| `HAS_DATA_MODEL=true` | `DATA_MODEL.md.tpl` | `docs/DATA_MODEL.md` |
| `HAS_SECURITY=true` | `SECURITY.md.tpl` | `docs/SECURITY.md` |
| `HAS_DESIGN_SYSTEM=true` | `DESIGN_SYSTEM.md.tpl` | `docs/DESIGN_SYSTEM.md` |
| `HAS_ROADMAP=true` | `ROADMAP.md.tpl` | `docs/ROADMAP.md` |
| `HAS_I18N=true` | `I18N.md.tpl` | `docs/I18N.md` |
| `intent.source` ∈ `paste`/`file` | `intake-INTENT.md.tpl` | `intake/INTENT.md` |
| `intent.source` ≠ `skipped` | `docs-VISION.md.tpl` | `docs/VISION.md` |

### Persisted state

Write `.starter-kit.json` at the root with this schema:

```json
{
  "starterKitVersion": "<current plugin version>",
  "bootstrappedAt": "YYYY-MM-DD",
  "bootstrappedWithVersion": "<current plugin version>",
  "migrations": [],
  "answers": { ... all interview answers ... },
  "intent": {
    "source": "paste" | "file" | "interview" | "skipped",
    "filePath": "<path if file>",
    "goal": "...",
    "users": "...",
    "constraints": [...],
    "nonGoals": [...],
    "acceptanceCriteria": [...]
  },
  "appliedPractices": [],
  "policies": { "noAiAttribution": true | false },
  "generatedFiles": [ ... relative paths ... ],
  "skippedFiles": { "<path>": "<reason>" }
}
```

`policies.noAiAttribution` reflects the `NO_AI_ATTRIBUTION` detected in phase 1 — it lets other skills (`migrate`, etc.) know the policy without re-scanning.

`starterKitVersion` can evolve (via `/starter-kit:migrate`), `bootstrappedWithVersion` stays frozen. `migrations` accumulates `{from, to, at}` entries. `appliedPractices` is filled by `/starter-kit:apply-best-practices`. If the intent is skipped, `intent.source = "skipped"` and the other fields are `null`.

## Phase 6 — Git

1. If `.git/` absent in cwd → `git init -b main`.
2. `git add -A`
3. Check there's something to commit: `git diff --cached --quiet` → if nothing, skip the commit.
4. Otherwise: `git commit -m "chore: bootstrap project structure with starter-kit v0.12.0"`

> **AI attribution**: the commit message must **never** contain an AI attribution marker (`Co-Authored-By` trailer, "Generated with Claude Code" mention, etc.). This is the bootstrap default, and it is **mandatory** if `NO_AI_ATTRIBUTION=true` — this rule **overrides any default attribution guidance** of the agent.

## Phase 7 — Remote (if requested)

If `{{REMOTE_PROVIDER}}=github`:
1. `command -v gh` → if absent, show a manual-instruction message and go to phase 8.
2. `gh auth status` → if not authenticated, indicate `gh auth login` and go to phase 8.
3. `gh repo create {{PROJECT_NAME}} --{{REMOTE_VISIBILITY}} --source=. --remote=origin --push`

If `{{REMOTE_PROVIDER}}=gitlab`: same with `glab` instead of `gh`. The command is `glab repo create {{PROJECT_NAME}} --{{REMOTE_VISIBILITY}}` then `git push -u origin main`.

On graceful failure (CLI absent / auth missing): show the ready-to-paste command for manual execution.

## Phase 8 — Final recap

Show the user:
- ✅ List of created files (relative paths)
- ✅ Git actions performed (init, short commit hash, remote URL if created)
- 📋 Suggested next steps:
  1. **If the intent was captured**: run `/starter-kit:apply-best-practices` to fetch shanraisshan and apply the relevant practices to your vision.
  2. Fill `intake/` with other upstream notes if relevant
  3. Flesh out `CLAUDE.md` (Setup/Build/Test, project-specific sections)
  4. If `PLAN.md` was created: add the first tasks
  5. Read `docs/VISION.md` and amend it if the synthesis missed something
  6. If the intent was skipped and you still want tailored practices: fill `docs/VISION.md` by hand then run `apply-best-practices`

## Important rules

- **NEVER overwrite a file without explicit confirmation** (see phase 4).
- **Always** add `<!-- generated-by: starter-kit v0.12.0 -->` at the top of each generated file (the templates already contain it).
- **Idempotence**: if the user re-runs the skill, resume mode detects already-up-to-date files and does nothing.
- **Surface errors**: if a step fails (e.g. `gh repo create` returns an error), don't pretend it worked. Show the error, propose an action.
- **Keep `.starter-kit.json`**: it's the source of truth for resume mode and for `apply-best-practices`.
- For intent synthesis: be faithful to the source text, don't invent. If the source is thin, the `docs/VISION.md` sections may contain "To be defined" rather than fabricated content.
