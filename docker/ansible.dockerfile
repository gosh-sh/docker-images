# syntax=docker/dockerfile:1.9

FROM alpine AS base

RUN apk --update --no-cache add \
        ca-certificates \
        git \
        openssh-client \
        openssl \
        py3-cryptography \
        py3-pip \
        py3-yaml \
        python3\
        rsync \
        sshpass

RUN apk --update --no-cache add --virtual \
        .build-deps \
        build-base \
        curl \
        libffi-dev \
        openssl-dev \
        python3-dev \
  && pip3 install --root-user-action=ignore --break-system-packages --no-cache-dir --upgrade \
        pip \
  && pip3 install --root-user-action=ignore --break-system-packages --no-cache-dir --upgrade --no-binary \
        cffi \
        ansible \
        mitogen \
  && apk del \
          .build-deps \
  && rm -rf /var/cache/apk/* \
  && find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
  && find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf

RUN mkdir -p /etc/ansible \
  && echo 'localhost' > /etc/ansible/hosts \
  && echo -e """\
\n\
Host *\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
""" >> /etc/ssh/ssh_config

WORKDIR /ansible

ENTRYPOINT [ "ansible" ]
CMD [ "--version" ]
