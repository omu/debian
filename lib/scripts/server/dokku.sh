#!/bin/bash

# Install latest Dokku

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

dokku_plugins=${dokku_plugins:-'letsencrypt http-auth redirect maintenance'}

declare -A plugins=(
	[copy-files-to-image]='https://github.com/dokku/dokku-copy-files-to-image.git'
	[couchdb]='https://github.com/dokku/dokku-couchdb.git'
	[elasticsearch]='https://github.com/dokku/dokku-elasticsearch.git'
	[graphite-graphana]='https://github.com/dokku/dokku-graphite-grafana.git'
	[http-auth]='https://github.com/dokku/dokku-http-auth.git'
	[letsencrypt]='https://github.com/dokku/dokku-letsencrypt.git'
	[maintenance]='https://github.com/dokku/dokku-maintenance.git'
	[mariadb]='https://github.com/dokku/dokku-mariadb.git'
	[memcached]='https://github.com/dokku/dokku-memcached.git'
	[mongo]='https://github.com/dokku/dokku-mongo.git'
	[mysql]='https://github.com/dokku/dokku-mysql.git'
	[nats]='https://github.com/dokku/dokku-nats.git'
	[postgres]='https://github.com/dokku/dokku-postgres.git'
	[rabbitmq]='https://github.com/dokku/dokku-rabbitmq.git'
	[redirect]='https://github.com/dokku/dokku-redirect.git'
	[redis]='https://github.com/dokku/dokku-redis.git'
	[rethinkdb]='https://github.com/dokku/dokku-rethinkdb.git'
)

latest=$(
	curl -fsSL https://api.github.com/repos/dokku/dokku/releases/latest |
	jq -r .tag_name
)

curl -fsSL https://raw.githubusercontent.com/dokku/dokku/"$latest"/bootstrap.sh |
	DOKKU_TAG="$latest" \
	DOKKU_VHOST_ENABLE=true \
	DOKKU_SKIP_KEY_FILE=true \
	DOKKU_WEB_CONFIG=false \
	\
	bash -s

apt-get install -y herokuish parallel dokku-update

for plugin in ${dokku_plugins:-}; do
	url=${plugins[$plugin]:-}
	[[ -n $url ]] || continue
	dokku plugin:install "$url" "$plugin"
done

# Workaround for Dokku vs LFS incompatibility.  Note that this is insufficient.
# At the local side, you need to add --no-verify option to git-push.  Example:
#	git push --no-verify dokku REMOTE REFSPEC
if command -v git-lfs &>/dev/null; then
	git lfs install --system --skip-smudge --force
fi
