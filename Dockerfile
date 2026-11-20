# syntax=docker/dockerfile:1
FROM fedora:45

ARG OPENCODE_VERSION=latest
ARG UID=1000

RUN --mount=type=cache,target=/var/cache/libdnf5,sharing=locked \
    dnf upgrade -y --setopt=keepcache=True \
    && dnf install -y --setopt=install_weak_deps=False --setopt=keepcache=True \
	  neovim \
	  git \
	  curl \
	  unzip \
	  tar \
	  gzip \
	  ripgrep \
	  fd-find \
    nodejs24 \
    nodejs24-npm \
	  fzf \
	  jq \
	  shellcheck \
	  ca-certificates \
	  ldns-utils \
    zsh

RUN groupadd --gid ${UID} opencode \
    && useradd --uid ${UID} --gid ${UID} --create-home --shell /bin/zsh opencode

USER opencode
WORKDIR /home/opencode

ENV XDG_BIN_HOME=/home/opencode/.local/bin
ENV NPM_CONFIG_PREFIX=/home/opencode/.local
ENV PATH="/home/opencode/.opencode/bin:${XDG_BIN_HOME}:${PATH}"

RUN --mount=type=cache,target=/home/opencode/.npm,uid=${UID},gid=${UID} \
    set -eux; \
    npm install -g \
    firecrawl-cli@latest \
    slopsift@latest

RUN set -eux; \
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o /tmp/zsh-install.sh; \
    sh /tmp/zsh-install.sh --unattended; \
    rm /tmp/zsh-install.sh

RUN set -eux; \
    curl -fsSL https://opencode.ai/v2/install -o /tmp/opencode-install.sh; \
    sh /tmp/opencode-install.sh ${OPENCODE_VERSION:+--version "$OPENCODE_VERSION"}; \
    rm /tmp/opencode-install.sh

ENTRYPOINT ["zsh"]
