#!/bin/bash

# Install latest Dokku

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

latest=$(
	curl -fsSL https://api.github.com/repos/dokku/dokku/releases/latest |
	jq -r .tag_name
)

curl -fsSL https://raw.githubusercontent.com/dokku/dokku/"$latest"/bootstrap.sh |
	DOKKU_TAG="$latest" \
	DOKKU_WEB_CONFIG=false \
	DOKKU_VHOST_ENABLE=true \
	\
	bash -s

dokku plugin:install https://github.com/dokku/dokku-postgres.git
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
dokku plugin:install https://github.com/dokku/dokku-http-auth.git
dokku plugin:install https://github.com/dokku/dokku-redirect.git
dokku plugin:install https://github.com/dokku/dokku-maintenance.git

apt-get install -y herokuish parallel dokku-update
