# ArgoCD Cluster Chart

A Must Have Apps Cluster Management Provided by DTK (danstonkube.fr)

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1](https://img.shields.io/badge/AppVersion-0.1-informational?style=flat-square)

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Panzouh | <weinpanzy@gmail.com> |  |

## Index

1. [General](#general)
2. [Integration](#integration)
3. [Logging](#logging)
4. [Management](#management)
5. [Monitoring](#monitoring)
6. [Networking](#networking)
7. [Security](#security)

## General

### Debug template

If you want to do some debug you can modify the [debug-file](./templates/debug-tpl.yml) template to try some of your functions. To generate the debug file, the command below should work like a charm :

```sh
helm template <repository-git-dir>/cluster --set debug=true
```

### Default values

Because some vars are generic to other charts, some are defined by default.

#### Operating default values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| default.enabled | bool | `false` | Enable default charts (ArgoCD, Namespace configurator operator & Namespace configuration) |
| default.smtpServer | string | `"0.0.0.0:25"` | Smtp server to configure notifications :warning: not working yet :warning: |
| default.storageClass | string | `""` | Define storageClass in order to persistence to work |

#### Operating proxies values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| proxies.enabled | bool | `false` | Enable proxy support for all charts |
| proxies.noProxy | string | `""` | Define noProxy value should be `noProxy: .cluster.local,.svc,podsCIDR,svcCIDR` |
| proxies.value | string | `""` | Define http(s) proxy |

#### Sync policies

If you want to generate your own charts in this repository, you should know how sync is implemented in this project. If you want to have further informations on ArgoCD Automated Sync Policy on the [official documentation](https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/).

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| sync.enabled | bool | `true` | Allow you to activate auto-sync w/ selfHeal & prune mecanism |
| sync.prune | bool | `true` | By default (and as a safety mechanism), automated sync will not delete resources but on this chart it is enabled by default |
| sync.selfHeal | bool | `true` | y default changes that are made to the live cluster will not trigger automated sync. This variable allow to enable automatic sync when the live cluster's state deviates from the state defined in Git |

## Tools

### Integration

By default, the integration stack is not enabled. You can activate either by setting every charts to `<chart-name>.enabled: true` or `default.enabled: true`. It will enable all the default stack including ArgoCD & Namespace configurator operator).

#### ArgoCD

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argocd.chart.name | string | `"argo-cd"` | Chart name |
| argocd.chart.repo | string | `"https://argoproj.github.io/argo-helm"` | Helm repository |
| argocd.chart.version | string | `"4.5.0"` | Chart version |
| argocd.enabled | bool | `false` | Enable ArgoCD chart |
| argocd.namespace | string | `"argocd"` | Destination namespace & Applications source namespace |
| argocd.values.avp.auth.path | string | `"auth/kubernetes"` |  |
| argocd.values.avp.auth.type | string | `"k8s"` | AVP auth type |
| argocd.values.avp.auth.vaultUrl | string | `"https://your-vault.domain.tld"` | Only if `argocd.values.avp.enabled=true` & `vault.enabled=false` for external Vault support only |
| argocd.values.avp.enabled | bool | `false` | Enable AVP extension, watch [AVP Documention](../docs/security/avp-documention.md) first |
| argocd.values.avp.saName | string | `"avp"` | Tell to Argo which SA to create |
| argocd.values.avp.version | string | `"1.11.0"` | AVP version to install |
| argocd.values.enableAlternateHelmPlugin | bool | `true` |  |
| argocd.values.ha | bool | `true` | Enable ArgoCD on HA mode |
| argocd.values.ingress.enabled | bool | `true` | Enable ArgoCD UI ingress |
| argocd.values.ingress.name | string | `"argocd"` | ArgoCD ingress name or path (weither it is an ingress wildcard or domain |
| argocd.values.insecure | bool | `false` | Enable ArgoCD all the way TLS, will be deactivated if ingress are enabled |
| argocd.values.logLevel | string | `"debug"` | Application controller logLevel  |
| argocd.values.monitor | bool | `false` | Enable prometheus metrics scraping, you will need to enable Prometheus as well |
| argocd.values.repositories | list | `[]` | Registered repositories, watch section below :warning: Credentials creation not handled yet :warning: |

##### Repositories

###### Without authentication

```yaml
repositories:
  - url: https://your-repository.domain.tld/a-repo.git
```

###### With user/password authentication

```yaml
repositories:
  - url: https://your-repository.domain.tld/a/repository.git
    passwordSecret:
    # Needs to be created first !
      name: gitlab-secret
      key: password
    usernameSecret:
    # Needs to be created first !
      name: gitlab-secret
      key: username 
```

###### With SSH private key authentication

```yaml
repositories:
  - url: git@your-repository.domain.tld:a:repository
    sshPrivateKeySecret:
    # Needs to be created first !
      name: my-ssh-key
      key: sshPrivateKey
```

#### Gitlab runners

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| gitlabRunners.chart.name | string | `"gitlab-runner"` | Chart name |
| gitlabRunners.chart.repo | string | `"https://charts.gitlab.io"` | Gitlab runners Helm repository |
| gitlabRunners.chart.version | string | `"0.41.0"` | Chart version |
| gitlabRunners.values | object | `{}` | Create runner watch section below |

##### Runner lean example

```yaml
gitlabRunners:
  values:
    - runnerName: runner-a
      runnerToken: "<runner-token>"
      runnerTags: "ci, test"
      gitlabUrl: "https://git.domain.tld"
```

##### Runner full example

```yaml
gitlabRunners:
  values:
    - runnerName: runner-a
      runnerNamespace: runner-a-namespace # Value not mandatory, if not defined default is gitlab
      runnerToken: "<runner-token>"
      runnerTags: "ci, test"
      dockerVersion: "20.03.12" # Value not mandatory, if not defined default is "19.03.12"
      gitlabUrl: "https://git.domain.tld"
      imagePullPolicy: Always # Value not mandatory, if not defined default is "IfNotPresent"
      replicas: 1 # Value not mandatory, if not defined default is "1"
      isPrivileged: false # Value not mandatory, if not defined default is false
```

#### Namespace configuration operator

The namespace-configuration-operator is a project hosted by RedHat. It helps keeping configurations related to Users, Groups and Namespaces aligned with one of more policies specified as a CRs. The purpose is to provide the foundational building block to create an end-to-end onboarding process. By onboarding process we mean all the provisioning steps needed to a developer team working on one or more applications to OpenShift. This usually involves configuring resources such as: Groups, RoleBindings, Namespaces, ResourceQuotas, NetworkPolicies, EgressNetworkPolicies, etc... Depending on the specific environment the list could continue. Naturally such a process should be as automatic and scalable as possible.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| namespaceConfiguratorOperator.chart.name | string | `"namespace-configuration-operator"` | Chart name |
| namespaceConfiguratorOperator.chart.repo | string | `"https://redhat-cop.github.io/namespace-configuration-operator"` | Helm repository |
| namespaceConfiguratorOperator.chart.version | string | `"v1.2.2"` | Chart version |
| namespaceConfiguratorOperator.enabled | bool | `false` | Enable Namespace configuration operator chart |
| namespaceConfiguratorOperator.namespace | string | `"namespace-configuration"` | Destination namespace |
| namespaceConfiguratorOperator.values.monitor | bool | `false` | Enable prometheus metrics scraping, you will need to enable Prometheus as well |

#### Namespace configuration

Namespace configuration is a chart hosted on this repository, you can retrieve templates [here](../charts/namespaceConfiguration). It is based on the Namespace configuration operator hosted by RedHat.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| namespaceConfiguration.chart.path | string | `"charts/namespace-configuration"` | Chart path on repository |
| namespaceConfiguration.chart.repo | string | `"https://github.com/panzouh/argo-repository.git"` | Helm repository (This own repository) |
| namespaceConfiguration.chart.targetRevision | string | `"HEAD"` | Chart target revision, using `HEAD` allow you to use the same version of your cluster spec |
| namespaceConfiguration.enabled | bool | `false` | Enable Namespace configuration chart |
| namespaceConfiguration.namespace | string | `"namespace-configurator"` | Destination namespace |
| namespaceConfiguration.values.isolatedNetworkPolicy.clusterCIDRs | list | `[]` | You will need to specify podCIDR & serviceCIDR you can get it by running `kubectl cluster-info dump | grep -m 1 service-cluster-ip-range` & `kubectl cluster-info dump | grep -m 1 cluster-cidr` |
| namespaceConfiguration.values.isolatedNetworkPolicy.enabled | bool | `false` | Create the isolated networkPolicy (Full access on current namespace, access outside the cluster, accessible by ingress & monitoring, restricted to every other namespaces) |
| namespaceConfiguration.values.networkPolicies | list | `[]` | Create *n* network policies |
| namespaceConfiguration.values.quotas | list | `[]` | Create *n* resources quotas so your users does not overconsume compute resources |

##### Quota example

```yaml
quotas:
  - quotaName: small-size
    matchLabels:
      size: small
    requestMem: 4Gi
    requestCPU: 2
    requestsPVC: 100Gi
    totalPVC: 5
    requestsEmptyDirs: 5Gi
```

##### Network Policy example

```yaml
networkPolicies:
  - policyName: demo
    matchLabels:
      policy: demo
    policies:
      - name: allow-all-egress
        type: Egress
        to: []
        podSelector: {}
      - name: a-very-complicated-rule
        type: Ingress
        podSelector:
          app: a-kubernetes-app
        from:
          - namespaceSelector:
              matchLabels:
                a: b
          - namespaceSelector:
              matchLabels: {}
          - podSelector:
              matchLabels:
                b: c
          - ipBlock:
              cidr: 192.168.0.0/24
              except:
                - 192.168.1.1
          - ipBlock:
              cidr: 192.168.0.0/24
```

#### Olm

Operator Lifecycle Manager (OLM) helps users install, update, and manage the lifecycle of Kubernetes native applications (Operators) and their associated services running across their Kubernetes clusters.

| Key | Type | Default | Description |
|-----|------|---------|-------------|

### Logging

You should note that you can either activate Loki & Promtail stack or ECK and Kibana / Elasticsearch.
For example, To set up Loki, you will have to activate Loki and Promtail, the two being interdependent. Note that if you activate Loki, Promtail and the ECK suite, a safety mechanism will prevent the installation.

#### ECK & Others

##### ECK

Elastic Cloud on Kubernetes makes it easy to run Elasticsearch and Kibana on Kubernetes: configuration, upgrades, snapshots, scaling, high availability & security.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| logging.eck.chart.name | string | `"eck-operator"` | Chart name |
| logging.eck.chart.repo | string | `"https://helm.elastic.co"` | Helm repository |
| logging.eck.chart.version | string | `"2.2.0"` | Chart version |
| logging.eck.enabled | bool | `false` | Enable ECK chart, installing [OLM](https://github.com/operator-framework/operator-lifecycle-manager) is mandantory |
| logging.eck.values.monitor | bool | `false` | Enable prometheus metrics scraping, you will need to enable Prometheus as well |
| logging.eck.values.telemetryEnabled | bool | `true` | Enable telemetry |
| logging.eck.values.verbosity | string | `"warning"` | Operator verbosity |
| logging.eck.values.watchNamespaces | list | `["elastic-system"]` | Filter namespaces to watch you can leave it empty to watch all namespaces |
| logging.eckCrds.chart.name | string | `"eck-operator-crds"` | Chart name |
| logging.eckCrds.chart.repo | string | `"https://helm.elastic.co"` | Helm repository |
| logging.eckCrds.chart.version | string | `"2.2.0"` | Chart version |
| logging.eckCrds.values | object | `{}` | No specific values needs to be specified |

##### ECK Crds

Elastic Cloud on Kubernetes makes it easy to run Elasticsearch and Kibana on Kubernetes: configuration, upgrades, snapshots, scaling, high availability & security.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| logging.eckCrds.chart.name | string | `"eck-operator-crds"` | Chart name |
| logging.eckCrds.chart.repo | string | `"https://helm.elastic.co"` | Helm repository |
| logging.eckCrds.chart.version | string | `"2.2.0"` | Chart version |
| logging.eckCrds.values | object | `{}` | No specific values needs to be specified |

##### ECK Tpl

ECK Tpl is a custom chart, which, as its name suggests, allows you to simply create Kibana / Elasticearch & Fluentd resources.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| logging.eckTpl.chart.path | string | `"charts/eck-tpl"` | Chart path |
| logging.eckTpl.chart.repo | string | `"https://github.com/panzouh/argo-repository.git"` | Helm repository (This own repository) |
| logging.eckTpl.chart.targetRevision | string | `"HEAD"` | Chart target revision, using `HEAD` allow you to use the same version of your cluster spec |
| logging.eckTpl.enabled | bool | `false` | Enable ECK Tpl chart |
| logging.eckTpl.values.clusterSpec.elasticsearch.config | object | `{}` | Elasticsearch configuration |
| logging.eckTpl.values.clusterSpec.elasticsearch.count | int | `3` | Elasticsearch instance count |
| logging.eckTpl.values.clusterSpec.elasticsearch.pvcSize | string | `"50Gi"` | Elasticsearch PVC size, you will need to define a StorageClass in `default.storageClass` |
| logging.eckTpl.values.clusterSpec.elasticsearch.serviceType | string | `"ClusterIP"` | Elasticsearch service type can be either `Loadbalancer`, `ClusterIP` or `NodePort` |
| logging.eckTpl.values.clusterSpec.elasticsearch.tls.enabled | bool | `true` | Enable TLS Generation |
| logging.eckTpl.values.clusterSpec.elasticsearch.tls.subjectAltNames | list | `[]` | To use a custom domain name and / or IP with the self-signed certificate `clusterSpec.elasticsearch.serviceType` must be `LoadBalancer` & must be not empty |
| logging.eckTpl.values.clusterSpec.filebeat.config | object | `{}` |  |
| logging.eckTpl.values.clusterSpec.filebeat.enabled | bool | `false` | Enable Filebeat instances |
| logging.eckTpl.values.clusterSpec.filebeat.mounts | list | `[]` | Set Filebeat mounts |
| logging.eckTpl.values.clusterSpec.kibana.config | object | `{}` | Kibana configuration |
| logging.eckTpl.values.clusterSpec.kibana.count | int | `1` | Kibana instance count |
| logging.eckTpl.values.clusterSpec.kibana.ingress.enabled | bool | `true` | Enable Kibana UI Ingress |
| logging.eckTpl.values.clusterSpec.kibana.ingress.name | string | `"kibana"` | Kibana ingress name or path (weither it is an ingress wildcard or domain) |
| logging.eckTpl.values.clusterSpec.name | string | `"eck-cluster"` | ECK Cluster name |
| logging.eckTpl.values.clusterSpec.version | string | `"8.2.0"` | ECK Cluster version |

#### Loki & Promtail

##### Loki

Loki is a horizontally scalable, highly available, multi-tenant log aggregation system inspired by Prometheus. It is designed to be very cost effective and easy to operate. It does not index the contents of the logs, but rather a set of labels for each log stream.
The Loki project was started at Grafana Labs in 2018, and announced at KubeCon Seattle. Loki is released under the AGPLv3 license.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| logging.loki.chart.name | string | `"loki"` | Chart name |
| logging.loki.chart.repo | string | `"https://grafana.github.io/helm-charts"` | Helm repository |
| logging.loki.chart.version | string | `"2.10.3"` | Chart version |
| logging.loki.enabled | bool | `false` | Enable Loki chart |
| logging.loki.values.enableGrafanaDashboard | bool | `true` | Enable a Grafana specific dashboard, you will need to have Grafana enabled |
| logging.loki.values.monitor | bool | `false` | Enable prometheus metrics scraping, you will need to enable Prometheus as well |
| logging.loki.values.pvcSize | string | `"100Gi"` | Loki PVC size, you will need to define a StorageClass in `default.storageClass` |

##### Promtail

Promtail is an agent which ships the contents of local logs to a Loki instance.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| logging.promtail.chart.name | string | `"promtail"` | Chart name |
| logging.promtail.chart.repo | string | `"https://grafana.github.io/helm-charts"` | Helm repository |
| logging.promtail.chart.version | string | `"3.11.0"` | Chart version |
| logging.promtail.enabled | bool | `false` | Enable Promtail chart |
| logging.promtail.values.installOnControllPlane | bool | `true` | Enable Promtail on the controll plane |
| logging.promtail.values.runtimeLogs | string | `"/var/lib/docker/containers"` | Path to runtime containers |

### Management

#### Rancher

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| rancher.chart.name | string | `"rancher"` | Chart name |
| rancher.chart.repo | string | `"https://releases.rancher.com/server-charts/stable"` | Helm repository |
| rancher.chart.version | string | `"2.6.5"` | Chart version |
| rancher.enabled | bool | `false` | Enable Prometheus chart |
| rancher.namespace | string | `"cattle-system"` | Destination namespace |
| rancher.values.bootstrapPassword | string | `"changeme"` | Only for bootstrapp, if the application is exposed consider changing it  |
| rancher.values.ingress.enabled | bool | `false` | Enable Rancher ingress UI |
| rancher.values.ingress.name | string | `"rancher"` | Rancher ingress name or path (weither it is an ingress wildcard or domain) |
| rancher.values.replicas | int | `1` | Rancher replicas |

### Monitoring

#### Define Monitoring global variables

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitoring.namespace | string | `"monitoring"` | Monitoring destination namespace |

#### Blackbox exporter

The Blackbox exporter allows blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP, ICMP and gRPC.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitoring.blackboxExporter.chart.name | string | `"prometheus-blackbox-exporter"` | Chart name |
| monitoring.blackboxExporter.chart.repo | string | `"https://prometheus-community.github.io/helm-charts"` | Helm repository |
| monitoring.blackboxExporter.chart.version | string | `"4.10.4"` | Chart version |
| monitoring.blackboxExporter.enabled | bool | `false` | Enable Blackbox exporter chart |
| monitoring.blackboxExporter.values.enableGrafanaDashboard | bool | `false` | Enable a Grafana specific dashboard, you will need to have Grafana enabled |
| monitoring.blackboxExporter.values.enablePrometheusRules | bool | `false` | Enable prometheus default Prometheus rules (Will be announced in a future release) |
| monitoring.blackboxExporter.values.scrapeUrls | list | `[]` | Create Url get configs accepted code are `200` & `403` (If you are using authentication) |

##### Scrape Url example

```yaml
scrapeUrls:
  - https://an-app.domain.tld
  - https://another-app.domain.tld
```

#### Discord alerting

The goal of this applications is to serve as a customizable Discord webhook for Alertmanager.
With its default configuration, the application behaves similarly to [benjojo's alertmanager-discord](https://github.com/benjojo/alertmanager-discord), aggregating alerts by status and sending them with a colored embed accordingly. Adding to that, we're able to route alerts to multiple channels in a single instance and group by `alertname`.
However, there are a few other things you might want in a production environment, such as:

- Define Discord Roles to be mentioned when:
  - There are too many firing alerts;
  - Any of the alerts contains a specified severity value, like "critical" or "disaster";
- Change Embed appearance to provide better visual clues of what is going on;
- Define a priority to each severity, so the alerts are always shown in an expected order.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitoring.discord.chart.name | string | `"alertmanager-discord"` | Chart name |
| monitoring.discord.chart.repo | string | `"https://masgustavos.github.io/helm"` | Helm repository |
| monitoring.discord.chart.version | string | `"0.0.5"` | Chart version |
| monitoring.discord.enabled | bool | `false` | Enable Discord alerting hooks, you will need to enable Prometheus & Alertmanager as well |
| monitoring.discord.values.channels | object | `{}` | Channels list, watch section below for more informations |
| monitoring.discord.values.rolesToMention | list | `[]` | Roles to mention in discord you can obtain the id by typing `\@Role_Name` in discord's chat |

#### Fio

The purpose of this helm chart is to expose Fio metrics to Prometheus, it is writen in Golang, you can find the official repository [here](https://gitlab.com/panzouh/fio-exportaire).

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitoring.fio.chart.path | string | `"charts/fio"` | Chart path |
| monitoring.fio.chart.repo | string | `"https://github.com/panzouh/argo-repository.git"` | Helm repository (This own repository) |
| monitoring.fio.chart.targetRevision | string | `"HEAD"` | Chart target revision, using `HEAD` allow you to use the same version of your cluster spec |
| monitoring.fio.enabled | bool | `false` | Enable Fio chart you will need to enable Prometheus as well |
| monitoring.fio.values.enableGrafanaDashboard | bool | `true` | fio Enable a Grafana specific dashboard, you will need to have Grafana enabled |
| monitoring.fio.values.installOnControllPlane | bool | `true` | Enable Fio exporter on the controll plane, by default Prometheus scraping is enabled |

#### Goldpinger

Goldpinger makes calls between its instances for visibility and alerting.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitoring.goldpinger.chart.name | string | `"goldpinger"` | Chart name |
| monitoring.goldpinger.chart.repo | string | `"https://okgolove.github.io/helm-charts"` | Helm repository |
| monitoring.goldpinger.chart.version | string | `"5.1.0"` | Chart version |
| monitoring.goldpinger.enabled | bool | `false` | Enable Goldpinger chart |
| monitoring.goldpinger.values.enableGrafanaDashboard | bool | `true` | Enable a Grafana specific dashboard, you will need to have Grafana enabled |
| monitoring.goldpinger.values.enablePrometheusRules | bool | `true` | Enable prometheus default Prometheus rules (not ready yet) |

#### Grafana

Grafana allows you to query, visualize, alert on and understand your metrics no matter where they are stored. Create, explore, and share dashboards with your team and foster a data-driven culture:

- **Visualizations:** Fast and flexible client side graphs with a multitude of options. Panel plugins offer many different ways to visualize metrics and logs.
- **Dynamic Dashboards:** Create dynamic & reusable dashboards with template variables that appear as dropdowns at the top of the dashboard.
- **Explore Metrics:** Explore your data through ad-hoc queries and dynamic drilldown. Split view and compare different time ranges, queries and data sources side by side.
- **Explore Logs:** Experience the magic of switching from metrics to logs with preserved label filters. Quickly search through all your logs or streaming them live.
- **Alerting:** Visually define alert rules for your most important metrics. Grafana will continuously evaluate and send notifications to systems like Slack, PagerDuty, VictorOps, OpsGenie.
- **Mixed Data Sources:** Mix different data sources in the same graph! You can specify a data source on a per-query basis. This works for even custom datasources.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitoring.grafana.chart.name | string | `"grafana"` | Chart name |
| monitoring.grafana.chart.repo | string | `"https://grafana.github.io/helm-charts"` | Helm repository |
| monitoring.grafana.chart.version | string | `"6.29.2"` | Chart version |
| monitoring.grafana.enabled | bool | `false` | Enable Grafana chart |
| monitoring.grafana.values.adminPassword | string | `"changeme"` | Grafana default admin password, only for raw type :warning: insecure :warning: |
| monitoring.grafana.values.adminUser | string | `"admin"` | Grafana default admin username, only for raw type :warning: insecure :warning |
| monitoring.grafana.values.avpPath | string | `"avp/data/grafana"` | Grafana username and password path on Vault if your kv-v2 path is `avp`, your avp path will be `avp/data/grafana` in order to put secrets here you should pass `vault kv put avp/grafana username=admin password=changeme`, only for `passwordType: vault` |
| monitoring.grafana.values.customDashboards | object | `{}` | Create Grafana custom dashoards (Json Formated), not available at the moment |
| monitoring.grafana.values.customDashboardsGNET | object | `{}` | Create Grafana Dashboard available on Grafana Net, not available at the moment |
| monitoring.grafana.values.ingress.enabled | bool | `true` | Enable Grafana UI ingress |
| monitoring.grafana.values.ingress.name | string | `"grafana"` | Grafana ingress name or path (weither it is an ingress wildcard or domain) |
| monitoring.grafana.values.passwordKey | string | `"password"` | Configure password key in vault kv-v2 secret, only for `passwordType: vault` |
| monitoring.grafana.values.passwordType | string | `"raw"` | Can be either raw or vault in order to pull password from Vault, you will need to enable AVP in ArgoCD with `.Values.argocd.values.avp.enabled=true` |
| monitoring.grafana.values.pvcSize | string | `"10Gi"` | Grafana PVC size, you will need to define a StorageClass in `default.storageClass` |
| monitoring.grafana.values.userKey | string | `"username"` | Configure username key in vault kv-v2 secret, only for `passwordType: vault` |

#### Prometheus MsTeams alerting

Prometheus MS Teams chart allow you to write alerts on Microsoft Teams. In order to do that you will need to create a webhook on Teams ([Documentation](https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook))

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitoring.prometheusMsTeams.chart.name | string | `"prometheus-msteams"` | Chart name |
| monitoring.prometheusMsTeams.chart.repo | string | `"https://prometheus-msteams.github.io/prometheus-msteams/"` | Helm repository |
| monitoring.prometheusMsTeams.chart.version | string | `"1.3.0"` | Chart version |
| monitoring.prometheusMsTeams.enabled | bool | `false` | Enable Prometheus Ms Teams Alert chart, you will need to enable Prometheus & Alertmanager as well |
| monitoring.prometheusMsTeams.values.hooks | list | `[]` | Hooks list, watch section below for more informations |
| monitoring.prometheusMsTeams.values.monitor | bool | `false` | Enable Prometheus scraping |

##### Add Hooks

First you will need to create an incoming webhook on teams, once you have it you will have to add the hook like this :

```yaml
hooks:
  - myhook: https://office.com/not/a/working/hook
```

In order to enable it in Alertmanager, add this section of code in `monitoring.prometheus.values.alertmanager.configurationFile` :

```yaml
configurationFile:
  route:
    group_by: ['instance', 'severity']
    group_wait: 5m
    group_interval: 10m
    repeat_interval: 10m
    receiver: "myhook"
  receivers:
    - name: updates
      webhook_configs:
        - url: "http://prometheus-msteams.<prometheus-namespace>:2000/myhook"
        # If you did not changed it default is monitoring
```

#### Prometheus

Prometheus, a [Cloud Native Computing Foundation](https://cncf.io/) project, is a systems and service monitoring system. It collects metrics
from configured targets at given intervals, evaluates rule expressions,
displays the results, and can trigger alerts when specified conditions are observed.

The features that distinguish Prometheus from other metrics and monitoring systems are:

- A **multi-dimensional** data model (time series defined by metric name and set of key/value dimensions)
- PromQL, a **powerful and flexible query language** to leverage this dimensionality
- No dependency on distributed storage; **single server nodes are autonomous**
- An HTTP **pull model** for time series collection
- **Pushing time series** is supported via an intermediary gateway for batch jobs
- Targets are discovered via **service discovery** or **static configuration**
- Multiple modes of **graphing and dashboarding support**
- Support for hierarchical and horizontal **federation**

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitoring.prometheus.chart.name | string | `"prometheus"` | Chart name |
| monitoring.prometheus.chart.repo | string | `"https://prometheus-community.github.io/helm-charts"` | Helm repository |
| monitoring.prometheus.chart.version | string | `"15.8.7"` | Chart version |
| monitoring.prometheus.enabled | bool | `false` | Enable Prometheus chart |
| monitoring.prometheus.values.alertmanager.configurationFile | object | `{}` | Alertmanager configuration file, example below |
| monitoring.prometheus.values.alertmanager.enabled | bool | `false` | Enable Alertmanager in the chart |
| monitoring.prometheus.values.alertmanager.pvcSize | string | `"5Gi"` | Alertmanager PVC size, you will need to define a StorageClass in `default.storageClass` |
| monitoring.prometheus.values.extraScrapeConfigs | string | `nil` | Enable extra configuration scrapes in the, watch section bellow for examples |
| monitoring.prometheus.values.kubeStateMetrics.enabled | bool | `true` | Enable kubeStateMetrics in the chart |
| monitoring.prometheus.values.nodeExporter.enabled | bool | `true` | Enable nodeExporter in the chart |
| monitoring.prometheus.values.rules.customs | object | `{}` | Create Prometheus custom rules (not available yet) |
| monitoring.prometheus.values.rules.preconfiguredEnabled | bool | `true` | Enable Prometheus rules watch preconfigured rules below |
| monitoring.prometheus.values.server.dataRetention | string | `"720h"` | Prometheus data retention |
| monitoring.prometheus.values.server.ingress.auth.authKey | string | `"htpasswd"` | Configure password key in vault kv-v2 secret, only for `auth.type: vault` |
| monitoring.prometheus.values.server.ingress.auth.avpPath | string | `"avp/data/prometheus"` | Prometheus username and password path on Vault if your kv-v2 path is `avp`, your avp path will be `avp/data/prometheus` in order to pull secrets from Vault you should pass `vault kv put avp/prometheus htpasswd=<htpasswd-chain> htpasswd_plain_password=admin:changeme` (creating htpasswd_plain_password is not mandatory but recommended in order to find your username & password values), only for `auth.type: vault`, you will need to enable AVP in ArgoCD with `.Values.argocd.values.avp.enabled=true` |
| monitoring.prometheus.values.server.ingress.auth.password | string | `"changeme"` | Basic auth password (only for `raw` type)  |
| monitoring.prometheus.values.server.ingress.auth.type | string | `"raw"` | Can be `none`, `raw` (:warning: both insecure :warning:) `vault` |
| monitoring.prometheus.values.server.ingress.auth.username | string | `"admin"` | Basic auth username (only for `raw` type) |
| monitoring.prometheus.values.server.ingress.enabled | bool | `true` | Enable Prometheus UI Ingress |
| monitoring.prometheus.values.server.ingress.name | string | `"prometheus"` | Prometheus ingress name or path (weither it is an ingress wildcard or domain) |
| monitoring.prometheus.values.server.pvcSize | string | `"30Gi"` | Prometheus PVC size, you will need to define a StorageClass in `default.storageClass` |
| monitoring.prometheusMsTeams.chart.name | string | `"prometheus-msteams"` | Chart name |
| monitoring.prometheusMsTeams.chart.repo | string | `"https://prometheus-msteams.github.io/prometheus-msteams/"` | Helm repository |
| monitoring.prometheusMsTeams.chart.version | string | `"1.3.0"` | Chart version |
| monitoring.prometheusMsTeams.enabled | bool | `false` | Enable Prometheus Ms Teams Alert chart, you will need to enable Prometheus & Alertmanager as well |
| monitoring.prometheusMsTeams.values.hooks | list | `[]` | Hooks list, watch section below for more informations |
| monitoring.prometheusMsTeams.values.monitor | bool | `false` | Enable Prometheus scraping |

##### Alertmanager example configuration file

```yaml
configurationFile:
  route:
    group_by: ['instance', 'severity']
    group_wait: 5m
    group_interval: 10m
    repeat_interval: 10m
    receiver: "slack"
  receivers:
    - name: 'slack'
      slack_configs:
        - send_resolved: true
          text: '{{ .CommonAnnotations.description }}'
          username: 'alertmanager-bot'
          channel: 'alertmanager'
          api_url: 'https://hooks.slack.com/not/working'
```

##### Additionnal scrape configuration

```yaml
# Full documentation https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config
extraScrapeConfigs: |
  - job_name: node
    static_configs:
      - targets:
        - localhost:9100
  - job_name: python-app
    static_configs:
      - targets:
          - localhost:8000
        labels:
          my_new_target_label: foo
  - job_name: go-app
    file_sd_configs:
      - files:
        - filesd.yaml
    relabel_configs:
      - target_label: instance
        replacement: foo
  - job_name: ec2_instances
    ec2_sd_configs:
      - region: eu-west-2
        access_key: <REDACTED>
        secret_key: <REDACTED>
    relabel_configs:
      - source_labels:
          - __meta_ec2_tag_prometheus
          - __meta_ec2_tag_app
        regex: '.+;test|foo'
        action: keep
      - action: labelmap
        regex: __meta_ec2_public_ip
        replacement: public_ip
  - job_name: cadvisor
    static_configs:
      - targets:
          - localhost:8888
    metric_relabel_configs:
      - action: labeldrop
        regex: 'container_label_.*'
```

### Networking

You should note that you can either activate Nginx or Traefik.
If you activate both Nginx & Traefik, a safety mechanism will prevent the installation.

#### Block constructors

##### Ingress constructor

The Helm ingress block constructor in [helpers.tpl](./templates/_helpers.tpl) it allow you to generate a classic Helm ingress block,
The template is affected by `ingress.ingressDefinition`, selected ingress annotations (Traefik or Nginx) and the ingress name it can generate this type of block template :

```yaml
# Classic utilization
ingress:
  enabled: true
  annotations: {}
  hosts:
    - test.your-cluster.domain.tld
  tls:
    - secretName: test-certificate
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

##### Url constructor

The Helm url block constructor in [helpers.tpl](./templates/_helpers.tpl) it allow you to generate a classic http(s) url block, such as this template block :

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

This block template is also affected by `ingress.ingressDefinition`.

#### Cert-manager

Cert-manager adds certificates and certificate issuers as resource types in Kubernetes clusters, and simplifies the process of obtaining, renewing and using those certificates.
It can issue certificates from a variety of supported sources, including Let's Encrypt, HashiCorp Vault, and Venafi as well as private PKI.
It will ensure certificates are valid and up to date, and attempt to renew certificates at a configured time before expiry.
It is loosely based upon the work of kube-lego and has borrowed some wisdom from other similar projects such as kube-cert-manager.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| certmanager.chart.name | string | `"cert-manager"` | Chart name |
| certmanager.chart.repo | string | `"https://charts.jetstack.io"` | Helm repository |
| certmanager.chart.version | string | `"1.8.0"` | Chart version |
| certmanager.enabled | bool | `false` | Enable Cert-manager chart |
| certmanager.namespace | string | `"cert-manager"` | Destination namespace |
| certmanager.values.clusterIssuerLetsEncrypt.email | string | `"jdoe@domain.tld"` | Configure certificate expiracy notice notifications |
| certmanager.values.clusterIssuerLetsEncrypt.enabled | bool | `false` | Enable Let's encrypt cluster issuers |
| certmanager.values.clusterIssuerLetsEncrypt.production.enabled | bool | `false` | Enable Let's Encrypt production issuer |
| certmanager.values.clusterIssuerLetsEncrypt.stagging.enabled | bool | `false` | Enable LetsEncrypt stagging issuer |
| certmanager.values.monitor | bool | `false` | Enable prometheus metrics scraping, you will need to enable Prometheus as well |

#### Ingress definition

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress.ingressDefinition.dns.domain | string | `"domain.tld"` | Cluster DNS entry, it generate this kind of urls : `https://domain.tld/prometheus` |
| ingress.ingressDefinition.dns.mode | string | `"wildcard"` | DNS declaration of your cluster can be `domain` or `wildcard` |
| ingress.ingressDefinition.dns.wildcard | string | `"your-cluster.domain.tld"` | Cluster DNS wildcard entry, it generate this kind of urls : `https://prometheus.your-cluster.domain.tld` |
| ingress.ingressDefinition.ssl.enabled | bool | `true` | Force TLS certificate section |
| ingress.ingressDefinition.ssl.strictTLS | bool | `false` | Enforce strictTls :warning: not working yet :warning: |

#### Nginx

NGINX Ingress Controller is a best-in-class traffic management solution for cloud‑native apps in Kubernetes and containerized environments.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress.nginx.chart.name | string | `"ingress-nginx"` | Chart name |
| ingress.nginx.chart.repo | string | `"https://kubernetes.github.io/ingress-nginx"` | Helm repository |
| ingress.nginx.chart.version | string | `"4.0.18"` | Chart version |
| ingress.nginx.enabled | bool | `false` | Enable Nginx chart, you should know that you can't activate Traefik & Nginx |
| ingress.nginx.values.ingressAnnotations | object | `{}` | Allow to add ingress annotations manually |
| ingress.nginx.values.monitor | bool | `false` | Enable prometheus metrics scraping, you will need to enable Prometheus as well |
| ingress.nginx.values.service.LoadBalancerIps | list | `[]` | Only for BareMetal support if you want to enforce Traefik's service IP |
| ingress.nginx.values.service.type | string | `"LoadBalancer"` | Can be either Loadbalancer or NodePort |

#### Traefik

Traefik is an open-source Edge Router that makes publishing your services a fun and easy experience. It receives requests on behalf of your system and finds out which components are responsible for handling them.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress.traefik.chart.name | string | `"traefik"` | Chart name |
| ingress.traefik.chart.repo | string | `"https://helm.traefik.io/traefik"` | Helm repository |
| ingress.traefik.chart.version | string | `"10.15.0"` | Chart version |
| ingress.traefik.enabled | bool | `false` | Enable Traefik chart, you should know that you can't activate Traefik & Nginx |
| ingress.traefik.values.ingressAnnotations | object | `{}` | Allow to add ingress annotations manually |
| ingress.traefik.values.monitor | bool | `false` | Enable prometheus metrics scraping, you will need to enable Prometheus as well |
| ingress.traefik.values.service.LoadBalancerIps | list | `[]` | Only for BareMetal support if you want to enforce Traefik's service IP |
| ingress.traefik.values.service.type | string | `"LoadBalancer"` | Can be either Loadbalancer or NodePort |

> :warning: Traefik is not currently well implemented, if you are using strictTLS you should add this key : `traefik.ingress.kubernetes.io/router.middlewares: traefik-system-security@kubernetescrd`

### Security

#### Starboard

There are lots of security tools in the cloud native world, created by Aqua and by others, for identifying and informing
users about security issues in Kubernetes workloads and infrastructure components. However powerful and useful they
might be, they tend to sit alongside Kubernetes, with each new product requiring users to learn a separate set of
commands and installation steps in order to operate them and find critical security information.

Starboard attempts to integrate heterogeneous security tools by incorporating their outputs into Kubernetes CRDs
(Custom Resource Definitions) and from there, making security reports accessible through the Kubernetes API. This way
users can find and view the risks that relate to different resources in what we call a Kubernetes-native way.

Starboard provides:

- Automated vulnerability scanning for Kubernetes workloads.
- Automated configuration audits for Kubernetes resources with predefined rules or custom Open Policy Agent (OPA) policies.
- Automated infrastructures scanning and compliance checks with CIS Benchmarks published by the Center for Internet Security (CIS).
- Automated compliance report - NSA, CISA Kubernetes Hardening Kubernetes Guidance v1.0
- Penetration test results for a Kubernetes cluster.
- [Custom Resource Definitions] and a [Go module] to work with and integrate a range of security scanners.
- The [Octant Plugin] and the [Lens Extension] that make security reports available through familiar Kubernetes interfaces

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| starboard.chart.name | string | `"starboard-operator"` | Chart name |
| starboard.chart.repo | string | `"https://aquasecurity.github.io/helm-charts/"` | Helm repository |
| starboard.chart.version | string | `"0.10.4"` | Chart version |
| starboard.enabled | bool | `false` | Enable Starboard chart |
| starboard.namespace | string | `"starboard-system"` | Destination namespace |
| starboard.values.excludeNamespaces | string | `""` | Namespaces to exclude, default to none |
| starboard.values.targetNamespaces | string | `""` | Namespaces to target, default to all |
| starboard.values.trivy.imageRef | string | `"docker.io/aquasec/trivy:0.25.2"` | Trivy imageRef |
| starboard.values.trivy.nonSslRegistries | object | `{}` | Add non SSL registries, watch section below |
| starboard.values.trivy.severity | string | `"UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL"` | Trivy report severity filters |

#### User management

User management is a chart hosted on this repository, you can retrieve templates [here](../charts/users/).

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| userManagement.chart.path | string | `"charts/users"` | Chart path |
| userManagement.chart.repo | string | `"https://github.com/panzouh/argo-repository.git"` | Helm repository (This own repository) |
| userManagement.chart.targetRevision | string | `"HEAD"` | Chart target revision, using `HEAD` allow you to use the same version of your cluster spec |
| userManagement.enabled | bool | `false` | Enable User Management chart |
| userManagement.namespace | string | `"argocd"` | Destination namespace |
| userManagement.values.clusterRoles | list | `[]` | Create a Service account and associate it to a clusterrole, it does not support yet the creation of a cluster role so you have to use defaults cluster roles |
| userManagement.values.namespaceRoles | list | `[]` | Create a Service account and a role if specified, if no role is specified default is namespace admin |

#### `namespaceRoles` examples

#### Namespace specific role

```yaml
namespaceRoles:
- name: jdoe
  refNamespace: default
  rules:
  - apiGroups: ["", "extensions", "apps"]
    resources: ["*"]
    verbs: ["*"]
  - apiGroups: ["batch"]
    resources:
    - jobs
    - cronjobs
    verbs: ["*"]
```

#### Namespace w/ no defined role (Namespace admin)

```yaml
namespaceRoles:
- name: jdoe
  refNamespace: default
  rules: []
```

#### `clusterRoles` example

```yaml
clusterRoles:
  - name: jdoe-adm
    refRole: cluster-admin
```

#### Vault

Vault is an identity-based secret and encryption management system. A secret is anything you want to tightly control access to, such as API encryption keys, passwords, or certificates. Vault provides encryption services that are controlled by authentication and authorization methods. Using the Vault user interface, CLI, or HTTP API, access to secrets and other sensitive data can be securely stored and managed, tightly controlled (restricted), and auditable.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| vault.chart.name | string | `"vault"` |  |
| vault.chart.repo | string | `"https://helm.releases.hashicorp.com"` | Helm repository |
| vault.chart.version | string | `"0.19.0"` |  |
| vault.enabled | bool | `false` | Enable Vault chart |
| vault.namespace | string | `"argocd"` | Vault destination namespace |
| vault.values.ha | bool | `false` | Enable vault HA  |
| vault.values.ingress.enabled | bool | `true` | Enable Vault UI Ingress |
| vault.values.ingress.name | string | `"vault"` | Vault ingress name or path (weither it is an ingress wildcard or domain) |
| vault.values.monitor | bool | `false` | Enable prometheus metrics scraping, you will need to enable Prometheus as well |
| vault.values.pvcSize | string | `"10Gi"` | Vault persistence size, you will need to define a StorageClass in `default.storageClass` |

#### Vault secrets

Vault secrets is a chart hosted on this repository, you can retrieve templates [here](../charts/vault-secrets/). This chart is mandatory in order to use AVP and generate secrets pulled from Vault.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| vaultSecrets.chart.path | string | `"charts/vault-secrets"` | Chart path |
| vaultSecrets.chart.repo | string | `"https://github.com/panzouh/argo-repository.git"` | Helm repository (This own repository) |
| vaultSecrets.chart.targetRevision | string | `"HEAD"` | Chart target revision, using `HEAD` allow you to use the same version of your cluster spec |
| vaultSecrets.namespace | string | `"argocd"` | Destination namespace |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.10.0](https://github.com/norwoodj/helm-docs/releases/v1.10.0) `docker run --rm --volume "$(pwd):/helm-docs"  jnorwood/helm-docs:latest`.
