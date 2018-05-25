#!/usr/bin/env bash

# Install and setup MySQL or MariaDB

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

operator=${operator:-$(id -rnu 1000 2>/dev/null)}

mysql_use_mariadb=${mysql_use_mariadb:-}
mysql_root_password=${mysql_root_password:-$operator}
mysql_setup_unsafe=${mysql_setup_unsafe:-}

if [[ -z $mysql_use_mariadb ]]; then
	apt-get -y install --no-install-recommends \
		mysql-server \
		mysql-client \
		libmysqlclient-dev \
		#
else
	apt-get -y install --no-install-recommends \
		mariadb-server \
		libmariadbd-dev \
		#

	if [[ $(lsb_release -sc) == jessie ]]; then
		apt-get -y install --no-install-recommends libmariadb-client-lgpl-dev-compat
	else
		apt-get -y install --no-install-recommends libmariadbclient-dev-compat
	fi
fi

apt-get -y install --no-install-recommends \
	automysqlbackup \
	#

mysql -u root <<-EOF
	UPDATE mysql.user SET password = password('$mysql_root_password') WHERE user = 'root';
	FLUSH PRIVILEGES;
EOF

[[ -n $mysql_setup_unsafe ]] || mysql -u root --password="$mysql_root_password" <<-EOF
	DELETE FROM mysql.user WHERE user = 'root' AND host NOT IN ('localhost', '127.0.0.1', '::1');
	DELETE FROM mysql.user WHERE user = '';
	DELETE FROM mysql.db WHERE db = 'test' OR db = 'test_%';
	FLUSH PRIVILEGES;
EOF

cat >/etc/mysql/conf.d/local.cnf <<-EOF
	[mysqld]
	skip-host-cache
	skip-name-resolve
EOF

service=mysql; [[ -z $mysql_use_mariadb ]] || service=mariadb

# Extra check for configuration changes
systemctl restart "$service"
systemctl is-active "$service"

systemctl stop "$service" && systemctl disable "$service"
