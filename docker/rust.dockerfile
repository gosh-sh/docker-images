# syntax=docker/dockerfile:1.9

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


FROM --platform=${BUILDPLATFORM} rust-platform-builder AS chef-amd64
RUN cargo install cargo-chef --version ^0.1 --target x86_64-unknown-linux-gnu


FROM --platform=${BUILDPLATFORM} rust-platform-builder AS chef-arm64
RUN cargo install cargo-chef --version ^0.1 --target aarch64-unknown-linux-gnu

# TODO: add more platforms if needed

FROM chef-${TARGETARCH} AS chef


FROM rust-builder

WORKDIR /app

RUN \
    apt-get update && apt-get install -yq \
    build-essential \
    cmake

COPY --link --from=chef /usr/local/cargo/bin/cargo-chef /usr/local/cargo/bin/cargo-chef

RUN rustup component add clippy

# support for `cargo +nightly fmt`
RUN rustup toolchain add nightly
RUN rustup component add --toolchain nightly rustfmt
