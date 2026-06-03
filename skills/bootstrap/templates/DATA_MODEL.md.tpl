<!-- generated-by: starter-kit v0.7.0 -->
# Modèle de données — {{PROJECT_NAME}}

Description **vivante** du modèle de données. Mise à jour à chaque évolution de schéma.

Pour le **pourquoi** des choix (moteur, dénormalisation...) → voir `docs/decisions/`.

## Vue d'ensemble

Paragraphe ou diagramme : les entités principales et leurs relations.

<!-- Exemple Mermaid :
```mermaid
erDiagram
    USER ||--o{ ORDER : passe
    ORDER ||--|{ LINE_ITEM : contient
```
-->

## Entités

### Entité A

| Champ | Type | Contraintes | Description |
|---|---|---|---|
| `id` | `uuid` | PK | Identifiant |
| `...` | `...` | `...` | `...` |

### Entité B

| Champ | Type | Contraintes | Description |
|---|---|---|---|
| `id` | `uuid` | PK | Identifiant |

## Relations

- `A` 1—N `B` : ...

## Règles d'accès / sécurité au niveau ligne

> Si la BD applique des règles d'accès par ligne (RLS) ou des policies, documente-les ici. Sinon, supprime cette section.

- `A` : un utilisateur ne voit que ses propres lignes (`owner_id = auth.uid()`).

## Index et performance

- `A(created_at)` — pour les requêtes par date.

## Migrations

Où vivent les migrations (dossier, outil) et comment en créer une : `<à compléter>`.
