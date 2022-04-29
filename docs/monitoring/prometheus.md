# Prometheus Chart

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

## Operating values

By default, Prometheus is not enabled. In order to enable it you will need to enable Monitoring & Prometheus, by doing `monitoring.enabled: true` & `monitoring.prometheus.enabled: true`. At the moment only Prometheus Helm chart is available, Prometheus Operator will be supported in the future.

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable Prometheus exporter chart |
| chart.repo | string | <https://prometheus-community.github.io/helm-charts> | Prometheus helm repository |
| chart.name | string | prometheus| Prometheus chart name |
| chart.version | string | 9.2.2 | Prometheus chart version |
| chart.values | dictionnary | None | Watch section below |

### Chart values (chart.values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| rules.preconfiguredEnabled | boolean | true | Enable Prometheus rules watch preconfigured rules below  |
| rules.customs | dictionary | None | Create Prometheus custom rules (not available yet) |
| alertmanager.enabled | boolean | false | Enable Alertmanager in the chart |
| alertmanager.pvcSize | string | 5Gi | Alertmanager persistence size, you will need to define a StorageClass in `default.storageClass` |
| configurationFile | dictionary | None | Alertmanager configuration file, example below |
| kubeStateMetrics.enabled | boolean | true | Enable kubeStateMetrics in the chart |
| nodeExporter.enabled | boolean | true | Enable nodeExporter in the chart |
| server.pvcSize | string | 30Gi | Alertmanager persistence size, you will need to define a StorageClass in `default.storageClass` |
| server.ingress.enabled | boolean | false | Enable Prometheus ui |
| server.ingress.name | string | prometheus | Prometheus ingress name or path (weither it is an ingress wildcard or domain) |
| server.ingress.auth | dictionary | None | Prometheus ingress authentication scheme |
| server.dataRetention | string | 720h | Prometheus data retention |

### Auth values (server.ingress)

| auth.type | string | raw | Can be `none`, `raw` (:warning: both insecure :warning:) `vault` |
| auth.username | string | admin | Basic auth username (only for `raw` type) |
| auth.password | string | changeme | Basic auth password (only for `raw` type) |
| auth.avpPath | string | avp/data/prometheus | Prometheus username and password path on Vault if your kv-v2 path is `avp`, your avp path will be `avp/data/prometheus` in order to put secrets here you should pass `vault kv put avp/prometheus username=admin password=changeme` |

### Preconfigured rules

