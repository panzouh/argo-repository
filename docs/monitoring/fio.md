# Fio exporter Chart

The purpose of this helm release is to expose Fio metrics to prometheus, it is writen in Golang, you can find the official repository [here](https://gitlab.com/panzouh/fio-exportaire).

## Operating values

By default, Fio exporter is not enabled. In order to enable it you will need to enable Monitoring & Prometheus, by doing `monitoring.enabled: true` & `monitoring.prometheus.enabled: true`, and of course `monitoring.fio.enabled: true`. At the moment, Fio is developped by myself, if you want more functionalities, please create an issue on the repository.

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable Fio chart |
| chart.repo | string | <https://gitlab.com/a4537/repository.git> (this repository) | Fio helm repository |
| chart.path | string | charts/fio | Chart path on this repository |
| chart.version | string | 4.10.14 | Chart target revision, using HEAD allow you to use the same version of your cluster spec |
| chart.values | dictionnary | None | Watch section below |

### Chart values (chart.values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| installOnControllPlane | boolean | false | Enable Fio exporter on the controll plane, by default Prometheus scraping is enabled |
| enableGrafanaDashboard | boolean | false | Enable a Grafana specific dashboard, you will need to have Grafana enabled |
