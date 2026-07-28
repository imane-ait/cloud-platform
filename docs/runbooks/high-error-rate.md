# Runbook — HighErrorRate

## Alerte
**Nom :** HighErrorRate  
**Sévérité :** Critical  
**Condition :** plus de 5% des requêtes retournent une erreur 5xx depuis 1 minute

## Symptômes
- Les utilisateurs reçoivent des erreurs lors de leurs requêtes API
- Le dashboard Grafana "Taux d'erreurs 5xx" dépasse 5%
- Les logs de l'app montrent des exceptions ou stack traces

## Diagnostic

### 1. Regarder les logs de l'app
```bash
docker compose logs app --tail=100
```

### 2. Vérifier la connexion à la DB
```bash
curl http://localhost:8000/ready
```

### 3. Vérifier l'état des conteneurs
```bash
docker compose ps
```

## Remédiation

### Si la DB est inaccessible
```bash
docker compose restart db
docker compose restart app
```

### Si bug applicatif
Identifier l'endpoint qui échoue dans les logs, puis rollback :
```bash
docker compose down
docker compose up -d
```

### Si surcharge
```bash
docker compose restart app
```

## Escalade
Si le problème persiste après 15 minutes → contacter l'équipe infrastructure et ouvrir un incident.
