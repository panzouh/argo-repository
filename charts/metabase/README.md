# metabase

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

The simplest, fastest way to get business intelligence and analytics to everyone in your company

**Homepage:** <http://www.metabase.com/>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| config.application.anon_tracking_enabled | string | `""` |  |
| config.application.breakoutBinNum | string | `""` |  |
| config.application.breakoutBinWidth | string | `""` |  |
| config.application.checkForUpdates | string | `""` |  |
| config.application.disableSessionThrottle | string | `""` |  |
| config.application.embeddingAppOrigin | string | `""` |  |
| config.application.embeddingSameSiteCookie | string | `""` |  |
| config.application.enableEmbedding | string | `""` |  |
| config.application.enableNestedQueries | string | `""` |  |
| config.application.enablePasswordLogin | string | `""` |  |
| config.application.enablePublicSharing | string | `""` |  |
| config.application.enableQueryCaching | string | `""` |  |
| config.application.enableXrays | string | `""` |  |
| config.application.favicon_url | string | `""` |  |
| config.application.landingPage | string | `""` |  |
| config.application.logo_url | string | `""` |  |
| config.application.mapTileServerURL | string | `""` |  |
| config.application.metabotEnabled | string | `""` |  |
| config.application.name | string | `""` |  |
| config.application.pluginsDir | string | `""` |  |
| config.application.queryCachingMaxKb | string | `""` |  |
| config.application.queryCachingMaxTTL | string | `""` |  |
| config.application.queryCachingMinTTL | string | `""` |  |
| config.application.queryCachingTTLRatio | string | `""` |  |
| config.application.reportTimezone | string | `""` |  |
| config.application.showHomepageData | string | `""` |  |
| config.application.showHomepageXrays | string | `""` |  |
| config.application.siteLocale | string | `""` |  |
| config.application.siteName | string | `""` |  |
| config.application.siteURL | string | `""` |  |
| config.application.siteUUID | string | `""` |  |
| config.application.sshHearbeatIntervalSec | string | `""` |  |
| config.application.versionInfoURL | string | `""` |  |
| config.database.automigrate | string | `""` |  |
| config.database.connectionTimeoutMs | string | `""` |  |
| config.database.type | string | `"h2"` |  |
| config.debug.namespaceTrace | string | `""` |  |
| config.dw.asyncQueryThreadPoolSize | string | `""` |  |
| config.dw.jdbcDataWarehouseMaxConnectionPoolSize | string | `""` |  |
| config.dw.maxConnectionPoolSize | string | `""` |  |
| config.dw.redshiftFetchSize | string | `""` |  |
| config.email.admin | string | `""` |  |
| config.email.fromAddress | string | `""` |  |
| config.jetty.asyncResponseTimeout | string | `""` |  |
| config.jetty.daemon | string | `""` |  |
| config.jetty.host | string | `""` |  |
| config.jetty.join | string | `""` |  |
| config.jetty.maxIdleTime | string | `""` |  |
| config.jetty.maxQueued | string | `""` |  |
| config.jetty.maxThreads | string | `""` |  |
| config.jetty.minThreads | string | `""` |  |
| config.jetty.requestHeaderSize | string | `""` |  |
| config.security.passComplexity | string | `""` |  |
| config.security.passLength | string | `""` |  |
| config.security.sessionAge | string | `""` |  |
| config.security.sessionCookies | string | `""` |  |
| config.security.sourceAddressHeader | string | `""` |  |
| config.sso.googleAuthAutoCreateAccountDomains | string | `""` |  |
| config.sso.googleAuthClientId | string | `""` |  |
| config.sso.jwtAttributeEmail | string | `""` |  |
| config.sso.jwtAttributeFirstName | string | `""` |  |
| config.sso.jwtAttributeGroups | string | `""` |  |
| config.sso.jwtAttributeLastName | string | `""` |  |
| config.sso.jwtEnabled | string | `""` |  |
| config.sso.jwtGroupMappings | string | `""` |  |
| config.sso.jwtGroupSync | string | `""` |  |
| config.sso.jwtIdentityProviderUri | string | `""` |  |
| config.sso.ldapAttributeEmail | string | `""` |  |
| config.sso.ldapAttributeFirstName | string | `""` |  |
| config.sso.ldapAttributeLastName | string | `""` |  |
| config.sso.ldapBindDN | string | `""` |  |
| config.sso.ldapEnabled | string | `""` |  |
| config.sso.ldapGroupBase | string | `""` |  |
| config.sso.ldapGroupMappings | string | `""` |  |
| config.sso.ldapGroupSync | string | `""` |  |
| config.sso.ldapSyncUserAttributes | string | `""` |  |
| config.sso.ldapSyncUserAttributesBlacklist | string | `""` |  |
| config.sso.ldapUserBase | string | `""` |  |
| config.sso.ldapuserFilter | string | `""` |  |
| config.sso.samlApplicationName | string | `""` |  |
| config.sso.samlAttributeEmail | string | `""` |  |
| config.sso.samlAttributeFirstName | string | `""` |  |
| config.sso.samlAttributeGroup | string | `""` |  |
| config.sso.samlAttributeLastName | string | `""` |  |
| config.sso.samlEnabled | string | `""` |  |
| config.sso.samlGroupMappings | string | `""` |  |
| config.sso.samlGroupSync | string | `""` |  |
| config.sso.samlIdPURI | string | `""` |  |
| config.sso.samlKeystoreAlias | string | `""` |  |
| config.sso.sendNewSSOUserAdminEmail | string | `""` |  |
| extraArgs | string | `nil` |  |
| extraEnv | string | `nil` |  |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.command | list | `[]` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"metabase/metabase"` |  |
| image.tag | string | `"latest"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"metabase.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| initContainers | list | `[]` |  |
| livenessProbe.failureThreshold | int | `6` |  |
| livenessProbe.initialDelaySeconds | int | `120` |  |
| livenessProbe.timeoutSeconds | int | `30` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| readinessProbe.initialDelaySeconds | int | `30` |  |
| readinessProbe.periodSeconds | int | `5` |  |
| readinessProbe.timeoutSeconds | int | `3` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| secrets.cache.backend | string | `""` |  |
| secrets.config.api_key | string | `""` |  |
| secrets.config.embeddingToken | string | `""` |  |
| secrets.config.encryptionKey | string | `""` |  |
| secrets.config.setupToken | string | `""` |  |
| secrets.config.slackToken | string | `""` |  |
| secrets.database.connString | string | `""` |  |
| secrets.database.dbName | string | `""` |  |
| secrets.database.host | string | `""` |  |
| secrets.database.password | string | `""` |  |
| secrets.database.port | string | `""` |  |
| secrets.database.username | string | `""` |  |
| secrets.email.host | string | `""` |  |
| secrets.email.password | string | `""` |  |
| secrets.email.port | string | `""` |  |
| secrets.email.security | string | `""` |  |
| secrets.email.username | string | `""` |  |
| secrets.existingSecret.connectionURIKey | string | `nil` |  |
| secrets.existingSecret.name | string | `nil` |  |
| secrets.existingSecret.passwordKey | string | `nil` |  |
| secrets.existingSecret.usernameKey | string | `nil` |  |
| secrets.ldap.host | string | `""` |  |
| secrets.ldap.password | string | `""` |  |
| secrets.ldap.port | string | `""` |  |
| secrets.ldap.security | string | `""` |  |
| secrets.sso.jwt | string | `""` |  |
| secrets.sso.samlIdentityProviderCertificate | string | `""` |  |
| securityContext | object | `{}` |  |
| service.externalPort | int | `80` |  |
| service.internalPort | int | `3000` |  |
| service.name | string | `"metabase"` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)