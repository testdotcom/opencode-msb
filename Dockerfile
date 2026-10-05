# syntax=docker/dockerfile:1
FROM ghcr.io/anomalyco/opencode:2.0.22

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
