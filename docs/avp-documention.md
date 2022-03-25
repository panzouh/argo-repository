
# AVP

See [Argo Vault Plugin Configuration](https://argocd-vault-plugin.readthedocs.io/en/stable/config/) for further informations.

## Prerequisites (Install Vault if needed)

### Vault values

```yaml
# vault-values.yml 
---
global:
  enabled: true

injector:
  enabled: true

  replicas: 1

  leaderElector:
    enabled: true
    image:
      repository: "gcr.io/google_containers/leader-elector"
      tag: "0.4"
    ttl: 60s

  image:
    repository: "hashicorp/vault-k8s"
    tag: "0.10.2"
    pullPolicy: Always

  agentImage:
    repository: "vault"
    tag: "1.7.3"
  authPath: "auth/kubernetes"

  failurePolicy: Ignore

  certs:
    secretName: null
    caBundle: ""
    certName: tls.crt
    keyName: tls.key

  resources: {}

server:
  image:
    repository: "vault"
    tag: "1.7.3"
    pullPolicy: IfNotPresent
  updateStrategyType: "OnDelete"
  resources:
    requests:
      memory: 256Mi
      cpu: 250m
    limits:
      memory: 256Mi
      cpu: 250m
  ingress:
    enabled: true
    annotations:
      cert-manager.io/acme-challenge-type: http01
      cert-manager.io/cluster-issuer: letsencrypt-production
      ingress.kubernetes.io/ssl-redirect: "true"
      kubernetes.io/ingress.class: traefik
      kubernetes.io/tls-acme: "true"
      traefik.ingress.kubernetes.io/router.entrypoints: web,websecure
      traefik.ingress.kubernetes.io/router.tls: "true"
    hosts:
      - host: vault.<domain.tl>
    tls:
     - secretName: vault-tls
       hosts:
         - vault.<domain.tl>
  route:
    enabled: false
  readinessProbe:
    enabled: true
    failureThreshold: 2
    initialDelaySeconds: 5
    periodSeconds: 5
    successThreshold: 1
    timeoutSeconds: 3
  livenessProbe:
    enabled: false
  affinity: |-
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app.kubernetes.io/name: {{ template "vault.name" . }}
              app.kubernetes.io/instance: "{{ .Release.Name }}"
              component: server
          topologyKey: kubernetes.io/hostname
  service:
    enabled: true
    port: 8200
    targetPort: 8200
  dataStorage:
    enabled: true
    size: 10Gi
  auditStorage:
    enabled: false
  dev:
    enabled: false
  ha:
    enabled: false
  serviceAccount:
    create: true
ui:
  enabled: true
```

### Add hashicorp helm repository

```sh
helm repo add hashicorp https://helm.releases.hashicorp.com
```

### Install vault

```sh
helm install -n argocd -f vault-values.yml --version=0.19.0 vault hashicorp/vault
```

### Initialize Vault

```sh
vault operator init -key-threshold=3 -key-shares=1
```

### Unseal vault

```sh
vault operator unseal <UNSEAL KEY>
```

### Add token to env

```sh
export VAULT_TOKEN=<VAULT_TOKEN>
```

### Enable Kubernetes auth engine

```sh
vault auth enable kubernetes
```

### Enable Approle auth engine

```sh
vault auth enable approle
```

## Vault configuration

### Write k8s configuration

```sh
vault write auth/kubernetes/config \
    token_reviewer_jwt="`cat /var/run/secrets/kubernetes.io/serviceaccount/token)`" \
    kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```

### Set approle token duration to 720h (1 month)

```sh
vault write auth/token/roles/approle_auth \
            allowed_policies="approle_auth" \
            period="720h"
```

### Enable kv engine to avp path

```sh
vault secrets enable -path avp kv-v2
```

### Create test secret

```sh
vault kv put avp/supersecret username="test" password="test"
```

### Create read policy

```sh
vault policy write avp-sa-policies - <<EOF
path "*" {
  policy = "deny"
}
path "avp/*" {
  capabilities = ["read"]
}
EOF
```

### Create auth kubernetes type and bind it to avp-sa-policies

```sh
vault write auth/kubernetes/role/avp \
    bound_service_account_names=avp \
    bound_service_account_namespaces=argocd \
    policies=avp-sa-policies \
    ttl=24h
```

### Create avp sa in k8s

```sh
kubectl create sa avp 2> /dev/null || echo 'SA Exists'
```

### Create approle policy

```sh
vault policy write approle-generic - <<EOF
path "auth/approle/role/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}
path "auth/token/renew-self" {
    capabilities = ["update"]
EOF
```

## ArgoCD configuration

### Add to server's helm spec and create git repository

```yaml
server:
  # [...]
  config:
    # [...]
    configManagementPlugins: |-
      - name: argocd-vault-plugin
        generate:
          command: ["argocd-vault-plugin"]
          args: ["generate", "./"]
    repositories:
    - url: <git-repository-url>
      passwordSecret:
        name: git
        key: password
      usernameSecret:
        name: git
        key: username
    # [...]
```

### Add to repoServer's helm spec

```yaml
repoServer:
  serviceAccount:
     create: false
     name: "avp"
     annotations: {}
     automountServiceAccountToken: true
  initContainers:
  - name: download-tools
    image: cirrusci/wget:latest
    command: [sh, -c]
    env:
      - name: AVP_VERSION
        value: "1.7.0"
    args:
      - wget -O argocd-vault-plugin https://github.com/argoproj-labs/argocd-vault-plugin/releases/download/v${AVP_VERSION}/argocd-vault-plugin_${AVP_VERSION}_linux_amd64 && chmod 0755 argocd-vault-plugin && mv argocd-vault-plugin /custom-tools/
    volumeMounts:
      - mountPath: /custom-tools
      - name: custom-tools
  volumeMounts:
    - mountPath: /usr/local/bin/argocd-vault-plugin
      name: custom-tools
      subPath: argocd-vault-plugin
  volumes:
    - name: custom-tools
      emptyDir: {}
```

### Create argocd git secret

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: git
  namespace: argocd
data:
  username: <username-b64-encoded>
  password: <password-b64-encoded>
type: Opaque

```

## Test it

Create a git repository

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: argocd
spec:
  syncPolicy:
    syncOptions:
      - CreateNamespace=true
    automated:
      prune: true
      selfHeal: true
  project: default
  destination:
    namespace: argocd
    server: 'https://kubernetes.default.svc'
  source:
    path: 'test'
    repoURL: '<your-git-repo>'
    targetRevision: master
    plugin:
      name: argocd-vault-plugin
      env:
      - name: AVP_K8S_ROLE
        value: avp
      - name: AVP_TYPE
        value: vault
      - name: VAULT_ADDR
        value: 'http://vault.argocd:8200'
      - name: AVP_AUTH_TYPE
        value: k8s
```

Git manifest path ./test/avp-demo-secret.yml

```yaml
---
kind: Secret
apiVersion: v1
metadata:
  name: avp-demo
  annotations:
    avp.kubernetes.io/path: avp/data/supersecret
type: Opaque
stringData:
  username: <username> # Vault will replace placeholder acording to kv values
  password: <password> # Vault will replace placeholder acording to kv values
```
