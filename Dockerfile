# syntax=docker/dockerfile:1
ARG OPENCODE_VERSION=latest
FROM ghcr.io/anomalyco/opencode:${OPENCODE_VERSION}

ARG UID=1000

RUN apk add --no-cache \
	  neovim \
	  git \
	  curl \
	  unzip \
	  tar \
	  gzip \
	  ripgrep \
	  fd \
	  fzf \
	  build-base \
	  nodejs \
	  npm \
	  python3 \
	  jq \
	  shellcheck \
	  ca-certificates \
	  drill \
    zsh

RUN addgroup -g ${UID} opencode \
    && adduser -D -u ${UID} -G opencode -s /bin/zsh opencode

USER opencode
WORKDIR /home/opencode

ENV XDG_BIN_HOME=/home/opencode/.local/bin
ENV XDG_CONFIG_HOME=/home/opencode/.config
ENV NPM_CONFIG_PREFIX=/home/opencode/.local
ENV PATH="${XDG_BIN_HOME}:${PATH}"

RUN set -eux; \
    npm install -g npm@latest firecrawl-cli@latest; \
    npm cache clean

RUN set -eux; \
    cd /tmp; \
    curl -fsSLO https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh; \
    sh install.sh --unattended; \
    rm install.sh

ENTRYPOINT ["/bin/zsh"]
