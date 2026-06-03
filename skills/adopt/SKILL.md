---
name: adopt
description: Adopter un projet existant (brownfield) dans starter-kit — scanne, mappe l'existant aux rôles starter-kit, capture l'intent depuis les docs existantes, génère seulement le manquant, backfill .starter-kit.json. Jamais d'écrasement.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion
---

# /starter-kit:adopt

Tu vas faire entrer un **projet existant** (déjà du code, des docs, un git) sous gestion starter-kit, **sans rien casser**. Différent de `bootstrap` (from-scratch) et de `migrate` (mise à jour d'un projet déjà starter-kit).

Si `$ARGUMENTS` contient `--dry-run` (ou `dry-run`) : exécute toutes les phases d'analyse mais **n'écris aucun fichier** ; termine par un rapport « aurait fait ».

## Phase 0 — Garde-fous

1. Si `.starter-kit.json` existe dans le cwd → *"Ce projet est déjà géré par starter-kit. Utilise `/starter-kit:migrate` pour le mettre à jour."* Stop.
2. Si le dossier est **vide** (hors `.git`) → *"Dossier vide : utilise `/starter-kit:bootstrap`."* Stop.
3. Sinon → on est bien dans un cas brownfield, continue.

## Phase 1 — Scan & classification (mapping de rôles)

1. `ls -la` + détection stack : `package.json` (Node/Nuxt/Vite…), `pyproject.toml`/`requirements.txt`, `Cargo.toml`, `go.mod`, etc. Note aussi : `.git/` + `git remote -v` (GitHub/GitLab), `.env`/`.env.*` (secrets), `i18n/`/`locales/` (multilingue), un ORM/SDK de données (Prisma, Supabase, Drizzle…), un dossier UI (`components/`, `app.vue`…).
   - **CLAUDE.md global / entreprise** : `~/.claude/CLAUDE.md` + politique managée (`/Library/Application Support/ClaudeCode/CLAUDE.md` macOS, `/etc/claude-code/CLAUDE.md` Linux). Si présent → `HAS_GLOBAL_CLAUDE=true` (ne jamais l'écraser). Très fréquent en contexte entreprise — c'est précisément là que le CLAUDE.md projet doit **déférer**.
   - **Politique d'attribution IA** : en **lecture seule**, cherche dans les CLAUDE.md détectés (projet + global) une règle interdisant l'attribution IA (`no AI attribution`, `Co-Authored-By`, `Generated with Claude`, `pas d'attribution`…). Si trouvé → `NO_AI_ATTRIBUTION=true`. Fréquent en entreprise (certains CLAUDE.md managés l'interdisent explicitement).
2. **Détecte superpowers** : présence de `docs/superpowers/plans/` ou `specs/`. Si oui → altitude différente, **ne pas** traiter comme planning racine (cf. interop dans le template `CLAUDE.md`).
3. **Détecte les équivalents de `PLAN.md`** (voir « Détection planning » plus bas) — il peut y en avoir **plusieurs**, possiblement nichés.
4. **Classe chaque élément existant** dans un rôle starter-kit. Construis un tableau :

| Existant | Rôle starter-kit | Action proposée |
|---|---|---|
| `README.md` | README | adopter tel quel ; si **boilerplate** (gabarit GitHub/GitLab « Getting started… ») → proposer régénérer |
| `plan.md` / `TODO.md` / … | PLAN (vue active) | réconciliation (Phase 2) — **jamais** créer un `PLAN.md` qui entre en collision de casse |
| `docs/**/todos.md` | backlog | adopter ; documenter le rôle dans `CLAUDE.md` |
| doc métier (`*regles-metier*`, `CR-*`, specs…) | source d'intent | proposer comme source pour `brief/INTENT.md` / `docs/VISION.md` |
| `docs/superpowers/**` | artefacts par-feature | ne pas toucher ; noter l'interop |
| `docs/ARCHITECTURE.md`, `GLOSSARY.md`… déjà présents | doc projet | adopter tel quel (ne pas régénérer) |
| `CLAUDE.md` présent ? | instructions | **absent** → à générer (cf. Appel 3) ; **présent** → ne jamais écraser, voir « CLAUDE.md projet déjà présent » |

### CLAUDE.md projet déjà présent (souvent tool-managé)

Si un `CLAUDE.md` existe déjà à la racine (sans signature starter-kit) :

1. **Ne jamais le générer ni l'écraser.** On ne peut pas avoir deux CLAUDE.md ; le sien fait foi.
2. **Détecte s'il est tool-managé** : cherche des marqueurs comme `Auto-managed`, `Do not edit`, le nom d'un gestionnaire d'entreprise (ex. `claude-manager`), des barrières de sections managées, ou une **zone libre** explicite (marqueur type `END MANAGED` / `below this line is yours` / titre `## Project-Specific Notes`).
3. **Pointeur de découvrabilité (opt-in)** : si une zone libre est détectée, propose (`AskUserQuestion`) d'y **ajouter** (via `Edit`, append seulement) un court pointeur vers les docs starter-kit, pour que Claude les trouve. **N'écris JAMAIS dans les sections managées.** Contenu suggéré :

   ```
   ### Docs projet (starter-kit)
   - Vision : `docs/VISION.md` · Décisions : `docs/decisions/` · Apprentissages : `docs/LEARNINGS.md` · Plan actif : `PLAN.md`
   ```

4. Si **aucune** zone libre détectée (fichier entièrement managé sans section éditable) → **skip** (ne rien écrire), et le signaler dans le récap.
5. Enregistre dans `.starter-kit.json` `adoptedFiles["CLAUDE.md"] = "instructions (managé par <tool si connu>)"`.

> Dans un contexte fortement managé (le CLAUDE.md couvre déjà commits, sécurité, CHANGELOG, stack…), la valeur de starter-kit se concentre sur `docs/` (VISION, decisions, LEARNINGS, brief) et `PLAN.md` — pas sur le CLAUDE.md. Ne réintroduis pas de doublons. **Signale tout conflit** repéré entre une règle du CLAUDE.md managé et une convention starter-kit (ex. attribution de commit), sans le résoudre toi-même.

### Détection planning (élargie)

Cherche, hors `node_modules`/`.git`, **insensible à la casse**, jusqu'à ~3 niveaux de profondeur :

```bash
find . -path ./node_modules -prune -o -path ./.git -prune -o \
  \( -iname 'plan.md' -o -iname 'todo.md' -o -iname 'todos.md' \
     -o -iname 'tasks.md' -o -iname 'backlog.md' \) -maxdepth 3 -print
```

- Reporte **tous** les résultats (pas seulement le premier).
- **Garde-fou casse** : ne **jamais** générer `PLAN.md` si un fichier de nom équivalent existe en casse différente (ex. `plan.md`). Sur un FS sensible à la casse (Linux/CI) ça créerait deux fichiers `plan.md`/`PLAN.md` → collision au checkout sur macOS/Windows.

## Phase 2 — Interview brownfield (questions groupées, 4 max/appel)

### Appel 1 — Base
- **Langue** des fichiers générés : `FR` / `mix (README EN)` / `EN`.
- **Confirmer le nom du projet** (suggérer le `name` de `package.json` ou le dossier).

### Appel 2 — Intent
*"Quelle source pour la vision du projet ?"* — propose en priorité les **docs métier détectées** :
- `Utiliser <doc détectée>` (ex. `CR-regles-metier.md`) → `Read` puis synthèse vers `docs/VISION.md` (et copie source dans `brief/INTENT.md`).
- `Je colle le contenu` / `Un autre fichier (chemin)` / `Pose-moi les questions` / `Skip`.

Réutilise la logique d'intent de `bootstrap` (Phase 3) pour la synthèse.

### Appel 3 — Quoi générer (multiSelect, seulement le **manquant**)
Pré-coche selon le scan. Ne propose que ce qui **n'existe pas déjà** :
- `CLAUDE.md` **seulement s'il est absent** (s'il existe déjà → voir « CLAUDE.md projet déjà présent », pas de génération). Si absent et **`HAS_GLOBAL_CLAUDE=true`** : propose par défaut la variante **lean** (`CLAUDE.lean.md.{lang}.tpl`) qui complète le global sans le redire ; sinon variante complète. Même logique que `bootstrap` Phase 5 « Sélection du template CLAUDE.md » (placeholder `{{GLOBAL_CLAUDE_NOTE}}`).
- `docs/decisions/` (ADR) + `docs/LEARNINGS.md`
- `brief/` + `media/` (README explicatifs)
- Docs spécialisées (pré-suggérées d'après le scan) : `I18N` si i18n détecté · `SECURITY` si `.env`/APIs · `DATA_MODEL` si ORM/SDK · `DESIGN_SYSTEM` si UI · `ARCHITECTURE`/`GLOSSARY`/`CHANGELOG` au choix.

### Appel 4 — Réconciliation planning (si équivalents détectés)
Si **un ou plusieurs** équivalents trouvés :
- **Adopter l'existant** → pas de `PLAN.md` ; enregistrer le(s) fichier(s) comme rôle PLAN dans `.starter-kit.json`.
- **Générer `PLAN.md` à part** → seulement si **aucune** collision de casse ; l'utilisateur assume la coexistence.
- **Consolider** → reporter les tâches de l'existant dans le fichier choisi comme canonique ; suggérer (sans le faire) de supprimer les doublons.
Si plusieurs équivalents : clarifie leurs rôles (ex. `plan.md` = vue active, `docs/gtd/todos.md` = backlog) et documente-les dans `CLAUDE.md`. Si superpowers présent : `PLAN.md`/`plan.md` doit **pointer** vers le plan superpowers actif.

## Phase 3 — Récap & confirmation

Affiche, en texte clair :
- 🆕 Fichiers qui seront **créés** (manquants)
- 🔗 Fichiers **adoptés** (existants, mappés à un rôle, non modifiés)
- ⏭️ Fichiers **laissés tels quels** (étrangers non mappés)
- ❗ Avertissements (collision de casse évitée, README boilerplate, planning fragmenté)

Puis `AskUserQuestion` : `Confirmer` / `Annuler`. (En `--dry-run`, stop ici avec le rapport.)

## Phase 4 — Génération (manquant uniquement)

Pour chaque fichier à créer : même mécanique que `bootstrap` Phase 5 (lire le template `${CLAUDE_PLUGIN_ROOT}/skills/bootstrap/templates/<tpl>`, substituer `{{KEY}}`, `Write`). **Ne jamais écraser** un fichier existant ; **ne jamais supprimer**. Sélection de langue identique à bootstrap.

## Phase 5 — Backfill `.starter-kit.json`

Écris `.starter-kit.json` (schéma de bootstrap, cf. ADR 0004) avec les marqueurs d'adoption :

```json
{
  "starterKitVersion": "<version courante>",
  "adopted": true,
  "adoptedAt": "YYYY-MM-DD",
  "bootstrappedWithVersion": null,
  "migrations": [],
  "answers": { ... interview ... },
  "intent": { "source": "file|paste|interview|skipped", ... },
  "appliedPractices": [],
  "policies": { "noAiAttribution": true | false },
  "generatedFiles": [ ... fichiers CRÉÉS par adopt ... ],
  "adoptedFiles": { "<path>": "<rôle: README|PLAN|backlog|intent-source|...>" },
  "skippedFiles": { "<path>": "<raison>" }
}
```

`adopted: true` + `bootstrappedWithVersion: null` distinguent un projet adopté d'un projet bootstrappé. `adoptedFiles` mappe l'existant aux rôles (info pour `migrate`/`verify-bootstrap`).

## Phase 6 — Récap final

- ✅ Créés / 🔗 Adoptés / ⏭️ Laissés
- 📋 Next steps :
  1. Compléter `CLAUDE.md` (Setup/Build/Test depuis les scripts du projet, stack, gotchas)
  2. Si intent capturé : `/starter-kit:apply-best-practices`
  3. Relire `docs/VISION.md` ; amender si la synthèse a manqué quelque chose
  4. Décider du sort des plannings fragmentés (consolider si pertinent)
  5. Commiter quand prêt — **si `NO_AI_ATTRIBUTION=true`**, le message de commit ne doit contenir **aucun** marqueur d'attribution IA (`Co-Authored-By`, « Generated with Claude Code »…), même si une consigne par défaut de l'agent l'ajouterait. adopt **ne commit pas** lui-même ; il fournit juste un message suggéré conforme.

**Pas de `git init`** (le projet a déjà un git) ni de création de remote. Si `.git/` est absent : le signaler et suggérer `git init`, sans l'imposer.

## Règles importantes

- **Jamais d'écrasement ni de suppression** sans action explicite (et même là, adopt ne supprime pas — il suggère).
- **Garde-fou casse** : ne jamais créer un fichier qui collisionne en casse avec un existant.
- **superpowers** : `docs/superpowers/**` n'est pas un planning racine — altitude différente, ne pas le toucher.
- **Fidélité à la source** pour la synthèse d'intent : ne pas inventer ; « À préciser » si la source est mince.
- `--dry-run` : aucune écriture, juste le rapport.
- **Ne jamais commiter automatiquement.**
