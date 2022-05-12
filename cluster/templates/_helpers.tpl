{{/*
General
*/}}

{{- define "cluster.syncPolicy.default" }}
  syncPolicy:
    syncOptions:
      - CreateNamespace=true
{{- if .Values.sync.enabled }}
    automated:
      prune: {{ .Values.sync.prune }}
      selfHeal: {{ .Values.sync.selfHeal }}
{{- end }}
{{- end }}

{{- define "cluster.syncPolicy.withoutNamespace" }}
  syncPolicy:
    syncOptions:
      - CreateNamespace=false
{{- if .Values.sync.enabled }}
    automated:
      prune: {{ .Values.sync.prune }}
      selfHeal: {{ .Values.sync.selfHeal }}
{{- end }}
{{- end }}

{{- define "argocd.applications.finalizers" }}
  {{- if .Values.sync.prune }}
    {{- print "- resources-finalizer.argocd.argoproj.io" }}
  {{- end }}
{{- end }}

{{/*
Networking
*/}}

{{- define "ingress.isTraefik" }}
  {{- .Values.ingress.traefik.enabled }}
{{- end }}

{{- define "ingress.isNginx" }}
  {{- .Values.ingress.nginx.enabled }}
{{- end }}

{{- define "ingress.namespace" }}
  {{- if or (eq (include "ingress.isTraefik" .) "true") (eq (include "ingress.isNginx" .) "true") }}
    {{- if and (eq (include "ingress.isTraefik" .) "true") (eq (include "ingress.isNginx" .) "true") }}
      {{- print "disabled" }}
    {{- else if eq (include "ingress.isTraefik" .) "true" }}
      {{- print "traefik-system" }}
    {{- else if eq (include "ingress.isNginx" .) "true" }}
      {{- print "ingress-nginx" }}
    {{- end }}
  {{- else }}
    {{- print "disabled" }}
  {{- end }}
{{- end }}

{{- define "helm-ingress.definition" -}}
{{- $name := .name -}}
{{- $ingressDefinition := .ingressDefinition | default dict -}}
{{- $annotations := .annotations | default dict -}}
ingress:
  enabled: true
  {{- if $annotations }}
  annotations:
    {{- with $annotations }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- else }}
  annotations: {}
  {{- end }}
  hosts:
  {{- if eq $ingressDefinition.dns.mode "wildcard" }}
    - {{ $name }}.{{ $ingressDefinition.dns.wildcard }}
  {{- else if eq $ingressDefinition.dns.mode "domain" }}
    - {{ $ingressDefinition.dns.domain }}
  paths:
    - /{{ $name }}
  {{- end }}
  {{- if $ingressDefinition.ssl.enabled }}
  tls:
    - secretName: {{ $name }}-certificate
      hosts:
      {{- if eq $ingressDefinition.dns.mode "wildcard" }}
        - {{ $name }}.{{ $ingressDefinition.dns.wildcard }}
      {{- else if eq $ingressDefinition.dns.mode "domain" }}
        - {{ $ingressDefinition.dns.domain }}
      {{- end }}
  {{- end }}
{{- $authSecret := "" -}}
{{- end }}

{{- define "helm-ingress.definition.withAuth" -}}
{{- $name := .name -}}
{{- $ingressDefinition := .ingressDefinition | default dict -}}
{{- $annotations := .annotations | default dict -}}
{{- $authSecret := .authSecret | default dict -}}
{{- if $authSecret -}}
{{- $annotations := deepCopy $authSecret | mustMerge $annotations  -}}
{{- end -}}
ingress:
  enabled: true
  {{- if $annotations }}
  annotations:
    {{- with $annotations }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- else }}
  annotations: {}
  {{- end }}
  hosts:
  {{- if eq $ingressDefinition.dns.mode "wildcard" }}
    - {{ $name }}.{{ $ingressDefinition.dns.wildcard }}
  {{- else if eq $ingressDefinition.dns.mode "domain" }}
    - {{ $ingressDefinition.dns.domain }}
  paths:
    - /{{ $name }}
  {{- end }}
  {{- if $ingressDefinition.ssl.enabled }}
  tls:
    - secretName: {{ $name }}-certificate
      hosts:
      {{- if eq $ingressDefinition.dns.mode "wildcard" }}
        - {{ $name }}.{{ $ingressDefinition.dns.wildcard }}
      {{- else if eq $ingressDefinition.dns.mode "domain" }}
        - {{ $ingressDefinition.dns.domain }}
      {{- end }}
  {{- end }}
{{- $authSecret := "" -}}
{{- end }}

{{- define "url-constructor" -}}
  {{- $name := .name -}}
  {{- $ingressDefinition := .ingress | default dict -}}
  {{- if $ingressDefinition.ssl.enabled }}
    {{- if eq $ingressDefinition.dns.mode "wildcard" }}
      {{- printf "https://%s.%s" $name $ingressDefinition.dns.wildcard }}
    {{- else if eq $ingressDefinition.dns.mode "domain" }}
      {{- printf "https://%s/%s" $ingressDefinition.dns.wildcard $name }}
    {{- end }}
  {{- else }}
    {{- if eq $ingressDefinition.dns.mode "wildcard" }}
      {{- printf "http://%s.%s" $name $ingressDefinition.dns.wildcard }}
    {{- else if eq $ingressDefinition.dns.mode "domain" }}
      {{- printf "http://%s/%s" $ingressDefinition.dns.wildcard $name }}
    {{- end }}
  {{- end }}
{{- end }}

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

{{- define "labels.namespace" -}}
  {{- print "{{ $labels.namespace }}" -}}
{{- end -}}

{{- define "labels.pod" -}}
  {{- print "{{ $labels.pod }}" -}}
{{- end -}}

{{- define "labels.name" -}}
  {{- print "{{ $labels.name }}" -}}
{{- end -}}

{{- define "labels.goldpinger_instance" -}}
  {{- print "{{ $labels.goldpinger_instance }}" -}}
{{- end -}}

{{ define "grafana.instance" -}}
  {{- print "{{ instance }}" -}}
{{- end -}}

{{/*
Logging
*/}}

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

{{- define "secrets.isVault" -}}
  {{- $prometheusSecretType := .Values.monitoring.prometheus.values.server.ingress.auth.type -}}
  {{- $grafanaSecretType := .Values.monitoring.grafana.values.passwordType -}}
  {{- and .Values.argocd.values.avp.enabled (or (eq $prometheusSecretType "vault") (eq $grafanaSecretType "vault")) }}
{{- end -}}
