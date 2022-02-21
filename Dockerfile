ARG ATLANTIS_VERSION

FROM runatlantis/atlantis:$ATLANTIS_VERSION

ENV TRANSCRYPT_VERSION 2.1.0

USER root

RUN apk add --no-cache bash grep openssl util-linux

ADD --chown=atlantis:atlantis --chmod=700 \
    https://raw.githubusercontent.com/elasticdog/transcrypt/v${TRANSCRYPT_VERSION}/transcrypt \
    /bin/transcrypt

USER atlantis
