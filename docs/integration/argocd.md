# ArgoCD Chart

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.

## Operating values

By default, ArgoCD maintained by itself is not enabled. You can activate either by setting `argocd.enabled: true` or `default.enabled: true`. It will enable all the default stack including OLM, ArgoCD, Namespace configurator operator, Namespace configuration & Vault).

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable ArgoCD chart |
| chart.repo | string | <https://argoproj.github.io/argo-helm> | ArgoCD helm repository |
| chart.name | string | argo-cd | ArgoCD chart name |
| chart.version | string | 3.35.0 | ArgoCD chart version |
| values | dictionnary | None | Watch section below |

### Chart values (values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| avp.enabled | boolean | false | Enable AVP extension, watch [AVP Documention](../security/avp-documention.md) first |
| avp.saName | string | avp | Tell to Argo which SA to create |
| avp.auth.vaultUrl | string | "1.7.0" | Only if `argocd.values.avp.enabled=true` & `vault.enabled=false` for external Vault support |
| avp.type.k8s | string | "1.7.0" | AVP Auth type  |
| avp.auth.path | string | "1.7.0" | Override path, default is `auth/kubernetes` |
| monitor | boolean | false | Enable prometheus metrics scraping, you will need to enable Prometheus as well |
| ha | boolean | true | Enable ArgoCD on HA mode |
| ingress.enabled | boolean | true | Enable ArgoCD ui ingress |
| ingress.name | string | argocd | ArgoCD ingress name or path (weither it is an ingress wildcard or domain) |
| insecure | boolean | false | Enable ArgoCD all the way TLS, will be deactivated if ingress are enabled |
| repositories | list | None | Registered repositories not handled yet, watch section below :warning: Credentials not handled yet :warning: |

#### Repositories

##### Add simple repository

```yaml
repositories:
  - url: https://your-repository.domain.tld
```

##### Add user/password private repository

```yaml
repositories:
  - url: https://your-repository.domain.tld/a/repository.git
    passwordSecret:
    # Needs to be created first !
      name: gitlab-secret
      key: password
    usernameSecret:
    # Needs to be created first !
      name: gitlab-secret
      key: username  
```

##### Add SSH private repository

```yaml
repositories:
  - url: git@your-repository.domain.tld:a:repository
    sshPrivateKeySecret:
    # Needs to be created first !
      name: my-ssh-key
      key: sshPrivateKey
```
