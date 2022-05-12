# Url constructor

The purpose of this documentation is to describe the helm url block constructor in helpers.tpl, it allow you to generate a classic Helm ingress block, you can see the code in the section below :

```yaml
{{- define "helm-ingress.definition" -}}
{{- $name := .name -}}
{{- $ingressDefinition := .ingressDefinition | default dict -}}
{{- $annotations := .annotations | default dict -}}
{{- $authSecret := .authSecret | default dict -}}
{{- if $authSecret }}
{{- $annotations := deepCopy $authSecret | mustMerge $annotations  -}}
{{- end }}
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
{{- end }}
```

The template is affected by ingress.ingressDefinition, selected ingress annotations (Traefik or Nginx) and the ingress name.

You are able to call the constructor this way :

```yaml
# Classic utilization
{{- include "helm-ingress.definition" (dict "name" <ingress-name> "ingressDefinition" .Values.ingress.ingressDefinition "annotations" .Values.ingress.traefik.values.ingressAnnotations) -}}
# w/ Basic auth
{{- $secretAuthValue := dict "nginx.ingress.kubernetes.io/auth-type" "basic" "nginx.ingress.kubernetes.io/auth-secret" "basic-auth" "nginx.ingress.kubernetes.io/auth-realm" "Authentication Required" -}}
{{- include "helm-ingress.definitionWithAuth" (dict "name" .Values.monitoring.prometheus.values.server.ingress.name "ingressDefinition" .Values.ingress.ingressDefinition "annotations" .Values.ingress.traefik.values.ingressAnnotations "authSecret" $secretAuthValue) }}
```

Here is a template block :

```yaml
# Classic utilization
ingress:
  enabled: true
  annotations: {}
  hosts:
    - test.your-cluster.domain.tld
  tls:
    - secretName: toto-certificate
      hosts:
        - test.your-cluster.domain.tld
# w/ Basic Auth
ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/auth-realm: Authentication Required
    nginx.ingress.kubernetes.io/auth-secret: basic-auth
    nginx.ingress.kubernetes.io/auth-type: basic
  hosts:
    - prometheus.your-cluster.domain.tld
  tls:
    - secretName: prometheus-certificate
      hosts:
        - prometheus.your-cluster.domain.tld
```
