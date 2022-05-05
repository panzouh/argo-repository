# Vault secrets chart

Vault secrets is a chart hosted on this repository, you can retrieve templates [here](../../charts/vault-secrets/).

## Operating values

In order to install this chart and start pulling secrets from vault you will need to enable avp by doing `argocd.values.avp.enabled: true`. Additionally you will also need to set either Grafana or Promtheus authType to vault by doing `monitoring.prometheus.values.server.auth.type: vault` or `monitoring.grafana.values.passwordType: vault`.

The chart will generate these secrets (example w/ default values):

```yaml
# Source: vault-secrets/templates/secrets.yml
kind: Secret
apiVersion: v1
metadata:
  name: grafana-credentials
  namespace: test
  annotations:
    avp.kubernetes.io/path: avp/data/grafana
type: Opaque
stringData:
  username: <username>
  password: <password>
---
# Source: vault-secrets/templates/secrets.yml
kind: Secret
apiVersion: v1
metadata:
  name: prometheus-basic-auth
  namespace: monitoring
  annotations:
    avp.kubernetes.io/path: avp/data/prometheus
type: Opaque
stringData:
  auth: <htpasswd>
```

## Linked documentation

- [Prometheus](../monitoring/prometheus.md)
- [Grafana](../monitoring/grafana.md)
