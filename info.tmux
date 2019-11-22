#!/usr/bin/env bash
# vim: et:ts=2:sts=2:sw=2

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/scripts/helpers.sh"

info_interpolation=(
  "\${public_ip}"
)

info_commands=(
  "#($CURRENT_DIR/scripts/public_ip.sh)"
)

set_tmux_option() {
  local option=$1
  local value=$2
  tmux set-option -gq "$option" "$value"
}

do_interpolation() {
  local all_interpolated="$1"
  for ((i=0; i<${#info_commands[@]}; i++)); do
    all_interpolated=${all_interpolated/${info_interpolation[$i]}/${info_commands[$i]}}
  done
  echo "$all_interpolated"
}

update_tmux_option() {
  local option=$1
  local option_value new_option_value

  option_value=$(get_tmux_option "$option")
  new_option_value=$(do_interpolation "$option_value")
  set_tmux_option "$option" "$new_option_value"
}

main() {
  update_tmux_option "status-right"
  update_tmux_option "status-left"
}
main
