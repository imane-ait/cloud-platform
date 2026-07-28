# Runbook — NoTraffic

## Alerte
**Nom :** NoTraffic  
**Sévérité :** Warning  
**Condition :** aucune requête reçue depuis 5 minutes

## Symptômes
- Aucune activité sur le dashboard Grafana
- Prometheus ne collecte plus de métriques HTTP
- Possible indisponibilité silencieuse

## Diagnostic

### 1. Vérifier que l'app tourne
```bash
docker compose ps
curl http://localhost:8000/health
```

### 2. Vérifier que Prometheus scrape bien l'app
```bash
curl http://localhost:9090/targets
```

### 3. Vérifier les logs
```bash
docker compose logs app --tail=50
```

## Remédiation

### Si l'app est down
```bash
docker compose up -d app
```

### Si Prometheus ne scrape plus
```bash
docker compose restart prometheus
```

### Si tout tourne mais pas de trafic
C'est peut-être normal (nuit, weekend). Vérifier avec l'équipe produit.

## Escalade
Si l'app est down et ne redémarre pas → contacter l'équipe infrastructure.
