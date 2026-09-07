#!/usr/bin/env bash
# First-login profile selector. It is intentionally user-scoped and safe to rerun.
set -Eeuo pipefail

state_dir="${XDG_CONFIG_HOME:-$HOME/.config}/dragon-os"
state_file="$state_dir/profile"
mkdir -p "$state_dir"

choose_profile() {
  if command -v zenity >/dev/null 2>&1 && [[ -n "${DISPLAY:-}" ]]; then
    zenity --list --radiolist --title="Dragon OS — configuração inicial" \
      --text="Qual experiência você prefere? Você poderá executar Dragon OS Setup novamente depois." \
      --column="Escolher" --column="Perfil" --column="Descrição" \
      TRUE "Noob" "Interface gráfica, menus e uso com mouse" \
      FALSE "Pro" "Atalhos, terminal e visual Rice" --width=720 --height=300 || true
  elif command -v dialog >/dev/null 2>&1; then
    dialog --stdout --title "Dragon OS" --menu "Escolha seu perfil:" 12 70 2 \
      noob "Interface gráfica, menus e mouse" \
      pro "Atalhos, terminal e visual Rice" || true
  else
    printf 'Escolha o perfil [noob/pro]: ' >&2
    read -r answer
    printf '%s\n' "$answer"
  fi
}

apply_noob() {
  xfconf-query -c xfce4-panel -p /panels -n -t int -s 1 >/dev/null 2>&1 || true
  xfconf-query -c xfce4-desktop -p /desktop-icons/style -n -t int -s 2 >/dev/null 2>&1 || true
  xfconf-query -c xsettings -p /Net/IconThemeName -n -t string -s Papirus >/dev/null 2>&1 || true
  printf 'noob\n' >"$state_file"
}

apply_pro() {
  mkdir -p "$HOME/.config/rofi"
  cat >"$HOME/.config/rofi/config.rasi" <<'RASI'
configuration { show-icons: true; modi: "drun,run,window"; }
@theme "gruvbox-dark"
RASI
  xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Super>space' -n -t string -s 'rofi -show drun' >/dev/null 2>&1 || true
  xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Super>Return' -n -t string -s terminator >/dev/null 2>&1 || true
  xfconf-query -c xsettings -p /Net/IconThemeName -n -t string -s Papirus-Dark >/dev/null 2>&1 || true
  printf 'pro\n' >"$state_file"
}

profile="$(choose_profile)"
case "${profile,,}" in
  noob) apply_noob ;;
  pro) apply_pro ;;
  *) exit 0 ;; # Closing the welcome dialog must not alter the desktop.
esac

if command -v zenity >/dev/null 2>&1 && [[ -n "${DISPLAY:-}" ]]; then
  zenity --info --title="Dragon OS" --text="Perfil ${profile^} aplicado. Para mudar depois, execute: dragon-setup.sh"
fi
