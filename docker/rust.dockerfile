# syntax=docker/dockerfile:1.9

FROM rust:latest

WORKDIR /app

RUN \
    apt-get update && apt-get install -yq \
    build-essential \
    cmake

RUN cargo install cargo-chef --version ^0.1

RUN rustup component add clippy

# support for `cargo +nightly fmt`
RUN rustup toolchain add nightly
RUN rustup component add --toolchain nightly rustfmt
