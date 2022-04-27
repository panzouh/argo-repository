# Goldpinger Chart

Goldpinger makes calls between its instances for visibility and alerting.

## Operating values

By default, Goldpinger is not enabled. In order to enable it you will need to enable Monitoring & Prometheus, by doing `monitoring.enabled: true` & `monitoring.prometheus.enabled: true`, and of course `monitoring.goldpinger.enabled: true`.

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable Goldpinger exporter chart |
| chart.repo | string | <https://okgolove.github.io/helm-charts/> | Goldpinger helm repository |
| chart.name | string | goldpinger | Goldpinger chart name |
| chart.version | string | 5.1.0 | Goldpinger chart version |
| chart.values | dictionnary | None | Watch section below |

### Chart values (chart.values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enablePrometheusRules | boolean | false | Enable prometheus default Prometheus rules (not ready yet) |
| enableGrafanaDashboard | boolean | false | Enable a Grafana specific dashboard, you will need to have Grafana enabled |
