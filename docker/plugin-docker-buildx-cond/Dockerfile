# syntax=docker/dockerfile:1.20

FROM woodpeckerci/plugin-docker-buildx:latest

RUN apk add jq
RUN test -e /usr/local/bin/docker-original || mv /usr/local/bin/docker /usr/local/bin/docker-original
COPY --chmod=755 docker-wrapper.sh /usr/local/bin/docker
ADD --chmod=755 buildx-cond.sh /entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/dockerd-entrypoint.sh", "/entrypoint.sh" ]
