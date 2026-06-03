<!-- generated-by: starter-kit v0.7.0 -->
# CLAUDE.md — {{PROJECT_NAME}}

> **Articulation avec le CLAUDE.md global** : ce fichier est chargé **en plus** du CLAUDE.md global (`~/.claude/CLAUDE.md` + politique d'entreprise managée) — il ne le remplace pas. Il ne contient que le **spécifique au projet**. Ne reduplique pas les règles globales (commits, workflow, choix d'outils/MCP, vérification, conventions de sortie…). **En cas de conflit, la règle globale/entreprise prévaut.**

> Variante **lean** : un CLAUDE.md global a été détecté à la génération. Pour la version complète (toutes les sections génériques), regénère sans l'option lean.

## Description

{{DESCRIPTION}}

## Setup / Build / Test

> **Test critique** : un nouveau dev (ou Claude) doit pouvoir lancer le projet et ses tests **du premier coup** avec les commandes ci-dessous.

- Installer les deps : `<à compléter>`
- Lancer en dev : `<à compléter>`
- Tester : `<à compléter>`
- Linter : `<à compléter>`
- Build : `<à compléter>`

## Fichiers et dossiers clés

- `README.md` — présentation publique
- `CLAUDE.md` — ce fichier (spécifique projet ; le générique vit dans le global)
- `PLAN.md` — todo actif (si présent)
- `docs/` — documentation projet (`docs/decisions/` ADR, `docs/LEARNINGS.md`, etc.)
- `brief/` — notes amont (contexte métier)
- `media/` — assets visuels

## Conventions spécifiques au projet

{{STACK}}

> Ne mets ici **que** ce qui diffère ou précise le global : conventions de code propres à ce repo, patterns maison, pièges connus. Les règles transverses (git, commits, outils, vérification) sont dans le CLAUDE.md global.

## Quand documenter

- **ADR** (`docs/decisions/`) : toute décision structurante → copier `0000-template.md`.
- **LEARNINGS** (`docs/LEARNINGS.md`) : tout apprentissage non-trivial, entrée datée en tête.
- **PLAN.md** : cocher fait, ajouter émergent, noter blocages.

## Mettre à jour ce fichier

Ce fichier est vivant. Quand Claude se trompe sur quelque chose de **propre à ce projet**, ajoute la règle ici. Si la règle est transverse, propose-la plutôt pour le CLAUDE.md global.

## Notes

Projet amorcé avec [starter-kit](https://github.com/lozit/claude-code-starter-kit) le {{DATE}}.
