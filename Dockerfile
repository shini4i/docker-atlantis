FROM alpine:3.22 as BASE

ARG TARGETARCH

ENV TRANSCRYPT_VERSION=2.3.1
ENV TERRAGRUNT_VERSION=0.93.10
ENV TERRAGRUNT_ATLANTIS_CONFIG_VERSION=1.21.0
ENV INFRACOST_VERSION=0.10.42
ENV ATLANTIS_EMOJI_GATE_VERSION=0.4.0

RUN apk add --no-cache curl

ADD https://raw.githubusercontent.com/elasticdog/transcrypt/v${TRANSCRYPT_VERSION}/transcrypt /usr/local/bin/transcrypt

RUN curl -L -o /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_${TARGETARCH} \
 && chmod +x /usr/local/bin/terragrunt

RUN curl -L -o terragrunt-atlantis-config https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_${TARGETARCH} \
 && mv terragrunt-atlantis-config /usr/local/bin/terragrunt-atlantis-config

ADD https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-${TARGETARCH}.tar.gz /tmp

RUN tar xf /tmp/infracost-linux-${TARGETARCH}.tar.gz -C /usr/local/bin \
 && mv /usr/local/bin/infracost-linux-${TARGETARCH} /usr/local/bin/infracost

ADD https://github.com/shini4i/atlantis-emoji-gate/releases/download/v${ATLANTIS_EMOJI_GATE_VERSION}/atlantis-emoji-gate_${ATLANTIS_EMOJI_GATE_VERSION}_linux_${TARGETARCH}.tar.gz /tmp

RUN tar xf /tmp/atlantis-emoji-gate_${ATLANTIS_EMOJI_GATE_VERSION}_linux_${TARGETARCH}.tar.gz -C /usr/local/bin

FROM ghcr.io/runatlantis/atlantis:v0.36.0

USER root

RUN apk add --no-cache bash grep openssl util-linux

COPY --from=BASE --chown=atlantis:atlantis --chmod=0700 /usr/local/bin/transcrypt /usr/local/bin/transcrypt
COPY --from=BASE --chown=atlantis:atlantis --chmod=0700 /usr/local/bin/terragrunt /usr/local/bin/terragrunt
COPY --from=BASE --chown=atlantis:atlantis --chmod=0700 /usr/local/bin/terragrunt-atlantis-config /usr/local/bin/terragrunt-atlantis-config
COPY --from=BASE --chown=atlantis:atlantis --chmod=0700 /usr/local/bin/infracost /usr/local/bin/infracost
COPY --from=BASE --chown=atlantis:atlantis --chmod=0700 /usr/local/bin/atlantis-emoji-gate /usr/local/bin/atlantis-emoji-gate

USER atlantis
