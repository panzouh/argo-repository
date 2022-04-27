# Sync policies

If you want to generate your own charts, you should know how sync is implemented in this project. If you want to have further informations on ArgoCD Automated Sync Policy on the [official documentation](https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/).

## Operating sync values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | true | Allow you to activate selfHeal & prune mecanism |
| selfHeal | boolean | true | By default changes that are made to the live cluster will not trigger automated sync. This variable allow to enable automatic sync when the live cluster's state deviates from the state defined in Git |
| prune | boolean | true | By default (and as a safety mechanism), automated sync will not delete resources but on this chart it is enabled by default |

## Create templates

In order to create templates, you should know if the chart will need to create it's own namespace.

### With createNamespace == true

Will trigger this section of the helpers.tpl :

```yaml
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
```

In your template it should look like this :

```yaml
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: an-app-with-namespace-creation
  namespace: {{ .Values.argocd.namespace }}
  finalizers:
  {{- include "argocd.applications.finalizers" . | nindent 4 }}
spec:
  {{- template "cluster.syncPolicy.default" . }}
  destination:
    namespace: my-namespace-to-create
    server: https://kubernetes.default.svc
```

### With createNamespace == false

```yaml
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
```

In your template it should look like this :

```yaml
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: another-app-without-namespace-creation
  namespace: {{ .Values.argocd.namespace }}
  finalizers:
  {{- include "argocd.applications.finalizers" . | nindent 4 }}
spec:
  {{- template "cluster.syncPolicy.withoutNamespace" . }}
  destination:
    server: https://kubernetes.default.svc
```
