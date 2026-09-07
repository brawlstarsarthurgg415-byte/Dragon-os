#!/usr/bin/env bash
# shellcheck shell=bash
iso_name="dragonos"
iso_label="DRAGONOS_$(date +%Y%m)"
iso_publisher="Dragon OS <https://dragonos.local>"
iso_application="Dragon OS Live/Install Medium"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
# Current archiso boot modes: legacy BIOS via Syslinux and 64-bit UEFI via systemd-boot.
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/sudoers.d/00-wheel"]="0:0:440"
  ["/usr/local/bin/dragon-setup.sh"]="0:0:755"
  ["/usr/local/bin/dragon-launch-installer"]="0:0:755"
)
