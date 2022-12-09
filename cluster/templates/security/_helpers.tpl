{{- define "secrets.isVault" -}}
    {{- $prometheusSecretType := .Values.monitoring.prometheus.values.server.ingress.auth.type -}}
    {{- $grafanaSecretType := .Values.monitoring.grafana.values.auth.passwordType -}}
    {{- $minioSecretType := .Values.minio.values.auth.passwordType -}}
    {{- and .Values.argocd.values.plugins.avp.enabled (or (eq $prometheusSecretType "vault") (eq $grafanaSecretType "vault") (eq $minioSecretType "vault")) }}
{{- end -}}