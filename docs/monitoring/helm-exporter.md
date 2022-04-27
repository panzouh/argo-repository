# Helm exporter Chart

Exports helm release, chart, and version statistics in the prometheus format. If the registry needs authentication then you can use a Kubernetes secret to store the username and password, wich is not supported yet.

## Operating values

By default, Helm exporter is not enabled. In order to enable it you will need to enable Monitoring & Prometheus, by doing `monitoring.enabled: true` & `monitoring.prometheus.enabled: true`, and of course `monitoring.helmExporter.enabled: true`.

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable Helm exporter exporter chart |
| chart.repo | string | <https://shanestarcher.com/helm-charts/> | Helm exporter helm repository |
| chart.name | string | helm-exporter | Helm exporter chart name |
| chart.version | string | 1.2.2+6766a95 | Helm exporter chart version |
| chart.values | dictionnary | None | Watch section below |

### Chart values (chart.values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enablePrometheusRules | boolean | false | Enable prometheus default Prometheus rules (not ready yet) |
| enableGrafanaDashboard | boolean | false | Enable a Grafana specific dashboard, you will need to have Grafana enabled |
