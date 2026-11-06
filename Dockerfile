# syntax=docker/dockerfile:1
ARG OPENCODE_VERSION=latest
FROM ghcr.io/anomalyco/opencode:${OPENCODE_VERSION}

ARG UID=1000

ENV NPM_CONFIG_PREFIX=/home/opencode/.local \
    PATH=/home/opencode/.local/bin:${PATH}

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

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

ENTRYPOINT ["/bin/zsh"]
