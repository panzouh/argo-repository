# Cert-manager Chart

Cert-manager adds certificates and certificate issuers as resource types in Kubernetes clusters, and simplifies the process of obtaining, renewing and using those certificates.
It can issue certificates from a variety of supported sources, including Let's Encrypt, HashiCorp Vault, and Venafi as well as private PKI.
It will ensure certificates are valid and up to date, and attempt to renew certificates at a configured time before expiry.
It is loosely based upon the work of kube-lego and has borrowed some wisdom from other similar projects such as kube-cert-manager.

## Operating values

By default, if there is no ingress enabled, the chart will not be activated, in order to enable it, you have to enable Traefik or Nginx and Cert-manager.

### Generic values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | boolean | false | Enable Cert-manager chart |
| namespace | string | cert-manager | Cert-manager destination namespace |
| chart.repo | string | <https://charts.jetstack.io> | Cert-manager helm repository |
| chart.name | string | cert-manager | Cert-manager chart name |
| chart.version | string | 1.2.0 | Cert-manager chart version |
| values | dictionnary | None | Watch section below |

### Chart values (values)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| monitor | boolean | false | Enable prometheus metrics scraping, you will need to enable Prometheus as well |
| clusterIssuerLetsEncrypt.enabled | boolean | false | Enable Letsencrypt cluster issuers |
| clusterIssuerLetsEncrypt.email | string | jdoe@domain.tld | Configure certificate expiracy mail notifications |
| clusterIssuerLetsEncrypt.stagging.enabled | boolean | false | Enable LetsEncrypt stagging issuer |
| clusterIssuerLetsEncrypt.production.enabled | boolean | false | Enable LetsEncrypt stagging issuer |
