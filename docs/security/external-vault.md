# External Vault AVP setup

:warning: If you are using this setup you will have to renew Vault auth configuration every time certificates are renewed :warning:

## Kubernetes setup

### Create service account and cluster role binding on your cluster

```sh
kubectl create ns vault || echo 'Namespace exists' && kubectl create sa -n vault-auth-delegator || echo 'SA exists'
```

### Extract service account token & cluster certficate

#### Token

```sh
kubectl -n vault get secret --output 'go-template={{ .data.token }}' $(kubectl -n vault get sa vault-auth-delegator --output jsonpath="{.secrets[*]['name']}") | base64 -d > cluster-token
```

#### Certificate

```sh
kubectl get secret $(kubectl -n vault get sa vault-auth-delegator --output jsonpath="{.secrets[*]['name']}") -o json | jq -r '.data["ca.crt"]' | base64 -d > cluster.crt
```

### Create cluster role binding

```yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
   name: role-tokenreview-binding ##This Role!
   namespace: default
roleRef:
   apiGroup: rbac.authorization.k8s.io
   kind: ClusterRole
   name: system:auth-delegator
subjects:
- kind: ServiceAccount
  name: vault-auth-delegator
  namespace: vault
```

## Vault setup

### Enable Kubernetes new auth path

```sh
vault auth enable --path=a-cluster kubernetes 
```

### Create Kubernetes configuration on Vault

```sh
vault write auth/a-cluster/config \
    token_reviewer_jwt="$(cat cluster-token)" \
    kubernetes_host=https://your-vault-url.domain.tld \
    kubernetes_ca_cert="$(cat cluster.crt)" \
    issuer="https://kubernetes.default.svc"
```

### Create a kv engine (if needed)

```sh
vault secrets enable -path=a-secrets kv-v2
```

```sh
vault policy write a-cluster-read - <<EOF
  path "a-secrets/*" {
    capabilities = ["read"]
 }
EOF
```

### Bind policy to your service account

```sh
vault write auth/a-cluster/role/avp \
    bound_service_account_names=avp \
    bound_service_account_namespaces=argocd \
    policies=a-cluster-read \
    ttl=24h
```

### Change your cluster file value

```yaml
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
        # [...]
        argocd:
          enabled: false
          namespace: argocd
          chart:
            repo: https://argoproj.github.io/argo-helm
            name: argo-cd
            version: "4.5.0"
          values:
            avp:
              enabled: false
              saName: avp
              version: "1.10.1"
              auth:
                vaultUrl: "https://your-vault.domain.tld"
                type: k8s
                path: auth/a-cluster # /!\ Change HERE /!\
        # [...]
      version: v3
    repoURL: https://github.com/panzouh/argo-repository.git
```

### Try Vault service account cluster role

```sh
curl -X POST "https://<kubectl-api-endpoint>:6443/apis/authentication.k8s.io/v1/tokenreviews" \
     --cacert ~/rct.crt \
     -H 'Authorization: Bearer <Vault SA Token>' \
     -H 'Content-Type: application/json; charset=utf-8' \
     -H 'X-Vault-Namespace: automation/' \
     -d '{"kind": "TokenReview","apiVersion": "authentication.k8s.io/v1","spec": {"token": "<AVP SA Token>"}}'
```
