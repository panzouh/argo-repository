# Nginx Chart

NGINX Ingress Controller is a best-in-class traffic management solution for cloud‑native apps in Kubernetes and containerized environments.

## Operating values

By default, there is no ingress enabled. You can activate either Traefik or Nginx, if you decide to activate both there is a mecanism that will deactivate them. This chart is based on [Nginx community](https://kubernetes.github.io/ingress-nginx/deploy/). By default Nginx is installed on "ingress-traefik" namespace you can modify it on helpers.tpl, by modifying this section of code :

```yaml
{{- define "ingress.namespace" }}
  {{- if or (eq (include "ingress.isTraefik" .) "true") (eq (include "ingress.isNginx" .) "true") }}
    {{- if and (eq (include "ingress.isTraefik" .) "true") (eq (include "ingress.isNginx" .) "true") }}
      {{- print "disabled" }}
    {{- else if eq (include "ingress.isTraefik" .) "true" }}
      {{- print "ingress-traefik" }}
    {{- else if eq (include "ingress.isNginx" .) "true" }}
      {{- print "ingress-nginx" }} # Move it here
    {{- end }}
  {{- else }}
    {{- print "disabled" }}
  {{- end }}
{{- end }}
```

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable Nginx chart |
| chart.repo | string | <https://kubernetes.github.io/ingress-nginx> | Nginx helm repository |
| chart.name | string | ingress-nginx | Nginx chart name |
| chart.version | string | 4.0.18 | Nginx chart version |
| values | dictionnary | None | Watch section below |

### Chart values (values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitor | boolean | false | Enable prometheus metrics scraping, you will need to enable Prometheus as well |
| service.type | string | LoadBalancer | Can be either Loadbalancer or NodePort |
| service.LoadbalancerIps | list | None | Only for BareMetal support |
| ingressAnnotations | dictionnary | None | Allow to add ingress annotations manually |
