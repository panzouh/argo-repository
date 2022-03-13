{{- define "cluster.syncPolicy" }}
  syncPolicy:
    syncOptions:
      - CreateNamespace=true
{{- if .Values.sync.automated.enabled }}
    automated:
      prune: {{ .Values.sync.automated.prune }}
      selfHeal: {{ .Values.sync.automated.selfHeal }}
{{- end }}
{{- end }}

{{- define "argocd.applications.finalizers" }}
  {{- if .Values.sync.objectsPrune }}
    {{- print "- resources-finalizer.argocd.argoproj.io" }}
  {{- end }}
{{- end }}

# Monitoring

{{- define "alertmanager.enabled" -}}
  {{- and .Values.monitoring.enabled .Values.monitoring.prometheus.enabled .Values.monitoring.prometheus.chart.values.alertmanager.enabled -}}
{{- end }}

{{- define "data.retention" -}}
  {{- print .Values.monitoring.prometheus.chart.values.server.dataRetention -}}
{{- end }}

{{- define "kubeStateMetrics.enabled" -}}
  {{- and .Values.monitoring.enabled .Values.monitoring.prometheus.enabled .Values.monitoring.prometheus.chart.values.kubeStateMetrics.enabled -}}
{{- end }}

{{- define "nodeExporter.enabled" -}}
  {{- and .Values.monitoring.enabled .Values.monitoring.prometheus.enabled .Values.monitoring.prometheus.chart.values.nodeExporter.enabled -}}
{{- end }}

{{- define "preconfigureRules.enabled" -}}
  {{- and .Values.monitoring.enabled .Values.monitoring.prometheus.enabled .Values.monitoring.prometheus.chart.values.rules.preconfiguredEnabled -}}
{{- end }}

{{- define "value" -}}
  {{- print "{{ $value }}" -}}
{{- end -}}

{{- define "labels" -}}
  {{- print "{{ $labels }}" -}}
{{- end -}}

{{- define "labels.instance" -}}
  {{- print "{{ $labels.instance }}" -}}
{{- end -}}

{{- define "labels.namespace" -}}
  {{- print "{{ $labels.namespace }}" -}}
{{- end -}}

{{- define "labels.pod" -}}
  {{- print "{{ $labels.pod }}" -}}
{{- end -}}

{{- define "labels.name" -}}
  {{- print "{{ $labels.name }}" -}}
{{- end -}}

# Logging

{{- define "elfk.enabled" }}
  {{- (and (or .Values.logging.fluentd.enabled .Values.logging.logstash.enabled) .Values.logging.eck.enabled) }}
{{- end }}

{{- define "lp.enabled" }}
  {{- and .Values.logging.loki.enabled .Values.logging.promtail.enabled }}
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
  {{- end }}
{{- end }}
