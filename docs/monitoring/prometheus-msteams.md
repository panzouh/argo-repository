# Prometheus MsTeams Chart

Prometheus MS Teams allow you to write alerts on Microsoft Teams. In order to do that you will need to create a webhook on Teams ([Documentation](https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook))

## Operating values

By default, Helm exporter is not enabled. In order to enable it you will need to enable Monitoring & Prometheus, by doing `monitoring.enabled: true` & `monitoring.prometheus.enabled: true`, and of course `monitoring.prometheusMsTeams.enabled: true`.

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable Prometheus MsTeams exporter chart |
| chart.repo | string | <https://prometheus-msteams.github.io/prometheus-msteams/> | Prometheus MsTeams helm repository |
| chart.name | string | prometheus-blackbox-exporter | Prometheus MsTeams chart name |
| chart.version | string | 4.10.4 | Prometheus MsTeams chart version |
| chart.values | dictionnary | None | Watch section below |

### Chart values (chart.values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitor | boolean | false | Enable Prometheus scraping |
| hooks | list | None | Hooks list watch section below |

### Add Hooks

First you will need to create an incoming webhook on teams, once you have it you will have to add the hook like this :

```yaml
hooks:
  - myhook: https://office.com/not/a/working/hook
```

In order to enable it in Alertmanager, add this section of code in `monitoring.prometheus.chart.values.alertmanager.configurationFile` :

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
