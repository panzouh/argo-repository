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
helm upgrade --install -n argocd -f values.yml --version 2.14.7 argocd argo/argo-cd
```

## Create cluster git repository path

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
    path: # YOUR PATH
    targetRevision: master
    repoURL: # YOUR GIT REPOSITORY

```
