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
   - `CLAUDE.md`, `README.md`, `docs/`, `brief/`, `media/`, `PLAN.md`, `CHANGELOG.md`, `.gitignore`, `docs/00-VISION.md`, `brief/00-INTENT.md`
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

### Appel 3 — Pilotage et git
- **`PLAN.md` à la racine** (todo actif maintenu par Claude) : `Oui (recommandé)` / `Non` (1 question)
- **Remote git** : `GitHub` / `GitLab` / `Aucun pour l'instant` (1 question)
- Si remote ≠ "Aucun" :
  - **Visibilité** : `Privé (recommandé)` / `Public` (1 question)

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
3. Write to `brief/00-INTENT.md`

Synthétise vers une vision structurée. Lis le brief et extrais :
- **Goal** : 1-3 phrases sur ce que la réussite ressemble
- **Users** : qui utilise ça
- **Constraints** : deadlines, budget, contraintes tech, régulation
- **Non-goals** : ce qu'on ne fera PAS en V1
- **Acceptance criteria** : comment on saura que c'est fini

Si certains points sont ambigus dans le brief, pose **1 seule** question groupée pour clarifier les ambiguïtés.

### Si "c'est dans un fichier"

Demande le chemin du fichier (absolu ou relatif au cwd). `Read` ce fichier puis traite comme "je le colle" : copie dans `brief/00-INTENT.md` (via le template), synthétise vers `docs/00-VISION.md`.

### Si "Non, pose-moi les questions"

Pose une `AskUserQuestion` avec 4-5 questions :
- **Objectif** : "Quel est l'objectif du projet ? Qu'est-ce que la réussite ressemble ?" (1-3 phrases)
- **Utilisateurs / personas** : "Qui va utiliser ça ? (peut être 'moi-même' si solo)"
- **Contraintes clés** : "Quelles contraintes (deadlines, budget, tech, régulation) ?"
- **Non-goals** : "Qu'est-ce que tu **ne** feras **pas** en V1 ? (utile pour cadrer)"
- **Critères d'acceptation V1** : "Comment tu sauras que c'est fini ?"

Si une question est trop large, l'utilisateur peut répondre "skip" ou "à préciser plus tard" — ne pas insister.

Dans ce cas, pas de `brief/00-INTENT.md` (les réponses sont déjà structurées). Source = `interview`.

### Génération de `docs/00-VISION.md`

Dans tous les cas (sauf Skip total), lis `${CLAUDE_PLUGIN_ROOT}/skills/bootstrap/templates/docs-VISION.md.{lang}.tpl`. Substitue :
- `{{PROJECT_NAME}}`
- `{{INTENT_SOURCE}}` — `brief/00-INTENT.md (paste)` / `brief/00-INTENT.md (fichier <chemin>)` / `interview`
- `{{GOAL}}`, `{{USERS}}`, `{{CONSTRAINTS}}`, `{{NONGOALS}}`, `{{ACCEPTANCE}}` — texte synthétisé

Write to `docs/00-VISION.md`.

### Si "Skip"

Ne créer ni `brief/00-INTENT.md` ni `docs/00-VISION.md`. Noter dans `.starter-kit.json` que `intent.source = "skipped"`. `/starter-kit:apply-best-practices` refusera tant que la vision n'est pas créée.

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
   - `{{REMOTE_PROVIDER}}` — `github` / `gitlab` / chaîne vide
   - `{{REMOTE_VISIBILITY}}` — `private` / `public` / chaîne vide
   - `{{CONTENT}}` (intent brief) — contenu brut du brief
   - `{{INTENT_SOURCE}}` — `brief/00-INTENT.md (paste)` / `brief/00-INTENT.md (fichier ...)` / `interview`
   - `{{GOAL}}`, `{{USERS}}`, `{{CONSTRAINTS}}`, `{{NONGOALS}}`, `{{ACCEPTANCE}}` — texte synthétisé
3. **Substitution texte simple** : pas de moteur de template, juste `replace` sur chaque placeholder.
4. Écris le fichier à destination via l'outil `Write`.

### Sélection des templates par langue

- Pour `{{LANG}}=fr` : utilise `*.fr.tpl`
- Pour `{{LANG}}=en` : utilise `*.en.tpl`
- Pour `{{LANG}}=mix` : `README.md` ← `*.en.tpl`, le reste ← `*.fr.tpl`

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
| `intent.source` ∈ `paste`/`file` | `brief-INTENT.md.{lang}.tpl` | `brief/00-INTENT.md` |
| `intent.source` ≠ `skipped` | `docs-VISION.md.{lang}.tpl` | `docs/00-VISION.md` |

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
  "generatedFiles": [ ... chemins relatifs ... ],
  "skippedFiles": { "<path>": "<reason>" }
}
```

`starterKitVersion` peut évoluer (via `/starter-kit:migrate`), `bootstrappedWithVersion` reste figé. `migrations` accumule les entrées `{from, to, at}`. `appliedPractices` est rempli par `/starter-kit:apply-best-practices`. Si l'intent est skippé, `intent.source = "skipped"` et les autres champs sont `null`.

## Phase 6 — Git

1. Si `.git/` absent dans cwd → `git init -b main`.
2. `git add -A`
3. Vérifie qu'il y a quelque chose à committer : `git diff --cached --quiet` → si rien, skip le commit.
4. Sinon : `git commit -m "chore: bootstrap project structure with starter-kit v0.5.0"`

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
  5. Lire `docs/00-VISION.md` et l'amender si la synthèse a manqué quelque chose
  6. Si l'intent a été skippé et que tu veux quand même des pratiques tailored : remplis `docs/00-VISION.md` à la main puis lance `apply-best-practices`

## Règles importantes

- **Ne JAMAIS écraser un fichier sans confirmation explicite** (cf. phase 4).
- **Toujours** ajouter `<!-- generated-by: starter-kit v0.5.0 -->` en tête de chaque fichier généré (les templates le contiennent déjà).
- **Idempotence** : si l'utilisateur relance le skill, mode reprise détecte les fichiers déjà à jour et ne fait rien.
- **Trace les erreurs** : si une étape échoue (ex. `gh repo create` retourne une erreur), ne fais pas semblant que ça a marché. Affiche l'erreur, propose une action.
- **Conserver le `.starter-kit.json`** : c'est la source de vérité pour le mode reprise et pour `apply-best-practices`.
- Pour la synthèse de l'intent : sois fidèle au texte source, ne pas inventer. Si la source est mince, les sections de `docs/00-VISION.md` peuvent contenir "À préciser" plutôt que du contenu fabriqué.
