# syntax=docker/dockerfile:1.9

FROM debian:bookworm

RUN apt-get update && apt-get install -yq \
    build-essential \
    cmake
