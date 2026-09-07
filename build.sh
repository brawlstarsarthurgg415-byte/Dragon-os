#!/usr/bin/env bash
# Build a bootable Dragon OS ISO from this archiso profile.
set -Eeuo pipefail

profile_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
work_dir="${WORK_DIR:-$profile_dir/work}"
out_dir="${OUT_DIR:-$profile_dir/out}"

cleanup_work_dir() {
  [[ -e "$work_dir" ]] || return 0

  # mkarchiso bind-mounts virtual filesystems below airootfs while it builds.
  # If a previous build was interrupted, removing the directory directly walks
  # into these mounts (/proc in particular), causing a long list of EPERM
  # messages. Unmount every nested mount first, deepest path first.
  while IFS= read -r mount_target; do
    umount "$mount_target" 2>/dev/null || umount -l "$mount_target" 2>/dev/null || {
      printf 'Erro: não foi possível desmontar o mount de build: %s\n' "$mount_target" >&2
      return 1
    }
  done < <(findmnt --recursive --noheadings --raw --output TARGET --target "$work_dir" 2>/dev/null | sort -r)

  rm -rf --one-file-system -- "$work_dir"
  if [[ -e "$work_dir" ]]; then
    printf 'Erro: não foi possível limpar o diretório de trabalho: %s\n' "$work_dir" >&2
    return 1
  fi
}

for command in mkarchiso pacman; do
  command -v "$command" >/dev/null 2>&1 || {
    printf 'Erro: %s não foi encontrado. Instale archiso e execute em Arch Linux.\n' "$command" >&2
    exit 1
  }
done

# The package list intentionally uses only official Arch repositories.
# This keeps the ISO buildable on a clean Arch host without an AUR helper.

cleanup_work_dir
mkdir -p "$out_dir"
mkarchiso -v -w "$work_dir" -o "$out_dir" "$profile_dir"
printf 'ISO criada em: %s\n' "$out_dir"
