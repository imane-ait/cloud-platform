# Runbook — HighLatency

## Alerte
**Nom :** HighLatency  
**Sévérité :** Warning  
**Condition :** latence p95 > 300ms depuis 2 minutes

## Symptômes
- Les utilisateurs remarquent des temps de réponse lents
- Le dashboard Grafana "Latence p95" dépasse 300ms
- Les logs montrent des requêtes longues

## Diagnostic

### 1. Vérifier les logs de l'app
```bash
docker compose logs app --tail=100
```

### 2. Vérifier la charge des conteneurs
```bash
docker stats
```

### 3. Vérifier la connexion à la DB
```bash
curl http://localhost:8000/ready
```

## Remédiation

### Si la DB est lente
```bash
docker compose restart db
docker compose restart app
```

### Si surcharge CPU/mémoire
```bash
docker compose restart app
```

## Escalade
Si le problème persiste après 15 minutes → contacter l'équipe infrastructure.