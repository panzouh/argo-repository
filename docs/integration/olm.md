# OLM chart

Operator Lifecycle Manager (OLM) helps users install, update, and manage the lifecycle of Kubernetes native applications (Operators) and their associated services running across their Kubernetes clusters.

## Operating values

By default, the OLM chart is not enabled. You can activate either by setting `olm.enabled: true` or `default.enabled: true`. It will enable all the default stack including OLM, ArgoCD, Namespace configurator operator, Namespace configuration & Vault).

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable OLM chart |
| chart.repo | string | <https://gitlab.com/a4537/repository.git>(this repository) | OLM helm repository |
| chart.path | string | charts/olm | Namespace configuration operator chart path |
| chart.targetRevision | string | HEAD | Chart target revision, using HEAD allow you to use the same version of your cluster spec |
| chart.values | dictionnary | None | Watch section below |

### Chart values (chart.values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitor | boolean | false | Enable prometheus metrics scraping, you will need to enable Prometheus as well |
| debug | boolean | false | Enable debug stdout |
