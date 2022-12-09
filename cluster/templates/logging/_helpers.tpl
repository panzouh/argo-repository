
{{/*
Logging
*/}}

{{- define "elfk.enabled" }}
  {{- and .Values.logging.eck.enabled }}
{{- end }}

{{- define "eck.verbosity" }}
    {{- if eq .Values.logging.eck.values.verbosity "error" }}
      {{- print "-2" }}
    {{- end }}
    {{- if eq .Values.logging.eck.values.verbosity "warning" }}
      {{- print "-1" }}
    {{- end }}
    {{- if eq .Values.logging.eck.values.verbosity "info" }}
      {{- print "0" }}
    {{- end }}
    {{- if eq .Values.logging.eck.values.verbosity "debug" }}
      {{- print "1" }}
    {{- end }}
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
      {{- print "elastic-system" }}
    {{- end }}
  {{- else }}
    {{- print "disabled" }}
  {{- end }}
{{- end }}