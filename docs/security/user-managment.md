# User management chart

User management is a chart hosted on this repository, you can retrieve templates [here](../../charts/users/).

## Operating values

By default even if the chart is enabled, there is no cluster role / role enabled, in order to do that you need to add them manually, the chart is installed in argocd namespace so service accounts will be created in argocd namespace. At the moment this variable cannot be overriden.

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable User management chart |
| chart.repo | string | <https://github.com/panzouh/argo-repository.git>(this repository) | User management repository |
| chart.path | string | charts/users | User Management chart path |
| chart.targetRevision | string | HEAD | Chart target revision, using HEAD allow you to use the same version of your cluster spec |
| values | dictionnary | None | Watch section below |

### Chart values (values)

The destination namespace will need to be created in order to create the service account. If it is a cluster role, the service account will be created in kube-system namespace.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| namespaceRoles | list | None | Create a Service account and a role if specified, if no role is specified default is namespace admin |
| clusterRoles | list | None | Create a Service account and associate it to a clusterrole, it does not support yet the creation of a cluster role so you have to use defaults cluster roles |

#### namespaceRoles examples

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

#### clusterRoles example

```yaml
clusterRoles:
  - name: jdoe-adm
    refRole: cluster-admin
```
