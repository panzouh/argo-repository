# users

A Helm chart for Kubernetes
![Version: 0.0.0-dev](https://img.shields.io/badge/Version-0.0.0--dev-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| clusterRoles | list | `[]` | Create a Cluster role watch [Value file](./values.yaml), creating a cluster role does not allow you to customize it. It must be created first. |
| nameOverride | string | `""` | Override chart default name |
| namespaceRoles | list | `[]` | Create a Namespace role watch [Value file](./values.yaml)  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0) `docker run --rm --volume "$(pwd):/helm-docs"  jnorwood/helm-docs:latest`.
