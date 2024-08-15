# syntax=docker/dockerfile:1.9

FROM python:3.12.0-bookworm AS base

ENV PIP_ROOT_USER_ACTION=ignore
RUN <<EOF
    pip install --upgrade pip
    pip install ansible==10.3.0
    ansible --version
EOF

WORKDIR /ansible

ENTRYPOINT [ "ansible" ]
CMD [ "--version" ]
