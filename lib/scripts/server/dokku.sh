#!/bin/bash

# Install latest Dokku

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

dokku_domain=${dokku_domain:-paas}

latest=$(
	curl -fsSL https://api.github.com/repos/dokku/dokku/releases/latest |
	jq -r .tag_name
)

keyfile=/tmp/vagrant.pub

# Use Vagrant insecure key
curl -fsSL https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub >"$keyfile"

curl -fsSL https://raw.githubusercontent.com/dokku/dokku/"$latest"/bootstrap.sh |
	DOKKU_TAG="$latest" \
	DOKKU_WEB_CONFIG=false \
	DOKKU_VHOST_ENABLE=false \
	DOKKU_HOSTNAME="$dokku_domain" \
	DOKKU_KEY_FILE="$keyfile" \
	\
	bash -s

rm -f "$keyfile"

# Workaround against the installer bug
dokku domains:set-global "$dokku_domain"

dokku plugin:install https://github.com/dokku/dokku-postgres.git
dokku plugin:install https://github.com/dokku/dokku-redis.git
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

apt-get install -y herokuish parallel dokku-update
