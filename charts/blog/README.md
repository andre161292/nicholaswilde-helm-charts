# blog

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.3](https://img.shields.io/badge/AppVersion-v1.3-informational?style=flat-square)

Lightweight self-hosted facebook-styled PHP blog.

## Requirements
* [mysql](https://github.com/nicholaswilde/helm-charts/wiki/Databases)

## Dependencies

| Repository | Name | Version |
|------------|------|---------|
| https://andre161292.github.io/nicholaswilde-helm-charts/ | common | ~0.1.13 |

## TL;DR
```console
$ helm repo add nicholaswilde https://andre161292.github.io/nicholaswilde-helm-charts/
$ helm repo update
$ helm install blog nicholaswilde/blog
```

## Installing the Chart
To install the chart with the release name `blog`:
```console
helm install blog nicholaswilde/blog
```

## Uninstalling the Chart
To uninstall the `blog` deployment:
```console
helm uninstall blog
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.
Other values may be used from the [values.yaml](../common/values.yaml) from the [common library](../common).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,
```console
helm install blog \
  --set env.TZ="America/New York" \
    nicholaswilde/blog
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart.
For example,
```console
helm install blog nicholaswilde/blog -f values.yaml
```

|   user   | uid |
|:--------:|:---:|
| www-data |  33 |

## Troubleshooting
See [Wiki](https://github.com/nicholaswilde/helm-charts/wiki/Troubleshooting).

## Author
This project was started in 2021 by [Nicholas Wilde](https://github.com/nicholaswilde).

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
