---
name: verify-bootstrap
description: Verify that a starter-kit-bootstrapped project is coherent. Version signatures, leftover placeholders, CLAUDE.md size, valid JSON, git, files vs generatedFiles. Supports --fix for trivial corrections.
disable-model-invocation: true
allowed-tools: Read, Edit, Bash, AskUserQuestion
---

# /starter-kit:verify-bootstrap

You will check the coherence of a starter-kit-bootstrapped project. You will produce a ✅ / ⚠️ / ❌ report and, on request, fix the safe items.

If `$ARGUMENTS` contains `--fix` (or `fix`), switch to **fix mode** after the report. Otherwise, report only.

## Phase 1 — Prerequisites

1. `.starter-kit.json` must exist in the cwd. Otherwise: *"This project was not bootstrapped with starter-kit, nothing to verify."* Stop.
2. Read `.starter-kit.json` → extract:
   - `starterKitVersion` → **EXPECTED_VERSION**
   - `generatedFiles` → list of files to validate
   - `bootstrappedWithVersion` (info; may be `null` for an adopted project)

## Phase 2 — Per-file validations

For each file in `generatedFiles`, run these checks in order:

### 2.1 Existence

`test -f <path>` → if absent, mark **❌ missing** and move to the next file (the following checks are moot).

### 2.2 Signature present

Read the **first 10 lines** of the file (to accommodate a YAML frontmatter that can run 8-9 lines: `---\nname: ...\npaths:\n  - "..."\n  - "..."\n---\n<!-- signature -->`). Search for the regex `<!-- generated-by: starter-kit v([0-9]+\.[0-9]+\.[0-9]+) -->`:
- **Match** → extract the version (FOUND_VERSION), continue
- **No match** → **❌ signature missing**, run the following checks anyway

**Exceptions**: JSON files (`.starter-kit.json`, `.claude/settings.json`, etc.) have no signature (HTML comment invalid in JSON). For those files, skip this check.

**YAML frontmatter note**: for files starting with `---` (rules, skills), the signature **must** be on the line right after the closing `---`. E.g.:
```
---
paths:
  - "..."
---
<!-- generated-by: starter-kit v0.10.0 -->
```

### 2.3 Version match

If a signature is found:
- `FOUND_VERSION == EXPECTED_VERSION` → **✅ version OK**
- Otherwise → **⚠️ version mismatch (FOUND_VERSION vs EXPECTED_VERSION)**

### 2.4 Leftover placeholders

Search the whole file content for the **known placeholders** from bootstrap phase 5 (exact whitelist):

```
\{\{(PROJECT_NAME|DESCRIPTION|STACK|DATE|HAS_PLAN|HAS_ARCHITECTURE|HAS_GLOSSARY|HAS_CHANGELOG|HAS_DATA_MODEL|HAS_SECURITY|HAS_DESIGN_SYSTEM|HAS_ROADMAP|HAS_I18N|GLOBAL_CLAUDE_NOTE|REMOTE_PROVIDER|REMOTE_VISIBILITY|CONTENT|INTENT_SOURCE|GOAL|USERS|CONSTRAINTS|NONGOALS|ACCEPTANCE)\}\}
```

- **No match** → **✅ no placeholder**
- **Match** → **❌ unsubstituted placeholders: {{PROJECT_NAME}}, {{DESCRIPTION}}, ...**

**Important: do NOT match** `{{KEY}}`, `{{X}}`, `{{Y}}`, `{{NNNN}}`, etc. — those are documentation references (in backticks in the text) talking about the placeholder concept. Only the real bootstrap keys trigger the error.

**Exception**: if the file is in `skills/bootstrap/templates/` or is itself a `*.tpl`, skip this check (templates contain these placeholders by design — only relevant in the dogfood, not a normal user project).

## Phase 3 — Structural validations

### 3.1 `.git/`

`test -d .git` → **✅ git initialized** / **⚠️ no git** (maybe intentional but unusual)

### 3.2 CLAUDE.md size

