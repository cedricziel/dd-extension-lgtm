# Grafana LGTM Docker Desktop extension

This repository contains a docker desktop extension to embed the LGTM stack
into Docker Desktop (DD).

To install the development state, use:

```bash
docker extension install cedricziel/dd-extension-lgtm:dev
```

Please look at [individual releases](https://github.com/cedricziel/dd-extension-lgtm/releases) to learn how to install a specific version.

**NOTE:** This project is not affiliated with Grafana Labs.

![Docker Desktop Screenshot](images/splash.png)

## What's in the box?

This extension ships a pre-configured LGTM stack:

* Loki as a store for logs
* Grafana as a flexible dashboarding/query tool
* Tempo as a store for tracing
* Mimir as a metric store
* OpenTelemetry collector as the point of ingress

## FAQ

1. Where is the data?

The data is currently stored in the respective containers.

2. How can I reset the state?

You can uninstall and re-install the extension.

3. How to ingest data?

This PoC is optimized for OpenTelemetry ingress via OTLP. This means you should be able
to ingest data by setting `OTEL_EXPORTER_OTLP_ENDPOINT` on the observed and instrumented process.

The value of `OTEL_EXPORTER_OTLP_ENDPOINT` would be depending on your network setup, but in essence,
you point it to your local docker host.

Format is as follows: `OTEL_EXPORTER_OTLP_ENDPOINT=host.docker.internal:4317`

## License

MIT
