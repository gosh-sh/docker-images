# Caddy with the caddy-ratelimit plugin, used by the Block Keeper TLS proxy
# (ansible/roles/block-keeper-tls-proxy in acki-nacki). Built once here and
# published as teamgosh/caddy-ratelimit (public, for node operators) and
# docker.gosh.sh/caddy-ratelimit, so deploys do not run xcaddy on every host.
FROM caddy:2.8.4-builder AS builder
RUN xcaddy build --with github.com/mholt/caddy-ratelimit

FROM caddy:2.8.4
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
