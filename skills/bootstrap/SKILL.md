---
name: bootstrap
description: Bootstrap interactif d'un nouveau projet Claude Code — interview, intent du projet, structure docs/, git init, remote optionnel.
disable-model-invocation: true
allowed-tools: Read, Write, Bash, AskUserQuestion
---

# /starter-kit:bootstrap

Tu vas amorcer un projet Claude Code dans le **répertoire de travail courant**. Suis ces phases dans l'ordre, sans en sauter.

## Phase 1 — Scan du dossier

1. Exécute `ls -la` sur le cwd.
2. Détecte les marqueurs suivants et note ce qui est présent :
   - `.git/` (repo git existant)
   - `.starter-kit.json` (état d'une précédente invocation — si présent, charge-le et passe en **mode reprise**)
   - `CLAUDE.md`, `README.md`, `docs/`, `brief/`, `media/`, `PLAN.md`, `CHANGELOG.md`, `.gitignore`, `docs/VISION.md`, `brief/INTENT.md`
   - docs spécialisées optionnelles : `docs/DATA_MODEL.md`, `docs/SECURITY.md`, `docs/DESIGN_SYSTEM.md`, `docs/ROADMAP.md`, `docs/I18N.md`
   - **équivalents de `PLAN.md`** (alias de planning, **même altitude**) — détection **insensible à la casse** et **nichée** (jusqu'à ~3 niveaux, hors `node_modules`/`.git`) : `plan.md`, `TODO.md`, `todo.md`, `todos.md`, `TASKS.md`, `BACKLOG.md`, y compris sous chemin (ex. `docs/gtd/todos.md`). Il peut y en avoir **plusieurs** — reporte-les tous. **Garde-fou casse** : ne **jamais** générer `PLAN.md` si un fichier de nom équivalent existe en casse différente (collision sur FS sensible à la casse).
   - `docs/superpowers/plans/` (plans **par feature** de superpowers — altitude **différente**, *pas* un alias de `PLAN.md`)
   - **CLAUDE.md global / entreprise** (chargé **en plus** du CLAUDE.md projet — ne JAMAIS l'écraser) : `~/.claude/CLAUDE.md`, et la politique managée si présente (`/Library/Application Support/ClaudeCode/CLAUDE.md` sur macOS, `/etc/claude-code/CLAUDE.md` sur Linux). Si au moins un existe → `HAS_GLOBAL_CLAUDE=true`.
   - **Politique d'attribution IA** : lis (en **lecture seule**) les CLAUDE.md détectés (projet + global) et cherche une règle **interdisant** l'attribution IA — motifs (insensibles à la casse) : `no AI attribution`, `Co-Authored-By`, `Generated with Claude`, `do not add ... attribution`, `pas d'attribution`. Si trouvé → `NO_AI_ATTRIBUTION=true`. (Lecture seule : on ne modifie jamais ces fichiers.)
   - `package.json` (→ stack Node), `pyproject.toml`/`requirements.txt` (→ Python), `Cargo.toml` (→ Rust), `go.mod` (→ Go)
3. Pour chaque fichier que tu vas potentiellement créer, classe-le :
   - **Absent** → à créer
   - **Présent avec signature `<!-- generated-by: starter-kit -->` en tête** → reconnu, proposer "ignorer / régénérer"
   - **Présent sans signature** → fichier étranger, défaut "ignorer"

Si le dossier est complètement vide → mode bootstrap classique. Sinon → mode reprise (annoncer clairement à l'utilisateur en début d'interview).

## Phase 2 — Interview de base

Groupe les questions par thème via `AskUserQuestion` (4 questions max par appel pour bonne UX).

### Appel 1 — Identité du projet
- **Nom du projet** : utilise le nom du dossier comme suggestion par défaut, demande confirmation. (1 question)
- **Description courte** (1 phrase — l'intent détaillé sera capturé en phase 3) (1 question)
- **Langue des fichiers générés** : `Tout en français` / `README EN, reste FR` / `Tout en anglais` (1 question)
- **Type de projet** : `Codant (app, lib, CLI...)` / `Non-codant (doc, recherche, notes...)` (1 question)

### Appel 2 — Stack et docs (si codant)
Si projet codant :
- **Stack principale** : pré-remplir avec ce que tu as détecté (Node, Python, etc.), proposer `Autre`, `Aucune particulière` (1 question)
- **`docs/ARCHITECTURE.md`** : Oui (recommandé pour projet codant) / Non (1 question)
- **`docs/GLOSSARY.md`** : `Oui, jargon métier` / `Non` (1 question)
- **`CHANGELOG.md` (Keep-a-Changelog)** : `Oui, releases versionnées prévues` / `Non` (1 question)

Si non-codant, ne pose que les 2 dernières (GLOSSARY, CHANGELOG).

### Appel 2b — Docs spécialisées (optionnelles, si codant)

Un seul `AskUserQuestion` en **multiSelect** : *"Quelles docs spécialisées veux-tu générer ? (toutes optionnelles, tu peux n'en cocher aucune)"*

- **`docs/DATA_MODEL.md`** — entités, relations, règles d'accès. Coche si le projet a une base de données.
- **`docs/SECURITY.md`** — auth, contrôle d'accès, données perso & RGPD. Coche si données sensibles.
- **`docs/DESIGN_SYSTEM.md`** — couleurs, typo, composants. Coche si projet avec UI.
- **`docs/I18N.md`** — stratégie multilingue. Coche si projet multilingue.
- **`docs/ROADMAP.md`** — découpage en lots/jalons long terme (distinct de `PLAN.md`).

Adapte les suggestions au contexte : si la stack/intent évoque une UI, pré-suggère `DESIGN_SYSTEM` ; une BD → `DATA_MODEL` ; etc. N'impose rien : aucune coche = aucun fichier.

Ne pose cet appel que si projet codant. Pour un projet non-codant, seul `ROADMAP` peut avoir du sens — propose-le isolément si pertinent.

### Appel 3 — Pilotage et git
- **`PLAN.md` à la racine** (todo actif maintenu par Claude) : `Oui (recommandé)` / `Non` (1 question)
- **Remote git** : `GitHub` / `GitLab` / `Aucun pour l'instant` (1 question)
- Si remote ≠ "Aucun" :
  - **Visibilité** : `Privé (recommandé)` / `Public` (1 question)

#### Réconciliation si un équivalent de `PLAN.md` existe déjà

Si la Phase 1 a détecté un **alias de planning** (`TODO.md`, `TASKS.md`, `BACKLOG.md`…), **ne pose pas** la question Oui/Non standard sur `PLAN.md`. Pose à la place une question de réconciliation :

- **Adopter l'existant** → ne pas créer `PLAN.md` ; `HAS_PLAN=false`. Noter dans `.starter-kit.json` `skippedFiles["PLAN.md"] = "équivalent existant : <nom>"`.
- **Créer `PLAN.md` en complément** → `HAS_PLAN=true`, créer normalement (l'utilisateur assume les deux fichiers).
- **Reprendre le contenu dans `PLAN.md`** → `Read` l'alias, créer `PLAN.md` à partir du template en y reportant les tâches existantes (section « En cours »), puis suggérer à l'utilisateur de supprimer l'alias. Ne **jamais** supprimer l'alias automatiquement. **Garde-fou casse** : si l'alias est un `plan.md` (même nom, casse différente), ne crée pas un second fichier — propose plutôt d'adopter `plan.md` tel quel.

Si **plusieurs** équivalents sont détectés, liste-les tous et clarifie leurs rôles respectifs (ex. `plan.md` = vue active, `docs/gtd/todos.md` = backlog) dans la question. Pour un projet plus complexe (brownfield, beaucoup de docs existantes), oriente vers `/starter-kit:adopt`.

> **superpowers** : si seul `docs/superpowers/plans/` est présent (sans alias racine), ce **n'est pas** un équivalent de `PLAN.md` (altitude différente — cf. note interop du template `CLAUDE.md`). Garde la question `PLAN.md` standard, et signale dans le récap (Phase 4) que `PLAN.md` doit **pointer** vers le plan superpowers actif plutôt que dupliquer les tâches.

## Phase 3 — Intent du projet

> Avant de générer des fichiers projet, on capture l'intent (objectif, utilisateurs, contraintes, non-goals, critères d'acceptation). Sert de base pour le skill `/starter-kit:apply-best-practices` qui en a besoin.

`AskUserQuestion` : *"As-tu déjà un brief ou un document de vision pour ce projet ?"*
- `Oui, je le colle maintenant`
- `Oui, c'est dans un fichier (chemin)`
- `Non, pose-moi les questions`
- `Skip pour l'instant`

### Si "je le colle maintenant"

Demande à l'utilisateur de coller le contenu (peut être long : plusieurs paragraphes acceptés).

Sauve le brief brut :
1. Lis `${CLAUDE_PLUGIN_ROOT}/skills/bootstrap/templates/brief-INTENT.md.{lang}.tpl`
2. Substitue `{{PROJECT_NAME}}` et `{{CONTENT}}` (le brief tel quel)
3. Write to `brief/INTENT.md`

Synthétise vers une vision structurée. Lis le brief et extrais :
- **Goal** : 1-3 phrases sur ce que la réussite ressemble
- **Users** : qui utilise ça
- **Constraints** : deadlines, budget, contraintes tech, régulation
- **Non-goals** : ce qu'on ne fera PAS en V1
- **Acceptance criteria** : comment on saura que c'est fini

Si certains points sont ambigus dans le brief, pose **1 seule** question groupée pour clarifier les ambiguïtés.

### Si "c'est dans un fichier"

Demande le chemin du fichier (absolu ou relatif au cwd). `Read` ce fichier puis traite comme "je le colle" : copie dans `brief/INTENT.md` (via le template), synthétise vers `docs/VISION.md`.

### Si "Non, pose-moi les questions"

Pose une `AskUserQuestion` avec 4-5 questions :
- **Objectif** : "Quel est l'objectif du projet ? Qu'est-ce que la réussite ressemble ?" (1-3 phrases)
- **Utilisateurs / personas** : "Qui va utiliser ça ? (peut être 'moi-même' si solo)"
- **Contraintes clés** : "Quelles contraintes (deadlines, budget, tech, régulation) ?"
- **Non-goals** : "Qu'est-ce que tu **ne** feras **pas** en V1 ? (utile pour cadrer)"
- **Critères d'acceptation V1** : "Comment tu sauras que c'est fini ?"

Si une question est trop large, l'utilisateur peut répondre "skip" ou "à préciser plus tard" — ne pas insister.

Dans ce cas, pas de `brief/INTENT.md` (les réponses sont déjà structurées). Source = `interview`.

### Génération de `docs/VISION.md`

Dans tous les cas (sauf Skip total), lis `${CLAUDE_PLUGIN_ROOT}/skills/bootstrap/templates/docs-VISION.md.{lang}.tpl`. Substitue :
- `{{PROJECT_NAME}}`
- `{{INTENT_SOURCE}}` — `brief/INTENT.md (paste)` / `brief/INTENT.md (fichier <chemin>)` / `interview`
- `{{GOAL}}`, `{{USERS}}`, `{{CONSTRAINTS}}`, `{{NONGOALS}}`, `{{ACCEPTANCE}}` — texte synthétisé

Write to `docs/VISION.md`.

### Si "Skip"

Ne créer ni `brief/INTENT.md` ni `docs/VISION.md`. Noter dans `.starter-kit.json` que `intent.source = "skipped"`. `/starter-kit:apply-best-practices` refusera tant que la vision n'est pas créée.

## Phase 4 — Récap et confirmation

Affiche un récapitulatif clair en texte :
- Liste des fichiers qui seront **créés** (chemin complet)
- Liste des fichiers qui seront **ignorés** (mode reprise)
- Actions git prévues (`git init`, premier commit, remote)

Puis une question `AskUserQuestion` finale : `Confirmer et générer` / `Annuler`.

## Phase 5 — Génération des fichiers

Pour chaque fichier à créer :

1. Lis le template correspondant dans `${CLAUDE_PLUGIN_ROOT}/skills/bootstrap/templates/`.
2. Remplace les placeholders `{{KEY}}` par les valeurs collectées. Placeholders disponibles :
   - `{{PROJECT_NAME}}` — nom du projet
   - `{{DESCRIPTION}}` — description courte (1 phrase, distincte de la vision)
   - `{{LANG}}` — `fr` / `en` / `mix`
   - `{{STACK}}` — stack ou chaîne vide
   - `{{DATE}}` — date du jour ISO (YYYY-MM-DD)
   - `{{HAS_PLAN}}`, `{{HAS_ARCHITECTURE}}`, `{{HAS_GLOSSARY}}`, `{{HAS_CHANGELOG}}` — `true`/`false`
   - `{{HAS_DATA_MODEL}}`, `{{HAS_SECURITY}}`, `{{HAS_DESIGN_SYSTEM}}`, `{{HAS_ROADMAP}}`, `{{HAS_I18N}}` — `true`/`false` (docs spécialisées)
   - `{{GLOBAL_CLAUDE_NOTE}}` — note de déférence au CLAUDE.md global (voir « Sélection du template CLAUDE.md »), ou **chaîne vide** si aucun global détecté
   - `{{REMOTE_PROVIDER}}` — `github` / `gitlab` / chaîne vide
   - `{{REMOTE_VISIBILITY}}` — `private` / `public` / chaîne vide
   - `{{CONTENT}}` (intent brief) — contenu brut du brief
   - `{{INTENT_SOURCE}}` — `brief/INTENT.md (paste)` / `brief/INTENT.md (fichier ...)` / `interview`
   - `{{GOAL}}`, `{{USERS}}`, `{{CONSTRAINTS}}`, `{{NONGOALS}}`, `{{ACCEPTANCE}}` — texte synthétisé
3. **Substitution texte simple** : pas de moteur de template, juste `replace` sur chaque placeholder.
4. Écris le fichier à destination via l'outil `Write`.

### Sélection des templates par langue

- Pour `{{LANG}}=fr` : utilise `*.fr.tpl`
- Pour `{{LANG}}=en` : utilise `*.en.tpl`
- Pour `{{LANG}}=mix` : `README.md` ← `*.en.tpl`, le reste ← `*.fr.tpl`

### Sélection du template CLAUDE.md (lean si global détecté)

- **Cas prioritaire — `CLAUDE.md` projet déjà présent** (mode reprise, fichier étranger sans signature, souvent tool-managé par un gestionnaire d'entreprise type `claude-manager`) : **ne génère rien**, n'écrase jamais. Détecte une **zone libre** (marqueur `END MANAGED` / `Project-Specific Notes` / « below this line is yours ») et propose (opt-in) d'y **ajouter** un pointeur vers les docs starter-kit (`docs/VISION.md`, `docs/decisions/`, `docs/LEARNINGS.md`, `PLAN.md`) — zone libre **uniquement**, jamais les sections managées. Aucune zone libre → skip. (Logique détaillée : voir `/starter-kit:adopt` § « CLAUDE.md projet déjà présent ».)
- Si `HAS_GLOBAL_CLAUDE=false` (et pas de CLAUDE.md projet existant) → utilise `CLAUDE.md.{lang}.tpl` et substitue `{{GLOBAL_CLAUDE_NOTE}}` par une **chaîne vide** (supprime la ligne du placeholder).
- Si `HAS_GLOBAL_CLAUDE=true` → pose **1 question** : *"Un CLAUDE.md global a été détecté. Le CLAUDE.md projet doit le **compléter**, pas le redire."*
  - `Lean (recommandé)` → utilise `CLAUDE.lean.md.{lang}.tpl` (note de déférence déjà intégrée, sections génériques retirées).
  - `Complet (avec note de déférence)` → utilise `CLAUDE.md.{lang}.tpl` et substitue `{{GLOBAL_CLAUDE_NOTE}}` par :
    > `\n> **Articulation avec le CLAUDE.md global** : ce fichier est chargé **en plus** du CLAUDE.md global (\`~/.claude/CLAUDE.md\` + politique d'entreprise) — il ne le remplace pas. Ne reduplique pas ses règles ; **en cas de conflit, la règle globale/entreprise prévaut.**`

### Mapping fichiers (toujours créés)

| Template | Destination |
|---|---|
| `README.md.{lang}.tpl` | `README.md` |
| `CLAUDE.md.{lang}.tpl` | `CLAUDE.md` |
| `gitignore.minimal` | `.gitignore` |
| `decisions-README.md.{lang}.tpl` | `docs/decisions/README.md` |
| `adr-template.{lang}.md` | `docs/decisions/0000-template.md` |
| `LEARNINGS.md.tpl` | `docs/LEARNINGS.md` |
| `brief-README.md.tpl` | `brief/README.md` |
| `media-README.md.tpl` | `media/README.md` |

### Mapping fichiers (conditionnels)

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
| `intent.source` ∈ `paste`/`file` | `brief-INTENT.md.{lang}.tpl` | `brief/INTENT.md` |
| `intent.source` ≠ `skipped` | `docs-VISION.md.{lang}.tpl` | `docs/VISION.md` |

### État persisté

Écris `.starter-kit.json` à la racine avec ce schéma :

```json
{
  "starterKitVersion": "<version courante du plugin>",
  "bootstrappedAt": "YYYY-MM-DD",
  "bootstrappedWithVersion": "<version courante du plugin>",
  "migrations": [],
  "answers": { ... toutes les réponses de l'interview ... },
  "intent": {
    "source": "paste" | "file" | "interview" | "skipped",
    "filePath": "<chemin si file>",
    "goal": "...",
    "users": "...",
    "constraints": [...],
    "nonGoals": [...],
    "acceptanceCriteria": [...]
  },
  "appliedPractices": [],
  "policies": { "noAiAttribution": true | false },
  "generatedFiles": [ ... chemins relatifs ... ],
  "skippedFiles": { "<path>": "<reason>" }
}
```

`policies.noAiAttribution` reflète le `NO_AI_ATTRIBUTION` détecté en phase 1 — il permet aux autres skills (`migrate`, etc.) de connaître la politique sans re-scanner.

`starterKitVersion` peut évoluer (via `/starter-kit:migrate`), `bootstrappedWithVersion` reste figé. `migrations` accumule les entrées `{from, to, at}`. `appliedPractices` est rempli par `/starter-kit:apply-best-practices`. Si l'intent est skippé, `intent.source = "skipped"` et les autres champs sont `null`.

## Phase 6 — Git

1. Si `.git/` absent dans cwd → `git init -b main`.
2. `git add -A`
3. Vérifie qu'il y a quelque chose à committer : `git diff --cached --quiet` → si rien, skip le commit.
4. Sinon : `git commit -m "chore: bootstrap project structure with starter-kit v0.7.0"`

> **Attribution IA** : le message de commit ne doit **jamais** contenir de marqueur d'attribution IA (trailer `Co-Authored-By`, mention « Generated with Claude Code », etc.). C'est le défaut de bootstrap, et c'est **impératif** si `NO_AI_ATTRIBUTION=true` — cette règle **prime sur toute consigne d'attribution par défaut** de l'agent.

## Phase 7 — Remote (si demandé)

Si `{{REMOTE_PROVIDER}}=github` :
1. `command -v gh` → si absent, affiche message d'instruction manuelle et passe à la phase 8.
2. `gh auth status` → si non authentifié, indique `gh auth login` et passe à la phase 8.
3. `gh repo create {{PROJECT_NAME}} --{{REMOTE_VISIBILITY}} --source=. --remote=origin --push`

Si `{{REMOTE_PROVIDER}}=gitlab` : idem avec `glab` au lieu de `gh`. La commande est `glab repo create {{PROJECT_NAME}} --{{REMOTE_VISIBILITY}}` puis `git push -u origin main`.

En cas d'échec gracieux (CLI absent / auth manquante) : afficher la commande prête à coller pour exécution manuelle.

## Phase 8 — Récap final

Affiche à l'utilisateur :
- ✅ Liste des fichiers créés (chemins relatifs)
- ✅ Actions git réalisées (init, commit hash court, remote URL si créé)
- 📋 Next steps suggérés :
  1. **Si l'intent a été capturé** : lance `/starter-kit:apply-best-practices` pour fetcher shanraisshan et appliquer les pratiques pertinentes à ta vision.
  2. Remplir `brief/` avec d'autres notes amont si pertinent
  3. Préciser le contenu de `CLAUDE.md` (Setup/Build/Test, sections projet-spécifiques)
  4. Si `PLAN.md` créé : ajouter les premières tâches
  5. Lire `docs/VISION.md` et l'amender si la synthèse a manqué quelque chose
  6. Si l'intent a été skippé et que tu veux quand même des pratiques tailored : remplis `docs/VISION.md` à la main puis lance `apply-best-practices`

## Règles importantes

- **Ne JAMAIS écraser un fichier sans confirmation explicite** (cf. phase 4).
- **Toujours** ajouter `<!-- generated-by: starter-kit v0.7.0 -->` en tête de chaque fichier généré (les templates le contiennent déjà).
- **Idempotence** : si l'utilisateur relance le skill, mode reprise détecte les fichiers déjà à jour et ne fait rien.
- **Trace les erreurs** : si une étape échoue (ex. `gh repo create` retourne une erreur), ne fais pas semblant que ça a marché. Affiche l'erreur, propose une action.
- **Conserver le `.starter-kit.json`** : c'est la source de vérité pour le mode reprise et pour `apply-best-practices`.
- Pour la synthèse de l'intent : sois fidèle au texte source, ne pas inventer. Si la source est mince, les sections de `docs/VISION.md` peuvent contenir "À préciser" plutôt que du contenu fabriqué.
