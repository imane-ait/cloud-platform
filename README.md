# FleetOps Platform

Plateforme cloud-native de gestion de flotte deployee sur AWS.
Projet de fin d etudes — Cloud/DevOps Engineering.

## Architecture

Internet → Load Balancer → EKS (FastAPI) → RDS PostgreSQL

- App : FastAPI + PostgreSQL + Alembic
- Infra : AWS VPC + EKS + RDS via Terraform
- CI/CD : GitHub Actions (lint, tests, security, build, deploy)
- Observabilite : Prometheus + Grafana + 5 alertes + SLOs
- Packaging : Helm chart avec values dev/prod

## Stack technique

| Composant | Technologie |
|---|---|
| API | FastAPI, Python 3.12 |
| Base de donnees | PostgreSQL 16, SQLAlchemy, Alembic |
| Conteneurisation | Docker multi-stage |
| Infrastructure | Terraform, AWS (VPC, EKS, RDS, ECR, S3) |
| Orchestration | Kubernetes, Helm |
| CI/CD | GitHub Actions |
| Monitoring | Prometheus, Grafana |
| Securite | Bandit, pip-audit, Trivy, Gitleaks |

## Demarrage rapide

### Prerequis
- Docker + Docker Compose
- Python 3.12
- Terraform >= 1.5
- AWS CLI configure
- kubectl + Helm

### Dev local

git clone https://github.com/imane-ait/cloud-platform.git
cd cloud-platform
cp .env.example .env
docker compose up -d
docker compose exec app alembic upgrade head
curl http://localhost:8000/health
curl http://localhost:8000/docs

### Acces aux interfaces

| Interface | URL | Credentials |
|---|---|---|
| API Swagger | http://localhost:8000/docs | - |
| Prometheus | http://localhost:9090 | - |
| Grafana | http://localhost:3000 | admin/admin |

### Lancer les tests

python -m pytest tests/ --cov=app --cov-report=term-missing

## Infrastructure AWS

cd infra
terraform init
terraform plan
terraform apply

## CI/CD

Le pipeline GitHub Actions se declenche automatiquement a chaque push :

1. Lint — ruff, black
2. Tests — pytest avec PostgreSQL
3. Security — Bandit, pip-audit
4. Build — image Docker poussee sur ECR
5. Deploy — Helm sur EKS (sur merge main)

## Observabilite

- Metriques : /metrics expose les metriques Prometheus
- Dashboards : Grafana sur port 3000
- SLOs : disponibilite >= 99.5%, latence p95 < 300ms
- Runbooks : docs/runbooks/

## Documentation

- docs/ARCHITECTURE.md — decisions d architecture (ADRs)
- docs/SLO.md — definition des SLOs
- docs/POSTMORTEM.md — postmortem incident DB
- docs/runbooks/ — runbooks par alerte
- docs/SECURITY.md — politique de securite
