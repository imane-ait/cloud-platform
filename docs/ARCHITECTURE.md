# Architecture — FleetOps Platform

## Vue d'ensemble

FleetOps est une plateforme SaaS de gestion de flotte déployée sur AWS.
L'architecture suit les principes cloud-native : conteneurisation, infrastructure as code, observabilité, et sécurité by design.

---

## Composants

### Application
- **FastAPI** — API REST Python, async, avec endpoints CRUD
- **PostgreSQL** — base de données relationnelle
- **Alembic** — migrations de schéma versionnées

### Infrastructure
- **AWS VPC** — réseau isolé avec subnets publics et privés sur 3 AZ
- **AWS EKS** — Kubernetes managé pour orchestrer les conteneurs
- **AWS RDS** — PostgreSQL managé avec sauvegardes automatiques
- **AWS ECR** — registre d'images Docker privé

### CI/CD
- **GitHub Actions** — pipeline automatique : lint, tests, security scan, build, deploy
- **Helm** — packaging et déploiement sur Kubernetes

### Observabilité
- **Prometheus** — collecte de métriques toutes les 15s
- **Grafana** — dashboards et visualisation
- **Alertes** — 5 règles avec runbooks associés
- **SLOs** — disponibilité >= 99.5%, latence p95 < 300ms

---

## ADR — Architecture Decision Records

### ADR-001 — FastAPI plutôt que Flask

**Date :** 2026-05-01  
**Statut :** Accepté

**Contexte :** Choix du framework Python pour l'API.

**Décision :** FastAPI.

**Raisons :**
- Support natif async — meilleure performance sous charge
- Validation automatique via Pydantic
- Documentation OpenAPI générée automatiquement
- Ecosystem moderne, adopté par les équipes cloud-native

**Alternatives considérées :** Flask (synchrone, moins adapté), Django REST (trop lourd pour une API simple)

---

### ADR-002 — EKS plutôt que ECS

**Date :** 2026-05-15  
**Statut :** Accepté

**Contexte :** Choix de l'orchestrateur de conteneurs sur AWS.

**Décision :** EKS (Kubernetes managé).

**Raisons :**
- Standard industrie — compétences transférables
- Ecosystème riche (Helm, Prometheus, cert-manager)
- HPA natif pour le scaling automatique
- NetworkPolicies pour la sécurité réseau

**Alternatives considérées :** ECS (moins portable, vendor lock-in AWS), Fargate seul (moins de contrôle)

---

### ADR-003 — Terraform pour l'IaC

**Date :** 2026-05-15  
**Statut :** Accepté

**Contexte :** Choix de l'outil d'Infrastructure as Code.

**Décision :** Terraform avec modules.

**Raisons :**
- Multi-cloud, pas de vendor lock-in
- State management avec backend S3
- Modules réutilisables (vpc, eks, rds)
- Large communauté, nombreux providers

**Alternatives considérées :** AWS CDK (vendor lock-in), Pulumi (moins mature)

---

### ADR-004 — Alembic pour les migrations DB

**Date :** 2026-05-20  
**Statut :** Accepté

**Contexte :** Gestion des migrations de schéma PostgreSQL.

**Décision :** Alembic.

**Raisons :**
- Intégration native avec SQLAlchemy
- Migrations versionnées et réversibles
- Autogenerate depuis les modèles SQLAlchemy
- Pas de `create_all` en production

**Alternatives considérées :** Flyway (Java-centric), migrations manuelles (dangereux)

---

### ADR-005 — Prometheus + Grafana pour l'observabilité

**Date :** 2026-06-01  
**Statut :** Accepté

**Contexte :** Choix de la stack de monitoring.

**Décision :** Prometheus + Grafana.

**Raisons :**
- Standard Kubernetes natif
- Pull model — Prometheus scrape les métriques
- Intégration avec kube-prometheus-stack
- Grafana pour la visualisation et les alertes

**Alternatives considérées :** TIG Stack (push model, moins adapté Kubernetes), Datadog (coûteux)
