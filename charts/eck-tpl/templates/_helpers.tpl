{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create specfic certificate for external access
*/}}
{{- define "generateSpecificCerts" }}
  {{- if and .Values.clusterSpec.elasticsearch.tls.enabled (eq .Values.clusterSpec.elasticsearch.serviceType "LoadBalancer") (.Values.clusterSpec.elasticsearch.tls.subjectAltNames) }}
    {{- print "true" }}
  {{- end }}
{{- end }}