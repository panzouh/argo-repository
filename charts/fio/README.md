# Fio Docker Exporter

[Official Repository](https://gitlab.com/panzouh/fio-exportaire).
The purpose of this helm release is to expose Fio metrics to prometheus.

Feel free to use it !

Tested on Kubernetes v1.18.10

## Docker

Docker repository : [Repository](https://hub.docker.com/repository/docker/panzouh/fio-exportaire)

![Docker Image Size (tag)](https://img.shields.io/docker/image-size/panzouh/fio-exportaire/latest)
![Docker Image Version (latest by date)](https://img.shields.io/docker/v/panzouh/fio-exportaire)

## Installation

First you need to install prometheus in your cluster

```sh
git clone https://gitlab.com/panzouh/fio-exportaire.git
```

```sh
kubectl apply -f ./kubernetes/daemonset.yaml
```

Check installation with :

```sh
kubectl get po -n monitoring
```

## Todo

- Run tests
- Write README on Docker repository
- Add README for helm chart with configuration table

## License

License File : [License](LICENSE)

## Contribute

Comming soon !

## Credits

MaxHenger : [github/MaxHenger](https://github.com/MaxHenger/fio)

## Authors

@Kesslerdev
@Amassinissa
@Panzouh
