# syntax=docker/dockerfile:1.9

FROM python:3.12.0-bookworm AS base

RUN pip install ansible==10.2.0

WORKDIR /ansible

ENTRYPOINT [ "ansible" ]
CMD [ "--version" ]
