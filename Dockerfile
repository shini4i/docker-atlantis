FROM ghcr.io/runatlantis/atlantis:v0.19.9

ENV TRANSCRYPT_VERSION=2.2.0

USER root

RUN apk add --no-cache bash grep openssl util-linux

ADD --chown=atlantis:atlantis --chmod=700 \
    https://raw.githubusercontent.com/elasticdog/transcrypt/v${TRANSCRYPT_VERSION}/transcrypt \
    /bin/transcrypt

USER atlantis
