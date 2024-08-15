# syntax=docker/dockerfile:1.9

# build cargo chef faster via multiarch build
FROM rust:latest AS rust-builder


ARG BUILDPLATFORM
FROM --platform=$BUILDPLATFORM rust-builder AS chef-amd64
RUN rustup target add x86_64-unknown-linux-gnu
RUN cargo install cargo-chef --version ^0.1 --target x86_64-unknown-linux-gnu


ARG BUILDPLATFORM
FROM --platform=$BUILDPLATFORM rust-builder AS chef-arm64
RUN rustup target add aarch64-unknown-linux-gnu
RUN cargo install cargo-chef --version ^0.1 --target aarch64-unknown-linux-gnu

# TODO: add more platforms if needed

ARG TARGETARCH
FROM chef-${TARGETARCH} AS chef


FROM rust:latest

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
