# syntax=docker/dockerfile:1.14

#
# This file is automatically generated by `./update_stable.py` at 2025-06-13 10:51:30.094660
# Manual modifications will be overwritten
#

FROM --platform=linux/amd64 docker.gosh.sh/debian@sha256:c3c42c9d16b7e4a7f77bfeae35ed107a513b0472b0cbecc55349de675c71e3e9 AS base-amd64
FROM --platform=linux/arm64 docker.gosh.sh/debian@sha256:579b90a8d296bb704c7e6054d96a47312df59ef4d71b00aa9ad220f45ded90c4 AS base-arm64

FROM base-${TARGETARCH}
