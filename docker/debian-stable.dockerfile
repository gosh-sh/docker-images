# syntax=docker/dockerfile:1.14

#
# This file is automatically generated by `./update_stable.py` at 2025-04-03 20:00:55.775350
# Manual modifications will be overwritten
#

FROM --platform=linux/amd64 docker.gosh.sh/debian@sha256:363d4ceefeb2fda897111a714e6a39b3d7d7a40573599a4fa3e8c13424c600d0 AS base-amd64
FROM --platform=linux/arm64 docker.gosh.sh/debian@sha256:040c778070455b41af6247e5ce435f343ce591ba2f3924686205b5ede9b84981 AS base-arm64

FROM base-${TARGETARCH}
