# Runbook — HighRequestRate

## Alerte
**Nom :** HighRequestRate  
**Sévérité :** Warning  
**Condition :** plus de 10 requêtes/seconde depuis 1 minute

## Symptômes
- Trafic inhabituellement élevé sur l'API
- Dashboard Grafana "Requests per second" dépasse 10 RPS
- Possible ralentissement de l'app

## Diagnostic

### 1. Identifier l'endpoint le plus appelé
```bash
docker compose logs app --tail=200 | grep "GET\|POST\|DELETE"
```

### 2. Vérifier si c'est légitime ou une attaque
```bash
docker compose logs app --tail=200 | grep "IP"
```

### 3. Vérifier la charge système
```bash
docker stats
```

## Remédiation

### Si trafic légitime — surveiller
```bash
docker stats
```

### Si attaque — bloquer au niveau réseau
Contacter l'équipe infrastructure pour bloquer l'IP source.

### Si l'app commence à ralentir
```bash
docker compose restart app
```

## Escalade
Si le trafic continue d'augmenter et l'app ralentit → contacter l'équipe infrastructure immédiatement.
