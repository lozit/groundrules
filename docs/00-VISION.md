<!-- generated-by: starter-kit v0.6.0 -->
# Vision — Starting-Claude

> Synthèse de l'intent du projet. Source : `brief/00-INTENT.md` (paste rétroactif du prompt initial). À mettre à jour quand l'intent évolue (rare ; les décisions tactiques vont dans `docs/decisions/`).

## Objectif

Construire un plugin Claude Code partageable qui standardise l'amorçage de nouveaux projets via un slash command interactif. Le plugin doit générer une structure de documentation cohérente (CLAUDE.md aligné sur les meilleures pratiques, docs/, ADR, learnings, brief, médias, vision/intent), initialiser git, et optionnellement créer le remote GitHub/GitLab. Bonus : appliquer dynamiquement les bonnes pratiques fetchées en ligne, adaptées à la vision de chaque projet.

## Utilisateurs / personas

- **Guillaume Ferrari** (solo) — utilise l'outil pour démarrer ses propres projets Claude Code rapidement et avec une discipline documentaire cohérente.
- **Communauté Claude Code** (secondaire) — toute personne installant le plugin via la marketplace publique sur GitHub (`lozit/claude-code-starter-kit`).

## Contraintes

- Doit être un **plugin Claude Code natif** (`.claude-plugin/plugin.json` + `marketplace.json` + `skills/`) — pas de runtime externe.
- **Pas de moteur de templates** (Jinja, Handlebars) — substitution texte simple sur `{{KEY}}` (cf. ADR 0002).
- **Bilingue FR/EN** sur tous les templates utilisateur.
- **Stack-agnostique** : pas d'opinion forte sur Node, Python, etc. — `.gitignore` minimal par défaut.
- Doit fonctionner **majoritairement offline** : `apply-best-practices` est le seul skill qui requiert internet (WebFetch).
- **CLAUDE.md généré sous 200 lignes** (cible shanraisshan) pour rester utilisable.

## Hors scope V1 (non-goals)

- **Ne remplace pas l'écriture du CLAUDE.md** — c'est un starter, pas un générateur intelligent. L'utilisateur édite et enrichit le CLAUDE.md généré.
- **Pas de gestion CI/CD** — pas de templates GitHub Actions ou GitLab CI par défaut. C'est de la responsabilité du projet, pas du starter.
- **Pas de support pour tooling non-Claude-Code** — Cursor, Continue, autres assistants ne sont pas ciblés.
- **Pas de génération de code applicatif** — pas de squelette React, Python, etc. Le plugin produit de la doc + structure, pas du code.
- **Pas d'IA agentique propriétaire pour la synthèse intent** — utilise simplement Claude (le runtime du plugin) pour synthétiser brief → vision.

## Critères d'acceptation V1

- Un utilisateur peut amorcer un nouveau projet en < 5 minutes : `mkdir foo && cd foo && claude` → `/starter-kit:bootstrap` → réponses interview → fichiers générés + git initialisé.
- 4 skills opérationnels : `bootstrap`, `add-adr`, `learn`, `migrate`, `apply-best-practices`.
- Structure générée : `README.md`, `CLAUDE.md` (avec sections Setup/Build/Test, Vérifier le travail, Mettre à jour ce fichier, Workflow Claude Code, etc.), `docs/decisions/`, `docs/LEARNINGS.md`, `brief/`, `media/`, optionnellement `PLAN.md` / `ARCHITECTURE.md` / `GLOSSARY.md` / `CHANGELOG.md` / `00-VISION.md`.
- Intent capturable au bootstrap (brief paste / brief fichier / interview / skip).
- `apply-best-practices` fetche shanraisshan, filtre par la vision du projet, propose multi-select, applique le safe automatiquement.
- Plugin publié sur GitHub avec marketplace publique : installable via `/plugin marketplace add https://github.com/lozit/claude-code-starter-kit`.
- Dogfood : le repo `Starting-Claude` lui-même utilise sa propre structure et sa propre vision (ce fichier).

---

Pour aller plus loin :
- `brief/` — notes brutes amont (specs, emails, brainstorms) — voir `brief/00-INTENT.md` pour le prompt initial
- `docs/decisions/` — décisions structurantes (4 ADR à ce jour)
- `docs/LEARNINGS.md` — apprentissages non-triviaux
- `docs/ARCHITECTURE.md` — snapshot archi (deux couches : sources plugin / dogfood projet)
