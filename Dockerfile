ARG ATLANTIS_VERSION

FROM runatlantis/atlantis:$ATLANTIS_VERSION

ENV TRANSCRYPT_VERSION 2.1.0

USER root

RUN apk add --no-cache bash grep openssl util-linux \
 && cd /usr/local \
 && git clone https://github.com/elasticdog/transcrypt.git \
 && cd transcrypt && git checkout v${TRANSCRYPT_VERSION} \
 && ln -s ${PWD}/transcrypt /bin/transcrypt

USER atlantis
