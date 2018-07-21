#!/usr/bin/env bash

# Install and setup MySQL or MariaDB

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

operator=${operator:-$(id -rnu 1000 2>/dev/null)}

mysql_root_password=${mysql_root_password:-$operator}
mysql_setup_unsafe=${mysql_setup_unsafe:-}

codename=$(lsb_release -sc)

case $codename in
jessie|stretch)
	apt-get -y install --install-recommends -t "$codename-backports" \
		default-mysql-server \
		default-mysql-client \
		default-libmysqlclient-dev \
		#
	;;
*)
	apt-get -y install --install-recommends \
		default-mysql-server \
		default-mysql-client \
		default-libmysqlclient-dev \
		#
	;;
esac

default_mysql=mariadb
if [[ -n "$(dpkg-query -W -f='${Installed-Size}' 'mysql-server-*' 2>/dev/null || true)" ]]; then
	default_mysql=mysql
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

# Extra check for configuration changes
systemctl restart "$default_mysql"
systemctl is-active "$default_mysql"

systemctl stop "$default_mysql" && systemctl disable "$default_mysql"
