# Traefik Chart

Traefik is an open-source Edge Router that makes publishing your services a fun and easy experience. It receives requests on behalf of your system and finds out which components are responsible for handling them.

What sets Traefik apart, besides its many features, is that it automatically discovers the right configuration for your services. The magic happens when Traefik inspects your infrastructure, where it finds relevant information and discovers which service serves which request.

Traefik is natively compliant with every major cluster technology, such as Kubernetes, Docker, Docker Swarm, AWS, Mesos, Marathon, and the list goes on; and can handle many at the same time. (It even works for legacy software running on bare metal.)

With Traefik, there is no need to maintain and synchronize a separate configuration file: everything happens automatically, in real time (no restarts, no connection interruptions). With Traefik, you spend time developing and deploying new features to your system, not on configuring and maintaining its working state.

Developing Traefik, our main goal is to make it simple to use, and we're sure you'll enjoy it.

-- The Traefik Maintainer Team

## Operating values

By default, there is no ingress enabled. You can activate either Traefik or Nginx, if you decide to activate both there is a mecanism that will deactivate them. This chart is based on [Traefik v2](https://doc.traefik.io/traefik/getting-started/install-traefik/#use-the-helm-chart). By default Traefik is installed on "ingress-traefik" namespace you can modify it on helpers.tpl, by modifying this section of code :

```yaml
{{- define "ingress.namespace" }}
  {{- if or (eq (include "ingress.isTraefik" .) "true") (eq (include "ingress.isNginx" .) "true") }}
    {{- if and (eq (include "ingress.isTraefik" .) "true") (eq (include "ingress.isNginx" .) "true") }}
      {{- print "disabled" }}
    {{- else if eq (include "ingress.isTraefik" .) "true" }}
      {{- print "ingress-traefik" }} # Move it here
    {{- else if eq (include "ingress.isNginx" .) "true" }}
      {{- print "ingress-nginx" }}
    {{- end }}
  {{- else }}
    {{- print "disabled" }}
  {{- end }}
{{- end }}
```

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable Traefik chart |
| chart.repo | string | <https://helm.traefik.io/traefik> | Traefik helm repository |
| chart.name | string | traefik | Traefik chart name |
| chart.version | string | 10.15.0 | Traefik chart version |
| values | dictionnary | None | Watch section below |

### Chart values (values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitor | boolean | false | Enable prometheus metrics scraping, you will need to enable Prometheus as well |
| service.type | string | LoadBalancer | Can be either Loadbalancer or NodePort |
| service.LoadbalancerIps | list | None | Only for BareMetal support |
| ingressAnnotations | dictionnary | None | Allow to add ingress annotations manually |
