# ArgoCD installation

First you need to have ArgoCD installed.

## Create ArgoCD namespace

```sh
kubectl create ns argocd
```

## Copy [gitlab-secret.yml](gitlab-secret.yml) and modify to our needs

```sh
wget https://github.com/panzouh/argo-repository.git
```

```sh
kubectl apply -f gitlab-secret.yml
```

## Copy [values.yml](values.yml) file and modify to our needs

```sh
wget https://raw.githubusercontent.com/panzouh/argo-repository/master/prerequisites/values.yml
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
# /!\ Replcace values first !! /!\
helm upgrade --install -n argocd -f values.yml --version 4.5.0 argocd argo/argo-cd
```

Additionnaly you can patch ArgoCD admin password :

```sh
export ARGO_ADMIN_PASSWORD="changeme"

kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
        "admin.password": "'$(htpasswd -bnBC 10 "" ${BAS_ARGOCD_ADM_PASSWD} | tr -d ':\n')'",
        "admin.passwordMtime": "'$(date +%FT%T%Z)'"
      }}'
```

## Create clusters git repository

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
    # If you are using AVP
    # plugin:
    #   name: argocd-vault-plugin
    #   env:
    #   - name: AVP_K8S_ROLE
    #     value: {{ .Values.argocd.chart.values.avp.saName }}
    #   - name: AVP_TYPE
    #     value: vault
    #   - name: VAULT_ADDR
    #     value: 'http://vault.{{ .Values.vault.namespace }}:8200'
    #   - name: AVP_AUTH_TYPE
    #     value: k8s
    helm:
      values: |-
        default:
          enabled: true
      version: v3
    repoURL: https://github.com/panzouh/argo-repository.git

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
