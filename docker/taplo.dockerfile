# syntax=docker/dockerfile:1.20

FROM tamasfe/taplo:0.10.0 AS taplo

FROM alpine:latest

# NOTE: woodpecker doesn't understand OCI images and wants /bin/sh
COPY --from=taplo /taplo /usr/local/bin/taplo
