# wireguard-operator

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Painless deployment of wireguard on Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| livenessProbe.httpGet.path | string | `"/healthz"` | Liveness health path |
| livenessProbe.httpGet.port | int | `8081` | Liveness probe port |
| livenessProbe.initialDelaySeconds | int | `15` | Tells the kubelet that it should wait `x` seconds before performing the first probe |
| livenessProbe.periodSeconds | int | `20` | Tell the kubelet that it should perform a liveness probe every `x` seconds |
| nameOverride | string | `""` | Override chart default name |
| readinessProbe.httpGet.path | string | `"/readyz"` | Readiness health path |
| readinessProbe.httpGet.port | int | `8081` | Readiness probe port |
| readinessProbe.initialDelaySeconds | int | `15` | Tells the kubelet that it should wait `x` seconds before performing the first probe |
| readinessProbe.periodSeconds | int | `20` | Tell the kubelet that it should perform a liveness probe every `x` seconds |
| resources.limits.cpu | string | `"500m"` | Cpu limits |
| resources.limits.memory | string | `"128Mi"` | Memory limits |
| resources.requests.cpu | string | `"10m"` | Cpu limits |
| resources.requests.memory | string | `"64Mi"` | Memory requests |
| securityContext | object | `{"runAsNonRoot":true}` | Deployment security context |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.10.0](https://github.com/norwoodj/helm-docs/releases/v1.10.0)