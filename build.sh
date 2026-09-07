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

# Pamac GTK is not shipped by Arch's official repositories. Fail early with a
# useful message instead of producing a partial ISO when it is unavailable.
pacman -Si pamac-gtk >/dev/null 2>&1 || {
  printf '%s\n' 'Erro: pamac-gtk não está configurado no pacman.' \
    'Configure um repositório que forneça pamac-gtk (por exemplo, seu repositório Dragon OS) e tente novamente.' >&2
  exit 1
}

rm -rf "$work_dir"
mkdir -p "$out_dir"
mkarchiso -v -w "$work_dir" -o "$out_dir" "$profile_dir"
printf 'ISO criada em: %s\n' "$out_dir"
