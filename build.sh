#!/usr/bin/env bash
# Build a bootable Dragon OS ISO from this archiso profile.
set -Eeuo pipefail

profile_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
work_dir="${WORK_DIR:-$profile_dir/work}"
out_dir="${OUT_DIR:-$profile_dir/out}"

for command in mkarchiso pacman; do
  command -v "$command" >/dev/null 2>&1 || {
    printf 'Erro: %s não foi encontrado. Instale archiso e execute em Arch Linux.\n' "$command" >&2
    exit 1
  }
done

# The package list intentionally uses only official Arch repositories.
# This keeps the ISO buildable on a clean Arch host without an AUR helper.

rm -rf "$work_dir"
mkdir -p "$out_dir"
mkarchiso -v -w "$work_dir" -o "$out_dir" "$profile_dir"
printf 'ISO criada em: %s\n' "$out_dir"
