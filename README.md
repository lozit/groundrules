# starter-kit

Plugin Claude Code qui **bootstrappe** un nouveau projet via un slash command interactif.

> Interview → structure de projet adaptée → `git init` → premier commit → remote optionnel.

## Slash commands fournis

- `/starter-kit:bootstrap` — interview + capture d'intent (brief paste / fichier / interview) + génération from-scratch d'un nouveau projet
- `/starter-kit:adopt` — faire entrer un **projet existant** (brownfield) sous gestion starter-kit : scanne, mappe l'existant aux rôles (plan→PLAN, doc métier→brief, todos→backlog, superpowers→interop), génère seulement le manquant, backfill `.starter-kit.json`. Jamais d'écrasement, supporte `--dry-run`
- `/starter-kit:apply-best-practices` — fetche `shanraisshan/claude-code-best-practice` à jour et propose les recommandations adaptées à `docs/VISION.md` du projet
- `/starter-kit:add-adr` — créer un nouvel ADR avec numéro auto, index mis à jour
- `/starter-kit:learn` — ajouter une entrée datée à `docs/LEARNINGS.md`
- `/starter-kit:migrate` — mettre à jour un projet existant vers la version courante du plugin (diff par fichier, jamais d'écrasement sans confirmation, supporte `--dry-run`)
- `/starter-kit:verify-bootstrap` — valider la cohérence d'un projet starter-kit (signatures versions, placeholders résiduels `{{KEY}}`, CLAUDE.md taille, JSON valide, git). Supporte `--fix` pour les corrections triviales (bump signatures).

## Ce que fait `/starter-kit:bootstrap`

`/starter-kit:bootstrap` lance une interview courte (4-8 questions groupées) puis génère :

- `README.md`, `CLAUDE.md`, `.gitignore` — toujours
- `docs/decisions/` (ADR Michael Nygard), `docs/LEARNINGS.md` — toujours
- `brief/`, `media/` — toujours, avec README explicatifs
- `PLAN.md`, `docs/ARCHITECTURE.md`, `docs/GLOSSARY.md`, `CHANGELOG.md` — selon tes réponses
- docs spécialisées optionnelles — `docs/DATA_MODEL.md`, `docs/SECURITY.md`, `docs/DESIGN_SYSTEM.md`, `docs/ROADMAP.md`, `docs/I18N.md`
- `git init` + premier commit
- Création du repo distant via `gh` (GitHub) ou `glab` (GitLab) si tu choisis un fournisseur

Tous les fichiers générés portent une signature `<!-- generated-by: starter-kit -->` pour permettre le **mode reprise** : tu peux relancer la commande sur un dossier non-vide sans risque d'écrasement.

## Fichiers générés (détail)

### Toujours créés

| Fichier | Contenu |
|---|---|
| `README.md` | Présentation publique du projet : titre, description, installation, usage, structure, liens vers la doc. Squelette à compléter selon la stack. |
| `CLAUDE.md` | Instructions pour Claude Code. Mutable et itératif (cible < 200 lignes) : description, commandes Setup/Build/Test, fichiers et dossiers clés, conventions du projet. |
| `.gitignore` | Liste minimale et stack-agnostique : OS (`.DS_Store`…), éditeurs (`.vscode/`, `.idea/`…), logs, `.env`, et dossiers de build courants à adapter. |
| `docs/decisions/README.md` | Explique le format ADR (Architecture Decision Records, d'après Michael Nygard) : convention de nommage `NNNN-titre-kebab.md` et quand créer un ADR. |
| `docs/decisions/0000-template.md` | Gabarit d'ADR à copier : Contexte, Décision, Alternatives considérées, Conséquences (positives / tradeoffs), Statut. |
| `docs/LEARNINGS.md` | Journal des apprentissages non-triviaux, ordre antichronologique. Une entrée = titre daté + Contexte + Leçon. Alimenté par `/starter-kit:learn`. |
| `brief/README.md` | Explique le rôle du dossier `brief/` : notes amont et specs brutes (specs client, brainstorms, emails, notes de cadrage) avant migration vers `docs/`. |
| `media/README.md` | Explique le rôle du dossier `media/` : assets visuels et binaires (images, mockups, captures, diagrammes), avec conventions de nommage et formats. |
| `.starter-kit.json` | Manifest de bootstrap (non destiné à l'édition manuelle) : version du plugin, langue, options choisies, source d'intent, fichiers générés/ignorés. Sert au mode reprise et aux skills `migrate`/`verify-bootstrap`. |

### Créés selon tes réponses

| Fichier | Condition | Contenu |
|---|---|---|
| `PLAN.md` | Activé par défaut | Todo **actif** maintenu par Claude au fil du travail : En cours / À faire ensuite / En attente / Fait récemment. Distinct de la roadmap long terme. |
| `docs/ARCHITECTURE.md` | Projet codant | Snapshot **vivant** de l'architecture : vue d'ensemble, stack, composants et leurs responsabilités. Le *pourquoi* va dans `docs/decisions/`. |
| `docs/GLOSSARY.md` | Jargon métier | Vocabulaire du domaine, une entrée par terme, ordre alphabétique. Définitions courtes pour qu'un nouveau dev (ou Claude) comprenne le langage métier. |
| `CHANGELOG.md` | Releases versionnées | Suivi des modifications au format [Keep a Changelog](https://keepachangelog.com/) + SemVer : sections Added / Changed / Deprecated / Removed / Fixed / Security. |
| `brief/INTENT.md` | Intent capturé (paste/fichier) | **Source brute** de l'intention du projet (paste, email, transcription d'appel, doc PO…) avant synthèse. |
| `docs/VISION.md` | Intent non skippé | **Synthèse structurée** de l'intent : Objectif, Utilisateurs/personas, Contraintes, Hors scope V1, Critères d'acceptation. Base requise par `/starter-kit:apply-best-practices`. |

### Docs spécialisées (optionnelles, cochées à l'interview)

| Fichier | Quand le cocher | Contenu |
|---|---|---|
| `docs/DATA_MODEL.md` | Le projet a une base de données | Entités/tables et leurs champs, relations, règles d'accès au niveau ligne (RLS), index, migrations. |
| `docs/SECURITY.md` | Données sensibles / personnelles | Authentification, autorisation, données perso & conformité RGPD, secrets, surface d'attaque, procédure d'incident. |
| `docs/DESIGN_SYSTEM.md` | Projet avec UI | Principes, couleurs (tokens), typographie, espacements/grille, composants, accessibilité, emplacement des tokens dans le code. |
| `docs/ROADMAP.md` | Trajectoire long terme | Découpage en lots/jalons livrables (objectif, contenu, critère de sortie, statut). Distinct de `PLAN.md` (todo actif). |
| `docs/I18N.md` | Projet multilingue | Langues supportées et fallback, organisation des traductions, formats localisés, détection de la langue, process de traduction. |

> **Langue** : `fr` → tout en français, `en` → tout en anglais, `mix` → `README.md` en anglais + le reste en français. Choix pendant l'interview.

## Installation

### Depuis ce repo (local)

```bash
# Dans Claude Code :
/plugin marketplace add /chemin/vers/starter-kit
/plugin install starter-kit@starter-kit-local
```

### Depuis GitHub

```bash
/plugin marketplace add https://github.com/lozit/claude-code-starter-kit
/plugin install starter-kit
```

### Mode dev (itération rapide sans install)

```bash
claude --plugin-dir /chemin/vers/starter-kit
```

## Usage

Dans le dossier vide d'un nouveau projet :

```bash
cd ~/Projets/mon-nouveau-projet
claude
```

Puis dans Claude Code :

```
/starter-kit:bootstrap
```

Réponds aux questions. La structure est générée, git est initialisé, et (si demandé) le repo distant est créé.

## Langues supportées

Les fichiers générés peuvent être en français, en anglais, ou en mix (README EN + reste FR). Choix pendant l'interview.

## Structure du plugin

```
starter-kit/
├── .claude-plugin/plugin.json    # manifest
├── marketplace.json              # mono-plugin marketplace
└── skills/bootstrap/
    ├── SKILL.md                  # logique du slash command
    └── templates/                # templates Markdown
```

## Prérequis pour le remote

- `gh` CLI pour GitHub : https://cli.github.com/
- `glab` CLI pour GitLab : https://gitlab.com/gitlab-org/cli

Si absent, le plugin affiche les commandes prêtes à coller pour exécution manuelle.

## Roadmap

- [x] V0.1 — bootstrap from-scratch + mode reprise
- [x] V0.2 — `CLAUDE.md` template restructuré avec best practices (Boris Cherny, shanraisshan)
- [x] V0.3 — skills `/starter-kit:add-adr` (nouvel ADR auto-incrémenté) et `/starter-kit:learn` (entrée datée dans LEARNINGS)
- [x] V0.4 — skill `/starter-kit:migrate` (diff par fichier, `.new` fallback, `--dry-run`)
- [x] V0.5 — intent capture dans `bootstrap` + skill `/starter-kit:apply-best-practices` (fetch shanraisshan, propose adapté à la vision)
- [x] V0.6 — skill `/starter-kit:verify-bootstrap` (rapport + `--fix`)
- [x] V0.7 — docs spécialisées optionnelles dans `bootstrap` (`DATA_MODEL`, `SECURITY`, `DESIGN_SYSTEM`, `ROADMAP`, `I18N`) ; dé-numérotation VISION/INTENT ; interop superpowers ; détection planning élargie ; skill `/starter-kit:adopt` (brownfield)
- [x] Publication marketplace publique sur GitHub : [lozit/claude-code-starter-kit](https://github.com/lozit/claude-code-starter-kit)

## Licence

À définir.
