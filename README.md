# Repository

Argo repository is a meta chart for simplified cluster management based on ArgoCD [Apps of Apps Pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/).

## Table of Contents

1. [Supported Apps](#supported-apps)
2. [Purpose and what it can do](#purpose-and-what-it-can-do)
3. [Roadmap](#roadmap)
4. [How to install](#how-to-install)
5. [Documentations](#documentations)
6. [Read before commiting an issue](#read-before-commiting-an-issue)
7. [Contribute](#contribute)
8. [License](#license)
9. [Authors](#authors)

## Supported apps

- Backup :
  - TBA
- Chaos engineering :
  - Chaos mesh
- Integration :
  - ArgoCD (Argoception)
  - Namespace Configuration Operator
  - OLM
- Logging :
  - ECK Operator
  - Logstash or Fluentd
  - Loki
  - Promtail
- Monitoring :
  - Prometheus
  - Grafana
  - Fio exporter
  - Blackbox-exporter
  - Helm exporter
  - Prometheus Ms Teams alerting
  - Goldpinger
- Networking :
  - Traefik
  - Nginx
  - CertManager
- Security :
  - Vault (w/ AVP Plugin)
- Storage:
  - TBA

## Purpose and what it can do

Argo repository came up to unify multi Kubernetes clusters configuration, using this repository you are able to simply change the values from one cluster to another trough a cluster definition :

```yaml
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: cluster
  namespace: argocd
spec:
  syncPolicy:
    syncOptions:
      - CreateNamespace=true
    automated:
      prune: true
      selfHeal: true
  destination:
    namespace: argocd
    server: https://kubernetes.default.svc
  project: default
  source:
    path: cluster
    targetRevision: master
    helm:
      values: |-
        default:
          enable: true
      version: v3
    repoURL: https://gitlab.com/a4537/repository.git

```

## Roadmap

- [X] Add ArgoCD project folder for each theme
- [X] Add License
- [] Improve documentation
- [] Add Contribute.md documentation
- [] Handle ArgoCD deprecation notice => WARNING: You are using configs.repositoryCredentials and/or server.config.repositories parameter that are DEPRECATED
Instead, use configs.repositoryTemplates and/or configs.repositories parameters
- Themes :
  - Default:
    - [] Work on proxies
  - Networking:
    - Traefik:
      - [] Add Strict TLS annotations auto
  - Monitoring :
    - Prometheus & Others :
      - [] Add the possibility to add custom rules
      - [] Add Blackbox-exporter configuration w/ url scraping
      - [] Need to work on Prometheus auth
      - [] Configure enablePrometheusRules
    - Grafana :
      - [] Need to work on Grafana auth
  - Logging :
    - [] Add logging templates (Loki & Promtail stack or Elasticsearch & Log daemon (Logstash or Fluend) & Kibana)
  - Backup :
    - [] Add backup solutions (Velero)
  - Storage :
    - [] Add in-cluster storage solutions (Rook)
  - Security :
    - [] Add in-cluster audit tool (dunno yet)

## How to install

Refer to [prequisites](./prerequisites/README.md).

## Documentations

- [AVP](./docs/avp-documention.md)

## Read before commiting an issue

Before submitting an issue please refer to these templates :

- [Bug Report](.gitlab/ISSUE_TEMPLATE/bug_report.md)
- [Feature Request](.gitlab/ISSUE_TEMPLATE/feature_request.md)

Any issues that does not respect the templates will be closed systematically.

## Contribute

:warning: NA yet ! :warning:

Refer to [Contribute documentation](./CONTRIBUTE.md)

## [License](./LICENSE.md)

## Authors

- @Panzouh
