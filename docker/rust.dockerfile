# syntax=docker/dockerfile:1.20

# see https://github.com/rui314/mold/releases
ARG MOLD_VERSION=2.40.4
# see https://github.com/mozilla/sccache/releases
ARG SCCACHE_VERSION=0.12.0
# see https://github.com/EmbarkStudios/cargo-deny/releases
ARG CARGO_DENY_VERSION=0.18.9
# see https://github.com/casey/just/releases
ARG JUST_VERSION=1.46.0

FROM rust:trixie AS rust-base

FROM rust-base
ARG MOLD_VERSION
ENV MOLD_VERSION=${MOLD_VERSION}
ARG SCCACHE_VERSION
ENV SCCACHE_VERSION=${SCCACHE_VERSION}
ARG CARGO_DENY_VERSION
ENV CARGO_DENY_VERSION=${CARGO_DENY_VERSION}
ARG JUST_VERSION
ENV JUST_VERSION=${JUST_VERSION}

WORKDIR /app

RUN \
    apt-get update && apt-get install -yq \
    build-essential \
    cmake \
    wget \
    curl \
    jq \
    libnuma-dev \
    tcl-dev \
    tk-dev

RUN <<EOF
    echo "mold ${MOLD_VERSION}"

    wget -O- --timeout=10 --waitretry=3 \
        --retry-connrefused \
        --progress=dot:mega \
        https://github.com/rui314/mold/releases/download/v${MOLD_VERSION}/mold-${MOLD_VERSION}-$(uname -m)-linux.tar.gz \
    | tar -C /usr/local --strip-components=1 --no-overwrite-dir -xzf -

    ## you can replace default linker if needed
    # ln -sf /usr/local/bin/mold "$(realpath /usr/bin/ld)"
EOF

RUN <<EOF
    echo "sccache ${SCCACHE_VERSION}"

    wget -O- --timeout=10 --waitretry=3 \
        --retry-connrefused \
        --progress=dot:mega \
        https://github.com/mozilla/sccache/releases/download/v${SCCACHE_VERSION}/sccache-v${SCCACHE_VERSION}-$(uname -m)-unknown-linux-musl.tar.gz \
    | tar -C /usr/local/bin/ --strip-components=1 --no-overwrite-dir -xzf -
EOF

RUN <<EOF
    echo "cargo-deny ${CARGO_DENY_VERSION}"

    wget -O- --timeout=10 --waitretry=3 \
        --retry-connrefused \
        --progress=dot:mega \
        https://github.com/EmbarkStudios/cargo-deny/releases/download/${CARGO_DENY_VERSION}/cargo-deny-${CARGO_DENY_VERSION}-$(uname -m)-unknown-linux-musl.tar.gz \
    | tar -C /usr/local/bin/ --strip-components=1 --no-overwrite-dir -xzf -
EOF

RUN <<EOF
    echo "just ${JUST_VERSION}"

    wget -O- --timeout=10 --waitretry=3 \
        --retry-connrefused \
        --progress=dot:mega \
        https://github.com/casey/just/releases/download/${JUST_VERSION}/just-${JUST_VERSION}-$(uname -m)-unknown-linux-musl.tar.gz \
    | tar -C /usr/local/bin/ --strip-components=1 --no-overwrite-dir -xzf -
EOF

RUN rustup component add clippy

# support for `cargo +nightly fmt`
RUN rustup toolchain add nightly
RUN rustup component add --toolchain nightly rustfmt
