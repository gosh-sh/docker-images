# syntax=docker/dockerfile:1.14

#
# This file is automatically generated by `./update_stable.py` at 2025-02-26T14:33:55.873866
# Manual modifications will be overwritten
#

FROM --platform=linux/amd64 docker.gosh.sh/debian@sha256:23a8c6f05014ced61a7a2d4ad333315e84c104aad84a2806500e2de471f5a720 AS base-amd64
FROM --platform=linux/arm64 docker.gosh.sh/debian@sha256:4ab11bda33875d40ff251e32f760aebde18a32ce98bac89df5214f1e29056334 AS base-arm64

FROM base-${TARGETARCH}
