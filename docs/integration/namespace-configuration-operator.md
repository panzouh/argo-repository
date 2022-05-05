# Namespace configuration operator chart

The namespace-configuration-operator is a project hosted by RedHat. It helps keeping configurations related to Users, Groups and Namespaces aligned with one of more policies specified as a CRs. The purpose is to provide the foundational building block to create an end-to-end onboarding process. By onboarding process we mean all the provisioning steps needed to a developer team working on one or more applications to OpenShift. This usually involves configuring resources such as: Groups, RoleBindings, Namespaces, ResourceQuotas, NetworkPolicies, EgressNetworkPolicies, etc.... . Depending on the specific environment the list could continue. Naturally such a process should be as automatic and scalable as possible.

With the namespace-configuration-operator one can create rules that will react to the creation of Users, Groups and Namespace and will create and enforce a set of resources.

## Operating values

By default, the Namespace configuration operator is not enabled. You can activate either by setting `namespaceConfiguratorOperator.enabled: true` or `default.enabled: true`. It will enable all the default stack including OLM, ArgoCD, Namespace configurator operator, Namespace configuration & Vault).

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable Namespace configuration operator chart |
| chart.repo | string | <https://redhat-cop.github.io/namespace-configuration-operator> | Namespace configuration operator helm repository |
| chart.name | string | namespace-configuration-operator | Namespace configuration operator chart name |
| chart.version | string | v1.2.2 | Namespace configuration operator chart version |
| values | dictionnary | None | Watch section below |

### Chart values (values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitor | boolean | false | Enable prometheus metrics scraping, you will need to enable Prometheus as well |
