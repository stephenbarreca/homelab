jackett
=======
API Support for your favorite torrent trackers.

Current chart version is `1.0.0`

Source code can be found [here](https://github.com/Jackett/Jackett)



## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"linuxserver/jackett"` |  |
| image.tag | string | `"{{ .Chart.AppVersion }}"` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0] | string | `"chart-example.local"` |  |
| ingress.paths[0] | string | `"/"` |  |
| ingress.tls | list | `[]` |  |
| jackett.gid | int | `1000` |  |
| jackett.run_opts | string | `""` |  |
| jackett.tz | string | `"UTC"` |  |
| jackett.uid | int | `1000` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.enabled | bool | `false` |  |
| persistence.size | string | `"1Gi"` |  |
| persistence.storageClassName | string | `""` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| service.port | int | `9117` |  |
| service.type | string | `"ClusterIP"` |  |
| strategy.type | string | `"Recreate"` |  |
| tolerations | list | `[]` |  |
