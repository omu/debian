#!/usr/bin/env bash

# Minimize virtual machine disk size

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

# Copyright 2012-2014, Chef Software, Inc. (<legal@chef.io>)
# Copyright 2011-2012, Tim Dysinger (<tim@dysinger.net>)

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap); then
	echo "Fill with 0 the swap partition to reduce box size"
	swappart=$(readlink -f /dev/disk/by-uuid/"$swapuuid")
	/sbin/swapoff "$swappart"
	dd if=/dev/zero of="$swappart" bs=1M || echo "dd exit code $? is suppressed"
	/sbin/mkswap -U "$swapuuid" "$swappart"
fi

echo "Fill filesystem with 0 to reduce box size"
count=$(($(df --sync -kP / | awk -F ' ' 'END { print $4 }') - 1))
dd if=/dev/zero of=/tmp/whitespace bs=512 count=$count || echo "dd exit code $? is suppressed"
rm -f /tmp/whitespace
# Block until the empty file has been removed, otherwise, Packer
# will try to kill the box while the disk is still full and that's bad
sync || echo "sync exit code $? is suppressed"
