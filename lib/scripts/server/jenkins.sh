#!/usr/bin/env bash

# Install jenkins

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

curl -fsSL http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
echo 'deb http://pkg.jenkins-ci.org/debian binary/' >/etc/apt/sources.list.d/jenkins.list

apt-get -y update
apt-get -y install jenkins
