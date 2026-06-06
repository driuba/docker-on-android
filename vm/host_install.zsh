#!/usr/bin/env zsh

set -e

readonly dir="${0:A:h:h}"

virt-install \
	--name "xiaomi-davinci-build" \
	--os-variant "debian13" \
	--virt-type "kvm" \
	--memory "4096" \
	--memorybacking "source.type=memfd,access.mode=shared" \
	--vcpus "4" \
	--cpu "host" \
	--import \
	--disk "path=$dir/assets/debian-13-nocloud-amd64.qcow2" \
	--filesystem "type=mount,driver.type=virtiofs,source=$dir,target=source" \
	--graphics "none" \
	--boot "uefi"