If `CLAUDE.md` exists:
- `wc -l CLAUDE.md` → number of lines
- **≤ 200** → **✅ CLAUDE.md X/200 lines**
- **> 200** → **⚠️ CLAUDE.md X lines (target: < 200, consider extracting to `.claude/rules/`)**

### 3.3 Valid JSON

For each of the following files if it exists:
- `.starter-kit.json`
- `.claude/settings.json`
- `.claude-plugin/plugin.json` (present only if the project is itself a plugin)

JSON test: `python3 -c "import json,sys; json.load(open(sys.argv[1]))" <file>` (or `node -e "JSON.parse(require('fs').readFileSync('<file>'))"`).
- **OK** → **✅ valid JSON**
- **Parse error** → **❌ invalid JSON: <message>**

### 3.4 General coherence

- If `intent.source = "skipped"` but `docs/VISION.md` exists → **⚠️ inconsistency: intent skipped but vision present**
- If `intent.source` ≠ `"skipped"` but `docs/VISION.md` missing → **❌ vision expected but absent**
- **Adopted project** (`adopted: true`): `bootstrappedWithVersion` is `null` by design — do not flag it. If `adoptedFiles` is present, check each listed path exists (**⚠️** if a mapped file is gone).

## Phase 4 — Report output

Clear text format, grouped by category:

```
=== Verify Bootstrap Report ===
Project: <project name from .starter-kit.json>
Expected version: <EXPECTED_VERSION>
Bootstrapped with: <bootstrappedWithVersion>

--- Files (X/Y tracked) ---
✅ docs/decisions/README.md
   ✅ signature v0.10.0 · ✅ no placeholder
✅ docs/VISION.md
   ✅ signature v0.10.0 · ✅ no placeholder
⚠️ docs/ARCHITECTURE.md
   ⚠️ signature v0.9.0 (expected v0.10.0)
❌ docs/missing-file.md
   ❌ file absent

--- Structural ---
✅ .git/ initialized
✅ CLAUDE.md: 78/200 lines
✅ .starter-kit.json valid JSON
✅ .claude/settings.json valid JSON
✅ intent/vision coherence

--- Summary ---
✅ N items OK
⚠️ M items need attention (version mismatch, size)
❌ K items in error (missing, placeholders, invalid JSON)
```

## Phase 5 — Fix mode (if `--fix`)

> If `$ARGUMENTS` does not contain `--fix`, **skip this phase**. Show only: *"To apply trivial fixes, re-run with: `/starter-kit:verify-bootstrap --fix`"*

### Auto-fixable items

- **Version mismatch (⚠️)**: replace the signature line `<!-- generated-by: starter-kit vX.Y.Z -->` with the current version via `Edit`.

### NON auto-fixable items (show, don't touch)

- Missing file → the user must decide (recreate via `migrate`? forget it?)
- Leftover `{{KEY}}` placeholder → bootstrap bug, to report (mapping issue in SKILL.md)
- Invalid JSON → manual editing required
- CLAUDE.md > 200 lines → manual refactor (extract to `.claude/rules/`)
- intent/vision inconsistency → the user decides

### Confirmation

For version-mismatch fixes:
- List the affected files
- `AskUserQuestion`: `Fix the N signatures` / `Cancel`
- If yes, apply the Edits
- Show: `✅ Signatures fixed: N files`

## Phase 6 — Final recap

```
=== Result ===
Mode: report / fix
Fixes applied: N signatures
Remaining items: K errors, M warnings
```

If everything is ✅: *"Project coherent. No fix needed."*

If remaining errors: per-category suggestion of manual action.

**NEVER commit automatically** — let the user review the signature fixes before committing.

## Important rules

- **Read-only by default**: without `--fix`, the skill modifies no file.
- **Fix limited to signatures**: any other kind of correction requires human intervention.
- **No effect on `.starter-kit.json`**: the skill does not modify state — it reports and fixes user files only.
- For the signature regex, accept `v0.0.0` (3 numbers separated by `.`) with no length constraint — future-proof.
- If both `python3` and `node` are absent for the JSON check, use a fallback: `cat <file> | python -m json.tool > /dev/null 2>&1` or simply skip with a warning *"No JSON parser available"*.
