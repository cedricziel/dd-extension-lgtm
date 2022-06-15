FROM golang:1.17-alpine AS builder
ENV CGO_ENABLED=0
RUN apk add --update make
WORKDIR /backend
COPY go.* .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go mod download
COPY . .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    make bin

FROM --platform=$BUILDPLATFORM node:17.7-alpine3.14 AS client-builder
WORKDIR /ui
# cache packages in layer
COPY ui/package.json /ui/package.json
COPY ui/package-lock.json /ui/package-lock.json
RUN --mount=type=cache,target=/usr/src/app/.npm \
    npm set cache /usr/src/app/.npm && \
    npm ci
# install
COPY ui /ui
RUN npm run build

FROM alpine
LABEL org.opencontainers.image.title="Grafana LGTM" \
    org.opencontainers.image.description="Grafana LGTM in Docker Desktop" \
    org.opencontainers.image.vendor="Cedric Ziel" \
    com.docker.desktop.extension.api.version=">= 0.2.3" \
    com.docker.desktop.extension.icon="https://github.com/cedricziel/dd-extension-lgtm/blob/main/docker.svg" \
    com.docker.extension.screenshots="https://github.com/cedricziel/dd-extension-lgtm/blob/main/images/splash.png" \
    com.docker.extension.detailed-description="Grafanas Loki, Grafana, Tempo, Mimir and the OpenTelemetry collector right in Docker Desktop" \
    com.docker.extension.publisher-url="https://github.com/cedricziel/dd-extension-lgtm" \
    com.docker.extension.additional-urls="" \
    com.docker.extension.changelog="https://github.com/cedricziel/dd-extension-lgtm"

COPY --from=builder /backend/bin/service /
COPY docker-compose.yaml .
COPY metadata.json .
COPY docker.svg .
COPY --from=client-builder /ui/build ui
CMD /service -socket /run/guest-services/extension-dd-extension-lgtm.sock
