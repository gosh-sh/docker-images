# syntax=docker/dockerfile:1.14

#
# This file is automatically generated by `./update_stable.py` at 2025-02-26T14:34:00.825955
# Manual modifications will be overwritten
#

FROM --platform=linux/amd64 docker.gosh.sh/debian@sha256:6a4103ac07537c205f793cdcfbdf39ee88a0dbe249f149e38689246094be94ec AS base-amd64
FROM --platform=linux/arm64 docker.gosh.sh/debian@sha256:354596e609a9849bd265a4f351876836cd6cd3c9c7871f8647f4dc88bf994ca9 AS base-arm64

FROM base-${TARGETARCH}
