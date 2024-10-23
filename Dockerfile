FROM alpine:3.20 as BASE

ENV TRANSCRYPT_VERSION=2.3.0
ENV TERRAGRUNT_VERSION=0.68.4
ENV TERRAGRUNT_ATLANTIS_CONFIG_VERSION=1.18.0
ENV INFRACOST_VERSION=0.10.39

RUN apk add --no-cache curl

ADD https://raw.githubusercontent.com/elasticdog/transcrypt/v${TRANSCRYPT_VERSION}/transcrypt /usr/local/bin/transcrypt

RUN curl -L -o /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 \
    && chmod +x /usr/local/bin/terragrunt

RUN curl -L -o terragrunt-atlantis-config https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64 \
    && mv terragrunt-atlantis-config /usr/local/bin/terragrunt-atlantis-config

ADD https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-amd64.tar.gz /tmp

RUN tar xf /tmp/infracost-linux-amd64.tar.gz -C /usr/local/bin

FROM ghcr.io/runatlantis/atlantis:v0.30.0

USER root

RUN apk add --no-cache bash grep openssl util-linux

COPY --from=BASE --chown=atlantis:atlantis --chmod=0700 /usr/local/bin/transcrypt /usr/local/bin/transcrypt
COPY --from=BASE --chown=atlantis:atlantis --chmod=0700 /usr/local/bin/terragrunt /usr/local/bin/terragrunt
COPY --from=BASE --chown=atlantis:atlantis --chmod=0700 /usr/local/bin/terragrunt-atlantis-config /usr/local/bin/terragrunt-atlantis-config
COPY --from=BASE --chown=atlantis:atlantis --chmod=0700 /usr/local/bin/infracost-linux-amd64 /usr/local/bin/infracost

USER atlantis
