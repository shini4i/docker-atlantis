FROM ghcr.io/runatlantis/atlantis:v0.20.1

ENV TRANSCRYPT_VERSION=2.2.0
ENV TERRAGRUNT_ATLANTIS_CONFIG_VERSION=1.16.0

USER root

RUN apk add --no-cache bash grep openssl util-linux

ADD --chown=atlantis:atlantis --chmod=700 \
    https://raw.githubusercontent.com/elasticdog/transcrypt/v${TRANSCRYPT_VERSION}/transcrypt \
    /bin/transcrypt

RUN curl -L -o terragrunt-atlantis-config.tar.gz https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64.tar.gz \
    && tar -xvf terragrunt-atlantis-config.tar.gz \
    && mv terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64 /bin/terragrunt-atlantis-config \
    && rm terragrunt-atlantis-config.tar.gz && rm -rf terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64/

USER atlantis
