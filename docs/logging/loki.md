# Loki Chart

Loki is a horizontally scalable, highly available, multi-tenant log aggregation system inspired by Prometheus. It is designed to be very cost effective and easy to operate. It does not index the contents of the logs, but rather a set of labels for each log stream.

The Loki project was started at Grafana Labs in 2018, and announced at KubeCon Seattle. Loki is released under the AGPLv3 license.

Grafana Labs is proud to lead the development of the Loki project, building first-class support for Loki into Grafana, and ensuring Grafana Labs customers receive Loki support and features they need.

## Operating values

To set up Loki, you will have to activate Loki and Promtail, the two being interdependent. Note that if you activate Loki, Promtail and the ECK suite, a mechanism described below will protect the installation :

```yaml
{{- define "elfk.enabled" }}
  {{- (and .Values.logging.enabled (or .Values.logging.fluentd.enabled .Values.logging.logstash.enabled) .Values.logging.eck.enabled) }}
{{- end }}

{{- define "lp.enabled" }}
  {{- and .Values.logging.loki.enabled .Values.logging.promtail.enabled .Values.logging.enabled }}
{{- end }}

{{- define "logging.namespace" }}
  {{- if or (eq (include "lp.enabled" .) "true") (eq (include "elfk.enabled" .) "true") }}
    {{- if and (eq (include "lp.enabled" .) "true") (eq (include "elfk.enabled" .) "true") }}
      {{- print "disabled" }}
    {{- else if eq (include "lp.enabled" .) "true" }}
      {{- print "monitoring" }}
    {{- else if eq (include "elfk.enabled" .) "true" }}
      {{- print "elasticsearch-logging" }}
    {{- end }}
  {{- else }}
    {{- print "disabled" }}
  {{- end }}
{{- end }}
```

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable Loki chart |
| chart.repo | string | <https://grafana.github.io/helm-charts> | Loki helm repository |
| chart.name | string | loki | Loki chart name |
| chart.version | string | 2.10.3 | Loki chart version |
| chart.values | dictionnary | None | Watch section below |

### Chart values (chart.values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitor | boolean | false | Enable prometheus metrics scraping, you will need to enable Prometheus as well |
| enableGrafanaDashboard | boolean | false | Enable a Grafana specific dashboard, you will need to have Grafana enabled |
| pvcSize | string | 10Gi | Grafana persistence size, you will need to define a StorageClass in `default.storageClass` |
