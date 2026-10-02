# Caddy with the caddy-ratelimit plugin, used by the Block Keeper TLS proxy
# (ansible/roles/block-keeper-tls-proxy in acki-nacki). Built once here so that
# deploys do not have to run xcaddy (and fetch Go modules) on every host.
FROM caddy:2.8.4-builder AS builder
RUN xcaddy build --with github.com/mholt/caddy-ratelimit

FROM caddy:2.8.4
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
