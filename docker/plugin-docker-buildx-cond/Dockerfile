# syntax=docker/dockerfile:1.14

FROM woodpeckerci/plugin-docker-buildx:latest

RUN apk add jq
ADD --chmod=755 buildx-cond.sh /entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/dockerd-entrypoint.sh", "/entrypoint.sh" ]
