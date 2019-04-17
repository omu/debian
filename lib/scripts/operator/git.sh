#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

git_lfs=${git_lfs:true}
git_secrets=${git_secrets:true}
git_tig=${git_tig:-}

shopt -s nullglob

export DEBIAN_FRONTEND=noninteractive

cd "$(dirname "$0")/../../.."

apt-get -y install --no-install-recommends git

[[ -z ${git_lfs:-} ]] || apt-get -y install --no-install-recommends git-lfs
[[ -z ${git_tig:-} ]] || apt-get -y install --no-install-recommends tig

if [[ -n ${git_secrets:-} ]]; then
	curl -fsSL -o /usr/local/bin/git-secrets \
		https://raw.githubusercontent.com/awslabs/git-secrets/master/git-secrets
	chmod +x /usr/local/bin/git-secrets

	mkdir -p /usr/local/share/man/man1
	curl -fsSL -o /usr/local/share/man/man1/git-secrets.1 \
		https://raw.githubusercontent.com/awslabs/git-secrets/master/git-secrets.1
fi

curl -fsSL -o /usr/local/bin/git-hooks \
	https://raw.githubusercontent.com/alaturka/zoo/master/hooks/git-hooks
chmod +x /usr/local/bin/git-hooks

[[ -z $(echo etc/git/*) ]] || cp -a etc/git/* /etc/

git-hooks --install
