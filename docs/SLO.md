# SLOs — FleetOps API

## Définitions

Un SLO (Service Level Objective) est un objectif de fiabilité mesurable.
Un SLI (Service Level Indicator) est la métrique qui mesure cet objectif.
Un Error Budget est la marge d'indisponibilité tolérée.

---

## SLO 1 — Disponibilité

**SLI :** Pourcentage de requêtes qui retournent un code HTTP non-5xx  
**Objectif :** >= 99.5% sur une fenêtre glissante de 30 jours  
**Error Budget :** 0.5% = ~3h36 d'indisponibilité par mois  

**Requête Prometheus :**
1 - (rate(http_requests_total{status=~"5.."}[30d]) / rate(http_requests_total[30d]))

---

## SLO 2 — Latence

**SLI :** Pourcentage de requêtes avec latence < 300ms (p95)  
**Objectif :** >= 95% des requêtes répondent en moins de 300ms  
**Error Budget :** 5% des requêtes peuvent dépasser 300ms  

**Requête Prometheus :**
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) < 0.3

---

## Alertes liées aux SLOs

| SLO | Alerte | Sévérité | Condition |
|---|---|---|---|
| Disponibilité | HighErrorRate | Critical | > 5% erreurs 5xx depuis 1 min |
| Latence | HighLatency | Warning | p95 > 300ms depuis 2 min |

---

## Suivi

Les SLOs sont visualisés dans le dashboard Grafana "FleetOps — Métier".
Les alertes Prometheus notifient l'équipe en cas de burn rate élevé.
