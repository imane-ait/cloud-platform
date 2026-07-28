# Runbook — AppDown

## Alerte
**Nom :** AppDown  
**Sévérité :** Critical  
**Condition :** `up{job="fleetops-api"} == 0` pendant 30 secondes

## Symptômes
- L'app FleetOps ne répond plus
- `/health` retourne une erreur de connexion
- Les utilisateurs ne peuvent plus accéder à l'API

## Diagnostic

### 1. Vérifier l'état des conteneurs
```bash
docker compose ps
docker compose logs app --tail=50
```

### 2. Vérifier la connexion à la DB
```bash
curl http://localhost:8000/ready
```

### 3. Vérifier les ressources système
```bash
docker stats
df -h
free -m
```

## Remédiation

### Si le conteneur est arrêté
```bash
docker compose up -d app
```

### Si la DB est inaccessible
```bash
docker compose restart db
docker compose restart app
```

### Si manque de mémoire
```bash
docker compose down
docker system prune -f
docker compose up -d
```

## Escalade
Si le problème persiste après 15 minutes → contacter l'équipe infrastructure.
