{{/*
Default
*/}}

{{- define "accessModes.template" -}}
  {{- if eq .Values.default.accessModes "RWO" -}}
    {{- print "ReadWriteOnce" }}
  {{- else if eq .Values.default.accessModes "RWX" -}}
    {{- print "ReadWriteMany" }}
  {{- end }}
{{- end -}}

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
