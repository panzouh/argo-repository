# Blackbox exporter Chart

The blackbox exporter allows blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP, ICMP and gRPC.

## Operating values

By default, Blackbox exporter is not enabled. In order to enable it you will need to enable Monitoring & Prometheus, by doing `monitoring.enabled: true` & `monitoring.prometheus.enabled: true`, and of course `monitoring.blackboxExporter.enabled: true`.S

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable Blackbox exporter chart |
| chart.repo | string | <https://prometheus-community.github.io/helm-charts> | Blackbox exporter helm repository |
| chart.name | string | prometheus-blackbox-exporter | Blackbox exporter chart name |
| chart.version | string | 4.10.14 | Blackbox exporter chart version |
| values | dictionnary | None | Watch section below |

### Chart values (values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enablePrometheusRules | boolean | false | Enable prometheus default Prometheus rules (Will be announced in a future release) |
| enableGrafanaDashboard | boolean | false | Enable a Grafana specific dashboard, you will need to have Grafana enabled |
| scrapeUrls | list | `[]` | Create Url get configs accepted code are `200` & `403` (If you are using authentication) |

### Scrape Url example

```yaml
scrapeUrls:
  - https://an-app.domain.tld
  - https://another-app.domain.tld
```
