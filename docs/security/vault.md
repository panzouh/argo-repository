# Vault chart

Vault is an identity-based secret and encryption management system. A secret is anything you want to tightly control access to, such as API encryption keys, passwords, or certificates. Vault provides encryption services that are controlled by authentication and authorization methods. Using the Vault user interface, CLI, or HTTP API, access to secrets and other sensitive data can be securely stored and managed, tightly controlled (restricted), and auditable.

## Operating values

In order to install vault you can choose if you want to enable vault specifically by doing `vault.enabled: true`.

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable Vault chart |
| namespace | string | argocd | Vault chart destination namespace |
| chart.repo | string | <https://helm.releases.hashicorp.com> | Vault helm repository |
| chart.name | string | vault | Vault chart name |
| chart.version | string | 0.19.0 | Vault chart version |
| values | dictionary | None | Watch section below |

### Chart values (values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitor | boolean | false | Enable prometheus metrics scraping, you will need to enable Prometheus as well |
| ingress.enabled | boolean | true | Enable Vault UI Ingress |
| ingress.name | string | vault | Vault ingress name or path (weither it is an ingress wildcard or domain) |
| pvcSize | string | 10Gi | Vault persistence size, you will need to define a StorageClass in `default.storageClass` |
| ha | boolean | 0.19.0 | Enable vault HA |
