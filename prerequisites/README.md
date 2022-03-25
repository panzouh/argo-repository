# ArgoCD installation

First you need to have ArgoCD installed.

## Create ArgoCD namespace

```sh
kubectl create ns argocd
```

## Copy [gitlab-secret.yml](gitlab-secret.yml) and modify to our needs

```sh
wget https://gitlab.com/panzouh/a4537/repository/-/raw/master/prerequisites/gitlab-secret.yml
```

```sh
kubectl apply -f gitlab-secret.yml
```

## Copy [values.yml](values.yml) file and modify to our needs

```sh
wget https://gitlab.com/panzouh/a4537/repository/-/raw/master/prerequisites/values.yml
```

## Add ArgoCD repository

```sh
helm repo add argo https://argoproj.github.io/argo-helm
```

## Update repo cache

```sh
helm repo update
```

## Install ArgoCD helm chart

```sh
helm upgrade --install -n argocd -f values.yml --version 3.35.0 argocd argo/argo-cd
```

## Create clusters git repository path

### Git repository tree

```bash
clusters/
├── a-cluster
│   └── cluster.yml
└── another-cluster
    └── cluster.yml
```

### Cluster example manifest (Clusters repository)

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
          enabled: true
      version: v3
    repoURL: https://gitlab.com/a4537/repository.git

```

### Apply cluster path on your cluster

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: cluster-path
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
    path: # YOUR PATH (ex: a-cluster)
    targetRevision: master
    repoURL: # YOUR GIT REPOSITORY

```
