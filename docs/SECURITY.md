# Politique de Sécurité — FleetOps

## Signalement de vulnérabilités

Si vous découvrez une vulnérabilité de sécurité, merci de la signaler par email à l'équipe de sécurité. Ne pas ouvrir d'issue publique GitHub.

---

## Mesures de sécurité en place

### Application
- Validation des données entrantes via Pydantic
- Pas de credentials en clair dans le code
- Secrets via variables d'environnement

### Conteneurisation
- Image Docker multi-stage (surface d'attaque réduite)
- Utilisateur non-root dans le conteneur
- Scan d'image via Trivy dans la CI

### Infrastructure
- Subnets privés pour RDS et EKS
- Security Groups restrictifs
- Secrets AWS via Secrets Manager
- State Terraform chiffré sur S3

### CI/CD
- Bandit — analyse statique du code Python
- pip-audit — scan des dépendances
- Gitleaks — détection de secrets dans le code
- SBOM généré à chaque build

### Rotation des secrets
- Les tokens GitHub sont rotés tous les 90 jours
- Les credentials AWS sont rotés tous les 90 jours
- Les mots de passe DB sont rotés tous les 6 mois

---

## Politique de branches
- `main` est protégé — merge uniquement via PR
- Reviews obligatoires avant merge
- CI doit être verte avant merge
