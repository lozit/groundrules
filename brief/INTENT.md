<!-- generated-by: starter-kit v0.7.0 -->
# Brief / Intent — Starting-Claude

Contenu brut amont (paste, copie de mail, transcription d'appel, doc PO, etc.) décrivant l'intention du projet.

Ce fichier est la **source brute**. La synthèse structurée (goal, users, constraints, non-goals, acceptance) vit dans `docs/VISION.md`.

---

> Capturé rétroactivement le 2026-05-11 depuis le premier message qui a lancé le projet (avant que la phase d'intent capture n'existe dans le plugin lui-même — voir ADR à venir sur le bootstrap rétroactif).

Je voudrais créer un moyen de démarrer le mieux possible un projet Claude Code. Donc j'imagine une slash command peut-être ? à toi de me dire si c'est la bonne méthode.

Généralement je commence avec ce CLAUDE.md trouvé ici : https://resources.leadgenman.com/claudemdfile et ensuite je regarde comment l'améliorer avec ce document ici : https://github.com/shanraisshan/claude-code-best-practice
Il y a d'autres ressources intéressantes sur les bonnes pratiques ici : https://howborisusesclaudecode.com/ et https://github.com/0xquinto/bcherny-claude

En plus d'une configuration de projet adaptée, je voudrais aussi un peu standardiser ce que je fais :
- Systématiquement utiliser GIT
- Facultativement utiliser GITLAB ou GITHUB pour héberger certains projets
- Avoir une arborescence pré-définie pour documenter le projet : je veux que le plan/todo soit présent dans mon dossier de travail, je veux un README.md qui correspond à ce que l'on doit produire sur un projet GIT (explication du projet, comment on installe etc). Peut-être une DOCUMENTATION.md si nécessaire. Je voudrais que les décisions que l'on prend soient notées dans cette arborescence. Idem pour les choses que l'on a apprises. Je voudrais aussi un dossier qui contiendra tout ce que j'ai écrit en amont pour décrire le projet (peut-être là aussi on peut créer une arborescence) et aussi pour stocker les fichiers nécessaires aux projets. Une zone pour des médias. Etc.

Un ami a fait cette structure :
```
docs/
  00-VISION.md          contexte métier, objectifs, ce qui est hors V1
  01-ARCHITECTURE.md    stack, environnements, décisions structurantes
  02-DATA_MODEL.md      schémas Supabase, règles RLS
  03-MODULES.md         spécifications des 6 modules V1
  04-I18N.md            stratégie bilingue FR/EN
  05-SALESFORCE.md      mapping des champs, flux de synchronisation
  06-DESIGN_SYSTEM.md   couleurs, typographies, composants
  07-SECURITY_RGPD.md   authentification, RLS, conformité
  08-NOTIFICATIONS.md   matrice push et emails transactionnels
  09-ROADMAP.md         découpage en lots livrables
  10-PROPERTIES.md      données de référence des 5 propriétés
  tickets/              un fichier .md par ticket
```

Ça me paraît un peu complexe, mais c'est un bon système.

J'imagine qu'on pourrait démarrer le projet soit en répondant à des questions que tu poserais, soit en constituant une documentation qui servirait de point de départ.
