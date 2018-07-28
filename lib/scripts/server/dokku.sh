#!/bin/bash

# Install latest Dokku

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

dokku_domain=${dokku_domain:-localtest.me}

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
	DOKKU_VHOST_ENABLE=true \
	DOKKU_HOSTNAME="$dokku_domain" \
	DOKKU_KEY_FILE="$keyfile" \
	\
	bash -s

rm -f "$keyfile"

dokku plugin:install https://github.com/dokku/dokku-postgres.git
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
dokku plugin:install https://github.com/dokku/dokku-http-auth.git
dokku plugin:install https://github.com/dokku/dokku-redirect.git
dokku plugin:install https://github.com/dokku/dokku-maintenance.git

apt-get install -y herokuish parallel dokku-update
