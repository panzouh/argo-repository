# Namespace configuration chart

Namespace configuration is a chart hosted on this repository, you can retrieve templates [here](../../charts/users/). It is based on [Namespace configuration Operator](./namespace-configuration-operator.md) hosted by RedHat.

## Operating values

In order to be enabled you can either activate this chart by setting `namespaceConfiguration.enabled: true` & `namespaceConfiguratorOperator.enabled: true` or simply set `default: true`. It will enable all the default stack including OLM, ArgoCD, Namespace configurator operator, Namespace configuration & Vault).

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable Namespace configuration chart |
| chart.repo | string | <https://gitlab.com/a4537/repository.git>(this repository) | Namespace configuration repository |
| chart.path | string | charts/namespace-configuration | Namespace configuration chart path |
| chart.targetRevision | string | HEAD | Chart target revision, using HEAD allow you to use the same version of your cluster spec |
| chart.values | dictionnary | None | Watch section below |

### Chart values (chart.values)

The destination namespace will need to be created in order to create the service account. If it is a cluster role, the service account will be created in kube-system namespace.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| quotas | list | None | Create *n* resources quotas so your users does not overconsume compute resources |
| networkPolices | list | None | Create *n* network policies |
| isolatedNetworkPolicy.enabled | boolean | false | Create the isolated networkPolicy (Full access on current namespace, access outside the cluster, accessible by ingress & monitoring, restricted to every other namespaces) |
| isolatedNetworkPolicy.clusterCIDRs | list | None | You will need to specify podCIDR & serviceCIDR you can get it by running `kubectl cluster-info dump | grep -m 1 service-cluster-ip-range` & `kubectl cluster-info dump | grep -m 1 cluster-cidr` |

#### Quota example

```yaml
quotas:
  - quotaName: small-size
    matchLabels: 
      size: small
    requestMem: 4Gi
    requestCPU: 2
    requestsPVC: 100Gi
    totalPVC: 5
    requestsEmptyDirs: 10Gi
```

In order for this quota to take effect you will need to label your namespace as follows :

```sh
kubectl label ns <your-namespace> size=small
```

### Network Policy example

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

In order for this network policy to take effect you will need to label your namespace as follows :

```sh
kubectl label ns <your-namespace> policy=demo
```
