<!-- generated-by: starter-kit v0.1.0 -->
# CLAUDE.md — {{PROJECT_NAME}}

Ce fichier guide Claude Code quand il travaille dans ce projet. Lis-le entièrement avant chaque session non triviale.

## Description du projet

{{DESCRIPTION}}

## Arborescence et localisation des fichiers clés

- `README.md` — présentation publique du projet, installation, usage
- `CLAUDE.md` — ce fichier : instructions pour toi
- `PLAN.md` — plan/todo actif (si présent). Tiens-le à jour pendant le travail.
- `docs/` — documentation projet
  - `docs/decisions/` — ADR (Architecture Decision Records). Un fichier par décision structurante.
  - `docs/LEARNINGS.md` — apprentissages au fil du projet (fichier plat, ordre antichronologique)
  - `docs/ARCHITECTURE.md` — snapshot de l'architecture actuelle (si présent)
  - `docs/GLOSSARY.md` — vocabulaire métier (si présent)
- `brief/` — notes amont, specs brutes, mails, brainstorm. Lis ce dossier en début de session si tu cherches du contexte métier.
- `media/` — assets visuels (images, mockups, vidéos)

## Conventions

### Commits

Convention Conventional Commits :
- `feat:` nouvelle fonctionnalité
- `fix:` correction de bug
- `chore:` maintenance, configuration
- `docs:` documentation
- `refactor:` refactorisation sans changement de comportement
- `test:` ajout/modification de tests

Privilégie des commits petits et atomiques. Ne mélange pas une refactorisation et une feature dans le même commit.

### Code

{{STACK}}

Préfère la lisibilité à la concision. Pas d'abstractions prématurées : trois lignes similaires valent mieux qu'une abstraction conjecturale.

## Quand documenter

### ADR — proposer un nouveau document

Dès qu'une **décision structurante** est prise (choix de techno, de pattern, de tradeoff), propose à l'utilisateur de créer un ADR dans `docs/decisions/`.

Format : copie `docs/decisions/0000-template.md` en `NNNN-titre-kebab.md` (incrémente le numéro). Remplis Context, Decision, Consequences. Garde-le court (< 1 page).

### LEARNINGS — ajouter une entrée

Dès qu'un **apprentissage non-trivial** émerge (un piège évité, une convention découverte, un bug subtil), ajoute une entrée datée en tête de `docs/LEARNINGS.md`.

Format :
```
## YYYY-MM-DD — Titre court
Ce qu'on a appris, pourquoi c'est intéressant.
```

N'écris une entrée que si elle a une vraie valeur pour un futur lecteur (toi dans 3 mois, un nouveau dev). Pas de bruit.

### PLAN.md — maintenir à jour

Si présent, mets `PLAN.md` à jour au fil du travail :
- Coche les tâches faites
- Ajoute les tâches émergentes
- Note les blocages

## Workflow git

- Ne committe que sur demande explicite (jamais de commit automatique en fin de tâche)
- Avant de commiter, vérifie qu'il n'y a pas de secret ou de fichier de debug à inclure
- Branche par feature si la modification est non triviale

## À ne pas faire

- Ne pas ajouter de dépendances sans valider avec l'utilisateur
- Ne pas créer de nouveaux fichiers de documentation sans nécessité (préférer enrichir l'existant)
- Ne pas générer de commentaires de code qui paraphrasent le code (le "quoi"). Garde les commentaires pour le "pourquoi" non évident.
- Ne pas faire de refactorisations opportunistes en cours de feature

## Stack technique

{{STACK}}

## Notes

Ce projet a été amorcé avec [starter-kit](https://github.com/guillaumeferrari/starter-kit) le {{DATE}}.