```yaml
groups:
    - name: Rules
      rules:
        - alert: AnyDown
            expr: up == 0
            for: 5m
            labels:
            severity: average
            annotations:
            identifiers: {{ quote (include "labels.instance" .) }}
            summary: "Component Down on instance {{ (include "labels.instance" .) }}"
            description: "K8S component down\n  VALUE = {{ (include "value" .) }}\n  LABELS: {{ (include "labels" .) }}"
        - alert: NodeDown
            expr: up{job="kubernetes-nodes"} == 0
            for: 1m
            labels:
            severity: critical
            annotations:
            identifiers: {{ quote (include "labels.instance" .) }}
            summary: "Node DOWN (instance {{ (include "labels.instance" .) }})"
            description: "K8S Node down\n  VALUE = {{ (include "value" .) }}\n  LABELS: {{ (include "labels" .) }}"
        {{- if .Values.monitoring.goldpinger.values.enablePrometheusRules }}
        - alert: DTK_Goldpinger_Nodes
            expr: |
            sum(goldpinger_nodes_health_total{job="goldpinger", status="unhealthy"})
            BY (instance, goldpinger_instance) > 0
            for: 5m
            annotations:
            description: |
                Goldpinger instance {{ (include "labels.goldpinger_instance" .) }} has been reporting unhealthy nodes for at least 5 minutes.
            summary: Instance {{ (include "labels.instance" .) }} down
            labels:
            severity: warning
        {{- end }}
        - alert: OutOfMemory
            expr: node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100 < 10
            for: 10m
            labels:
            severity: warning
            annotations:
            identifiers: {{ quote (include "labels.instance" .) }}
            summary: "Out of memory (instance {{ (include "labels.instance" .) }})"
            description: "Node memory is filling up (< 10% left)\n  VALUE = {{ (include "value" .) }}\n  LABELS: {{ (include "labels" .) }}"
        - alert: OutOfDiskSpace
            expr: node_filesystem_free_bytes{mountpoint ="/"} / node_filesystem_size_bytes{mountpoint ="/"} * 100 < 10
            for: 10m
            labels:
            severity: warning
            annotations:
            identifiers: {{ quote (include "labels.instance" .) }}
            summary: "Out of disk space (instance {{ (include "labels.instance" .) }})"
            description: "Disk is almost full (< 10% left)\n  VALUE = {{ (include "value" .) }}\n  LABELS: {{ (include "labels" .) }}"
        - alert: OutOfInodes
            expr: node_filesystem_files_free{mountpoint ="/"} / node_filesystem_files{mountpoint ="/"} * 100 < 10
            for: 10m
            labels:
            severity: warning
            annotations:
            identifiers: {{ quote (include "labels.instance" .) }}
            summary: "Out of inodes (instance {{ (include "labels.instance" .) }})"
            description: "Disk is almost running out of available inodes (< 10% left)\n  VALUE = {{ (include "value" .) }}\n  LABELS: {{ (include "labels" .) }}"
        - alert: CpuLoad
            expr: node_load15 / (count without (cpu, mode) (node_cpu_seconds_total{mode="system"})) > 2
            for: 10m
            labels:
            severity: warning
            annotations:
            identifiers: {{ quote (include "labels.instance" .) }}
            summary: "CPU load (instance {{ (include "labels.instance" .) }})"
            description: "CPU load (15m) is high\n  VALUE = {{ (include "value" .) }}\n  LABELS: {{ (include "labels" .) }}"
        - alert: DTKPod_Restarting_Critical
            expr: dtk_pod:restart:minutes_rate > 0
            for: 30s
            labels:
            severity: critical
            annotations:
            identifiers: {{ quote (include "labels.instance" .) }}
            summary: "A pod is restarting"
            description: "Pod {{ (include "labels.namespace" .) }}/{{ (include "labels.pod" .) }} is restarting {{ (include "value" .) }} during last 5 minutes."
        - alert: DTKPod_NotReady_Warn
            labels:
            severity: warning
            annotations:
            identifiers: {{ quote (include "labels.instance" .) }}
            description: Pod {{ (include "labels.namespace" .) }}/{{ (include "labels.pod" .) }}has been in a non-ready
                state for longer than 2 minutes.
            runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepodnotready
            summary: Pod has been in a non-ready state for more than 2 minutes.
            expr: dtk_pod:nonready:state
            for: 2m
        - alert: DTKPod_NotReady_Critical
            labels:
            severity: critical
            annotations:
            identifiers: {{ quote (include "labels.instance" .) }}
            description: Pod {{ (include "labels.namespace" .) }}/{{ (include "labels.pod" .) }}has been in a non-ready
                state for longer than 5 minutes.
            runbook_url: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepodnotready
            summary: Pod has been in a non-ready state for more than 5 minutes.
            expr: dtk_pod:nonready:state
            for: 5m
        - alert: DTKPod_PVC_Usage_Warning
            expr:  dtk_pod:pvc:available_percentage < 10 AND dtk_pod:pvc:available_percentage > 3
            for: 10m
            labels:
            severity: warning
            annotations:
            identifiers: {{ quote (include "labels.instance" .) }}
            summary: "Persistent Volume Claim usage is high (instance {{ (include "labels.instance" .) }})"
            description: "PVC usage (10m) is high\n  VALUE = {{ (include "value" .) }} % Available"
        - alert: DTKPod_PVC_Usage_Critical
            expr:  dtk_pod:pvc:available_percentage < 3
            for: 10m
            labels:
            severity: critical
            annotations:
            identifiers: {{ quote (include "labels.instance" .) }}
            summary: "Persistent Volume Claim usage is high (instance {{ (include "labels.instance" .) }})"
            description: "PVC usage (10m) is high\n  VALUE = {{ (include "value" .) }} % Available"
        - alert: DTKPod_CPU_Usage_Warning
            expr:  dtk_pod:cpu:usage_percentage > 100
            for: 10m
            labels:
            severity: warning
            annotations:
            identifiers: {{ quote (include "labels.instance" .) }}
            summary: "Pod {{ (include "labels.name" .) }} CPU Usage is high "
            description: "Pod {{ (include "labels.name" .) }} CPU usage (10m) is high\n  VALUE = {{ (include "value" .) }} % Used"
        - alert: DTKPod_RAM_Usage_Warning
            expr:  dtk_pod:ram:usage_percentage > 100
            for: 10m
            labels:
            severity: warning
            annotations:
            identifiers: {{ quote (include "labels.instance" .) }}
            summary: "Pod RAM usage is high (instance {{ (include "labels.instance" .) }})"
            description: "Pod {{ (include "labels.pod" .) }}usage (10m) is high\n  VALUE = {{ (include "value" .) }} %"
  - name: Record
    rules: 
        - record: dtk_pod:restart:minutes_rate
            expr: rate(kube_pod_container_status_restarts_total{namespace!=""}[5m]) * 60*60
        - record: dtk_pod:cpu:usage_percentage
            expr: (sum(rate(container_cpu_usage_seconds_total{container_name!="POD", namespace!=""}[10m])) by (pod, namespace) / sum(kube_pod_container_resource_requests_cpu_cores{container_name!="POD", namespace!=""}) by (pod, namespace)) *100
        - record: dtk_pod:ram:usage_percentage
            expr: (sum(container_memory_working_set_bytes{container!="POD", namespace!="", image!=""}) by (pod, namespace) / sum(kube_pod_container_resource_requests_memory_bytes{namespace!=""}) by (pod,namespace)) * 100
        - record: dtk_pod:pvc:available_percentage
            expr: max((kubelet_volume_stats_available_bytes{namespace!=""}/kubelet_volume_stats_capacity_bytes{namespace!=""})*100) by (persistentvolumeclaim,namespace)
        - record: dtk_pod:nonready:state
            expr: |
            sum by (namespace, pod) (
                max by(namespace, pod) (
                kube_pod_status_phase{namespace!="", job="kube-state-metrics", phase=~"Pending|Unknown"}
                ) * on(namespace, pod) group_left(owner_kind) topk by(namespace, pod) (
                1, max by(namespace, pod, owner_kind) (kube_pod_owner{namespace!="", owner_kind!="Job"})
                )
            ) > 0
```

### Alertmanager example configuration file

```yaml
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
