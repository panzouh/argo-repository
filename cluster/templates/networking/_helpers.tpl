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

{{- define "helm-ingress.defaultSpec" -}}
{{- $name := .name -}}
{{- $ingressDefinition := .ingressDefinition | default dict -}}
{{- $annotations := .annotations | default dict -}}
{{- $authSecret := .authSecret | default dict -}}
{{- if $authSecret -}}
{{- end -}}
ingress:
  {{- if $ingressDefinition.className }}
  ingressClassName: {{ $ingressDefinition.className }}
  {{- end }}
  enabled: true
  {{- if $annotations }}
  annotations:
    {{- if $authSecret }}
      {{- with merge $authSecret $annotations }}
        {{- toYaml . | nindent 4 }}
      {{- end }}
    {{- else }}
    {{- with merge $annotations }}
        {{- toYaml . | nindent 4 }}
    {{- end }}
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
{{- end }}

{{- define "helm-ingress.alternateSpec" -}}
{{- $name := .name -}}
{{- $ingressDefinition := .ingressDefinition | default dict -}}
{{- $annotations := .annotations | default dict -}}
{{- $authSecret := .authSecret | default dict -}}
{{- if $authSecret -}}
{{- end -}}
ingress:
  enabled: true
  {{- if $ingressDefinition.className }}
  ingressClassName: {{ $ingressDefinition.className }}
  {{- end }}
  {{- if $annotations }}
  annotations:
    {{- if $authSecret }}
      {{- with merge $authSecret $annotations }}
        {{- toYaml . | nindent 4 }}
      {{- end }}
    {{- else }}
    {{- with merge $annotations }}
        {{- toYaml . | nindent 4 }}
    {{- end }}
    {{- end }}
  {{- else }}
  annotations: {}
  {{- end }}
  hosts:
  {{- if eq $ingressDefinition.dns.mode "wildcard" }}
    - host: {{ $name }}.{{ $ingressDefinition.dns.wildcard }}
      paths:
        - path: /
          pathType: Prefix
  {{- else if eq $ingressDefinition.dns.mode "domain" }}
    - host: {{ $ingressDefinition.dns.domain }}
      paths:
        - path: /{{ $name }}
          pathType: Prefix
        - {{ $name }}
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
{{- end }}

{{- define "helm-ingress.namedSpec" -}}
{{- $ingressDict := .ingressDict -}}
{{- $name := .name -}}
{{- $ingressDefinition := .ingressDefinition | default dict -}}
{{- $annotations := .annotations | default dict -}}
{{- $authSecret := .authSecret | default dict -}}
{{- if $authSecret -}}
{{- end -}}
{{ $ingressDict }}:
  enabled: true
  {{- if $annotations }}
  annotations:
    {{- if $authSecret }}
      {{- with merge $authSecret $annotations }}
        {{- toYaml . | nindent 4 }}
      {{- end }}
    {{- else }}
    {{- with merge $annotations }}
        {{- toYaml . | nindent 4 }}
    {{- end }}
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