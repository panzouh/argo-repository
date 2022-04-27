# Default values

Because some vars are generic to other charts, some are defined by default.

## Operating default values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable default charts (ArgoCD, OLM, Namespace configurator operator & Namespace configuration) |
| storageClass | string | None | Define storageClass in order to persistence to work |
| smtpServer | string | "0.0.0.0:25" | Smtp server to configure notifications :warning: not working yet :warning: |

### Proxies specific

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable proxy support for all charts |
| value | string | None | Define http(s) proxy |
| noProxy | string | None | Define noProxy value should be `noProxy: .cluster.local,.svc,podsCIDR,svcCIDR` |
