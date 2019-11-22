#!/usr/bin/env bash
# vim: et:ts=2:sts=2:sw=2

CACHE_DIR="${XDG_CACHE_HOME:-"$HOME/.cache"}"/tmux-info
[ -d "$CACHE_DIR" ] || mkdir -p -- "$CACHE_DIR"

get_tmux_option() {
  local option default_value option_value

  option="$1"
  default_value="$2"
  option_value="$(tmux show-option -gqv "$option")"

  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

get_cache_filename() {
  local module="$1"

  echo "$CACHE_DIR"/"$module"
}

