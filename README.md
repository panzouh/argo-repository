# ArgoCD DansTonKube Repository

![DTK Logo](./src/dtk-logo-transparent.png)

Argo repository is a meta chart for simplified cluster management based on ArgoCD [Apps of Apps Pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/).

> :warning: At the moment this meta chart in on tech preview, use it at our own risks.

## Kubernetes supported versions

TBA

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
  - Velero
- Integration :
  - ArgoCD (Argoception)
  - Gitlab runners
  - Harbor
  - Namespace Configuration Operator & Isolated network policy
  - OLM & Custom catalogs
- Logging :
  - ECK Operator
  - Logstash or Fluentd
  - Loki
  - Promtail
- Management :
  - Rancher
- Monitoring :
  - Blackbox-exporter
  - Discord alerting hook
  - Fio exporter
  - Goldpinger
  - Grafana
  - Prometheus
  - Helm exporter
  - Prometheus Ms Teams alerting hook
- Networking :
  - CertManager
  - Traefik
  - Nginx
- Security :
  - Vault (w/ AVP Plugin)
  - Simplified user management
  - Starboard
- Storage:
  - MinIO

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
    repoURL: https://github.com/panzouh/argo-repository.git

```

## [Roadmap](./ROADMAP.md)

## How to install

Refer to [prequisites](./prerequisites/README.md).

## Documentations

If you are looking how to operate the value file, you should refer to [cluster chart documentation](./cluster/)
Although, If you are looking for a specific documentation you should refer to [docs](./cluster). And finally, if you are looking for custom charts documentations, you will find it [here](./charts/).

## Read before commiting an issue

Before submitting an issue please refer to these templates :

- [Bug Report](.gitlab/ISSUE_TEMPLATE/bug_report.md)
- [Feature Request](.gitlab/ISSUE_TEMPLATE/feature_request.md)

Any issues that does not respect the templates will be closed systematically.

## Contribute

Refer to [Contribute documentation](./CONTRIBUTE.md)

## [License](./LICENSE.md)

## Authors

- @Panzouh
