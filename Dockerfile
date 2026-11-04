# syntax=docker/dockerfile:1
ARG OPENCODE_VERSION=latest
FROM ghcr.io/anomalyco/opencode:${OPENCODE_VERSION}

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
	drill

ENTRYPOINT ["/bin/sh"]
