<!-- generated-by: starter-kit v0.7.0 -->
# Sécurité & conformité — {{PROJECT_NAME}}

Document **vivant** des choix de sécurité et de conformité (RGPD / vie privée).

Pour le **pourquoi** des décisions structurantes → voir `docs/decisions/`.

## Authentification

- Méthode : `<à compléter>` (mot de passe, OAuth, magic link, SSO...)
- Gestion des sessions / tokens : `<à compléter>`
- Réinitialisation, MFA : `<à compléter>`

## Autorisation / contrôle d'accès

- Modèle : `<à compléter>` (rôles, RBAC, ABAC, RLS...)
- Matrice rôles × ressources : `<à compléter>`

## Données personnelles (RGPD / vie privée)

- Données perso collectées : `<à compléter>`
- Base légale du traitement : `<à compléter>`
- Durée de conservation : `<à compléter>`
- Droits utilisateurs (accès, suppression, export) : `<à compléter>`
- Sous-traitants / transferts hors UE : `<à compléter>`

## Secrets et configuration

- Où vivent les secrets (vault, variables d'env, gestionnaire) : `<à compléter>`
- Ne JAMAIS committer de secret. Cf. `.gitignore` (`.env`).

## Surface d'attaque et mesures

- Entrées non fiables (formulaires, API, uploads) et validation : `<à compléter>`
- Chiffrement en transit / au repos : `<à compléter>`
- Journalisation et audit : `<à compléter>`

## Incident / divulgation

Procédure en cas de faille ou de fuite : `<à compléter>`.
