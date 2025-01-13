# syntax=docker/dockerfile:1.12.1

ARG MOLD_VERSION=2.33.0

FROM rust:latest AS rust-builder

# build cargo chef faster via multiarch build
FROM --platform=${BUILDPLATFORM} rust:latest AS rust-platform-builder
ENV CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=x86_64-linux-gnu-gcc \
    CC_x86_64_unknown_linux_gnu=x86_64-linux-gnu-gcc \
    CXX_x86_64_unknown_linux_gnu=x86_64-linux-gnu-g++ \
    CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc \
    CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc \
    CXX_aarch64_unknown_linux_gnu=aarch64-linux-gnu-g++
RUN <<EOF
    set -ex
    apt-get update
    apt-get install -y \
        g++-x86-64-linux-gnu \
        libc6-dev-amd64-cross \
        g++-aarch64-linux-gnu \
        libc6-dev-arm64-cross
    file $(which rustup)  # for debug
    rustup target add x86_64-unknown-linux-gnu
    rustup toolchain install --force-non-host stable-x86_64-unknown-linux-gnu
    rustup target add aarch64-unknown-linux-gnu
    rustup toolchain install --force-non-host stable-aarch64-unknown-linux-gnu
EOF


FROM --platform=${BUILDPLATFORM} rust-platform-builder AS tools-amd64
RUN cargo install cargo-chef --version 0.1.68 --target x86_64-unknown-linux-gnu
RUN cargo install just --version ^1 --target x86_64-unknown-linux-gnu


FROM --platform=${BUILDPLATFORM} rust-platform-builder AS tools-arm64
RUN cargo install cargo-chef --version 0.1.68 --target aarch64-unknown-linux-gnu
RUN cargo install just --version ^1 --target aarch64-unknown-linux-gnu

# TODO: add more platforms if needed

FROM tools-${TARGETARCH} AS tools


FROM rust-builder
ARG MOLD_VERSION
ENV MOLD_VERSION=${MOLD_VERSION}

WORKDIR /app

RUN \
    apt-get update && apt-get install -yq \
    build-essential \
    cmake \
    wget \
    curl \
    jq

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


COPY --link --from=tools /usr/local/cargo/bin/cargo-chef /usr/local/cargo/bin/cargo-chef
COPY --link --from=tools /usr/local/cargo/bin/just /usr/local/cargo/bin/just

RUN rustup component add clippy

# support for `cargo +nightly fmt`
RUN rustup toolchain add nightly
RUN rustup component add --toolchain nightly rustfmt
