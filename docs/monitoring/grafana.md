# Grafana Chart

Grafana allows you to query, visualize, alert on and understand your metrics no matter where they are stored. Create, explore, and share dashboards with your team and foster a data-driven culture:

- **Visualizations:** Fast and flexible client side graphs with a multitude of options. Panel plugins offer many different ways to visualize metrics and logs.
- **Dynamic Dashboards:** Create dynamic & reusable dashboards with template variables that appear as dropdowns at the top of the dashboard.
- **Explore Metrics:** Explore your data through ad-hoc queries and dynamic drilldown. Split view and compare different time ranges, queries and data sources side by side.
- **Explore Logs:** Experience the magic of switching from metrics to logs with preserved label filters. Quickly search through all your logs or streaming them live.
- **Alerting:** Visually define alert rules for your most important metrics. Grafana will continuously evaluate and send notifications to systems like Slack, PagerDuty, VictorOps, OpsGenie.
- **Mixed Data Sources:** Mix different data sources in the same graph! You can specify a data source on a per-query basis. This works for even custom datasources.

## Operating values

By default, Grafana is not enabled. In order to enable it you will need to enable Monitoring & Grafana, by doing `monitoring.enabled: true` & `monitoring.grafana.enabled: true`.

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable Grafana exporter chart |
| chart.repo | string | <https://grafana.github.io/helm-charts> | Grafana helm repository |
| chart.name | string | grafana | Grafana chart name |
| chart.version | string | 5.2.0 | Grafana chart version |
| values | dictionnary | None | Watch section below |

### Chart values (values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| passwordType | string | raw | Can be either raw or vault in order to have vault you will need to enable AVP on ArgoCD watch [AVP documention](../security/avp-documention.md) & [Argo documentation](../integration/argocd.md) first |
| adminUser | string | admin | Grafana default admin username, only for raw type :warning: insecure :warning: |
| adminPassword | string | changeme | Grafana default admin password, only for raw type :warning: insecure :warning: |
| avpPath | string | "avp/data/grafana" | Grafana username and password path on Vault if your kv-v2 path is `avp`, your avp path will be `avp/data/grafana` in order to put secrets here you should pass `vault kv put avp/grafana username=admin password=changeme`, only for `passwordType: vault` |
| userKey | string | "username" | Configure username key in vault kv-v2 secret, only for `passwordType: vault`, you will need to enable AVP in ArgoCD with `.Values.argocd.values.avp.enabled=true` |
| passwordKey | string | "password" | Configure password key in vault kv-v2 secret, only for `passwordType: vault` |
| pvcSize | string | 10Gi | Grafana persistence size, you will need to define a StorageClass in `default.storageClass` |
| ingress.enabled | boolean | true | Enable Grafana ui |
| ingress.name | string | grafana | Grafana ingress name or path (weither it is an ingress wildcard or domain) |
| customDashboards | list | None | Create Grafana custom dashoards (Json Formated), not available at the moment |
| customDashboardsGNET | list | None | Create Grafana Dashboard available on Grafana Net, not available at the moment |
