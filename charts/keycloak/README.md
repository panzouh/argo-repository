# keycloak

A chart to manage various keycloak ressources

![Version: 0.0.0-dev](https://img.shields.io/badge/Version-0.0.0--dev-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| clients | list | `[]` | Watch [Value file](values.yaml) for examples. |
| keycloakConfig.externalAccess.enabled | bool | `true` | Keycloak instance access (creates ingress) |
| keycloakConfig.externalAccess.host | string | `"danstonkube.fr"` | Keycloak ingress host |
| keycloakConfig.instances | int | `1` | Keycloak instance replicas |
| keycloakConfig.labels | object | `{"mylabel":"label1"}` | Keycloak instance labels |
| keycloakConfig.name | string | `"dtk"` | Keycloak instance name |
| keycloakConfig.storageClassName | string | `"local"` | Keycloak instance storage class  |
| nameOverride | string | `""` | Override chart default name |
| realms | list | `[]` | Watch [Value file](values.yaml) for examples. |
| users | list | `[]` | Watch [Value file](values.yaml) for examples. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0) `docker run --rm --volume "$(pwd):/helm-docs"  jnorwood/helm-docs:latest`.