#!/bin/bash

# Install latest Dokku

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

latest=$(
	curl -fsSL https://api.github.com/repos/dokku/dokku/releases/latest |
	jq -r .tag_name
)

host=$(hostname).local

keyfile=/tmp/vagrant.pub

# Use Vagrant insecure key
curl -fsSL https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub >"$keyfile"

curl -fsSL https://raw.githubusercontent.com/dokku/dokku/v0.12.10/bootstrap.sh |
	DOKKU_TAG="$latest" \
	DOKKU_WEB_CONFIG=false \
	DOKKU_VHOST_ENABLE=false \
	DOKKU_HOSTNAME="$host" \
	DOKKU_KEY_FILE="$keyfile" \
	\
	bash -s

rm -f "$keyfile"

# Workaround against the installer bug
dokku domains:set-global "$host"

dokku plugin:install https://github.com/dokku/dokku-postgres.git
dokku plugin:install https://github.com/dokku/dokku-redis.git
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

apt-get install -y herokuish parallel dokku-update
