# Ingress constructor

The purpose of this documentation is to describe the helm ingress block constructor in helpers.tpl, it allow you to generate a classic Helm ingress block, you can see the code in the section below :

```yaml
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
```

The template is affected by ingress.ingressDefinition, selected ingress annotations (Traefik or Nginx) and the ingress name.

You are able to call the constructor this way :

```yaml
url: {{ include "url-constructor" (dict "name" <ingress-name> "ingress" .Values.ingress.ingressDefinition) }}
```

Here is a template block :

```yaml
# /w dict "name" == test
# ingressDefinition:
#   ssl:
#     strictTLS: false
#     enabled: true
#   dns:
#     mode: wildcard # domain|wildcard
#     wildcard: your-cluster.domain.tld
#     domain: domain.tld
url: https://test.your-cluster.domain.tld
```
