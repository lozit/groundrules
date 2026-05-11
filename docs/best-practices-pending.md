<!-- generated-by: starter-kit v0.6.0 -->
# Best practices pending — à reviewer manuellement

Fichier généré par `/starter-kit:apply-best-practices` le 2026-05-11. Contient les recommandations **non-appliquées automatiquement** (hooks, skills custom) en attente de revue humaine.

---

## Hook : PreToolUse — validation `{{KEY}}` non substitué

**Source** : shanraisshan/claude-code-best-practice (fetch 2026-05-11)
**Priorité** : Medium
**Raison** : Le plugin utilise la substitution texte simple sur `{{KEY}}`. Un placeholder oublié (typo, clé inconnue ajoutée à un template mais pas au SKILL.md) finirait silencieusement écrit dans un fichier utilisateur. Ce hook détecterait le problème **avant** l'écriture.

### Snippet à ajouter dans `.claude/hooks/` ou `.claude/settings.json`

```javascript
// .claude/hooks/PreToolUse.js
// Détecte les placeholders {{KEY}} non substitués avant Write

if (tool.type === 'filesystem.write' || tool.type === 'Write') {
  const content = tool.content || '';
  const unknownKeys = content.match(/\{\{[A-Z_]+\}\}/g) || [];
  if (unknownKeys.length > 0 && !context.allowUnknownKeys) {
    return {
      allowed: false,
      reason: `Placeholders non substitués: ${[...new Set(unknownKeys)].join(', ')}`
    };
  }
}
```

### À faire avant d'activer

- [ ] Valider la syntaxe exacte du hook Claude Code (le snippet ci-dessus est conceptuel — vérifier la doc officielle pour le format `.claude/hooks/` actuel)
- [ ] Whitelist les fichiers où `{{KEY}}` est légitime (les `*.tpl` eux-mêmes !)
- [ ] Tester le hook ne bloque pas l'écriture des templates eux-mêmes

---

## ~~Skill différée : `/starter-kit:verify-bootstrap`~~ — **implémenté en V0.6** ✅

Le skill est désormais disponible : `skills/verify-bootstrap/SKILL.md`. Run `/starter-kit:verify-bootstrap` (rapport seul) ou `/starter-kit:verify-bootstrap --fix` (corrige les version mismatches de signature). Détecte aussi `{{KEY}}` résiduels et valide JSON.

---

## Command différée : `/watch-bootstrap`

**Source** : shanraisshan/claude-code-best-practice (#12)
**Priorité** : Low
**Raison** : Boucle de feedback pendant le développement du plugin lui-même. Watch les fichiers générés, suggère refactor si CLAUDE.md > 200 lignes, etc. Niche, surtout utile pour itérer sur le plugin.

Pas prioritaire pour V0.6 — à reconsidérer si la dette dans le plugin commence à se voir.

---

**Comment utiliser ce fichier** : reviewer chaque section, prendre une décision (implémenter / différer / abandonner), nettoyer ce fichier au fur et à mesure. Si une pratique est implémentée, ajouter une entrée dans `.starter-kit.json` `appliedPractices` (status: `applied`).
