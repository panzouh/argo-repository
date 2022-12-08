{{/*
Monitoring
*/}}

{{- define "alertmanager.enabled" -}}
  {{- and .Values.monitoring.prometheus.enabled .Values.monitoring.prometheus.values.alertmanager.enabled -}}
{{- end }}

{{- define "data.retention" -}}
  {{- print .Values.monitoring.prometheus.values.server.dataRetention -}}
{{- end }}

{{- define "kubeStateMetrics.enabled" -}}
  {{- and .Values.monitoring.prometheus.enabled .Values.monitoring.prometheus.values.kubeStateMetrics.enabled -}}
{{- end }}

{{- define "nodeExporter.enabled" -}}
  {{- and .Values.monitoring.prometheus.enabled .Values.monitoring.prometheus.values.nodeExporter.enabled -}}
{{- end }}

{{- define "preconfigureRules.enabled" -}}
  {{- and .Values.monitoring.prometheus.enabled .Values.monitoring.prometheus.values.rules.preconfiguredEnabled -}}
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

{{- define "labels.node" -}}
  {{- print "{{ $labels.node }}" -}}
{{- end -}}

{{- define "labels.verb" -}}
  {{- print "{{ $labels.verb }}" -}}
{{- end -}}

{{- define "labels.resource" -}}
  {{- print "{{ $labels.resource }}" -}}
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

{{- define "labels.persistentvolumeclaim" -}}
  {{- print "{{ $labels.persistentvolumeclaim }}" -}}
{{- end -}}

{{- define "labels.exported_job" -}}
  {{- print "{{ $labels.exported_job }}" -}}
{{- end -}}

{{- define "labels.goldpinger_instance" -}}
  {{- print "{{ $labels.goldpinger_instance }}" -}}
{{- end -}}

{{ define "grafana.instance" -}}
  {{- print "{{ instance }}" -}}
{{- end -}}