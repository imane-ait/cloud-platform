# Postmortem — Panne DB FleetOps

**Date :** 2026-07-23  
**Durée :** ~2 minutes  
**Sévérité :** Critical  
**Statut :** Résolu  

---

## Résumé

La base de données PostgreSQL a été arrêtée volontairement pour tester la résilience du système. L'API FleetOps a retourné des erreurs 500 sur tous les endpoints nécessitant la DB. L'endpoint `/health` continuait de répondre correctement. La restauration a été effectuée en moins de 2 minutes.

---

## Timeline

| Heure | Événement |
|---|---|
| 13:45:00 | DB arrêtée volontairement (`docker compose stop db`) |
| 13:45:02 | `/vehicles/` retourne `500 Internal Server Error` |
| 13:45:05 | `/ready` retourne une erreur de connexion |
| 13:45:10 | Alerte `AppDown` se déclenche dans Prometheus |
| 13:46:00 | DB redémarrée (`docker compose start db`) |
| 13:46:05 | `/ready` retourne `{"status":"ready","db":"ok"}` |
| 13:46:10 | `/vehicles/` retourne `[]` — service restauré |

---

## Impact

- **Utilisateurs affectés :** 100% — aucune requête CRUD ne fonctionnait
- **Endpoints impactés :** `/vehicles/`, `/drivers/` (tous les endpoints DB)
- **Endpoints non impactés :** `/health` (liveness probe OK)
- **Durée d'indisponibilité :** ~1 minute

---

## Cause racine

Arrêt du conteneur PostgreSQL. Sans DB, SQLAlchemy ne peut pas exécuter les requêtes — toutes les opérations CRUD échouent avec une erreur 500.

---

## Ce qui a bien fonctionné

- `/health` a continué de répondre — Kubernetes n'aurait pas redémarré les pods
- `/ready` a correctement signalé l'indisponibilité avec un 503
- Prometheus a détecté l'anomalie via les métriques d'erreurs
- La restauration a été rapide et sans perte de données

---

## Ce qui aurait pu être mieux

- `/ready` retournait une erreur DNS au lieu d'un 503 propre
- Pas de retry automatique de connexion DB au redémarrage
- Pas d'alerte Alertmanager configurée pour notifier l'équipe

---

## Actions correctives

| Action | Priorité | Responsable |
|---|---|---|
| Configurer Alertmanager pour les notifications | High | Équipe infra |
| Ajouter retry de connexion DB dans l'app | Medium | Équipe dev |
| Mettre en place RDS Multi-AZ en prod | High | Équipe infra |

---

## Leçons apprises

1. Le healthcheck `/health` vs `/ready` est essentiel — l'un vérifie l'app, l'autre vérifie les dépendances
2. Une DB managée (RDS) avec Multi-AZ éviterait ce type d'incident en production
3. Les runbooks permettent une résolution rapide même sous stress
