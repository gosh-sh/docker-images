# syntax=docker/dockerfile:1.20

FROM debian:trixie

RUN apt-get update && apt-get install -yq \
    build-essential \
    cmake
