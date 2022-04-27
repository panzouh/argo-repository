# Promtail Chart

Promtail is an agent which ships the contents of local logs to a Loki instance.

## Operating values

To set up Promtail, you will have to activate Loki and Promtail, the two being interdependent. Note that if you activate Loki, Promtail and the ECK suite, a mechanism described below will protect the installation :

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
| enabled | boolean | false | Enable Promtail chart |
| chart.repo | string | <https://grafana.github.io/helm-charts> | Promtail helm repository |
| chart.name | string | promtail | Promtail chart name |
| chart.version | string | 3.11.0 | Promtail chart version |
| chart.values | dictionnary | None | Watch section below |

### Chart values (chart.values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| installOnControllPlane | boolean | true | Enable Promtail on the controll plane, by default Prometheus scraping is enabled |
| runtimeLogs | string | "/var/lib/docker/containers" | Path to runtime containers |
