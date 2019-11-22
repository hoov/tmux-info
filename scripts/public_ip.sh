#!/usr/bin/env bash
# vim: et:ts=2:sts=2:sw=2

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=helpers.sh
source "$CURRENT_DIR/helpers.sh"

public_ip_poll_period=
public_ip_type=

public_ip_default_poll_period=6
public_ip_default_type=4

get_public_ip_settings() {
  public_ip_poll_period=$(get_tmux_option "@public_ip_poll_period" $public_ip_default_poll_period)
  public_ip_type=$(get_tmux_option "@public_ip_type" $public_ip_default_type)
}

refresh_public_ip() {
  local cache
  local curl_cmd="curl -${public_ip_type} -s ifconfig.co/json"
  cache=$(get_cache_filename "public_ip")

  echo "LAST_CHECK=$(date +%s)" > "$cache"
  $curl_cmd | jq -r 'del(.user_agent)|del(.ip_decimal)|to_entries|map("\(.key|ascii_upcase)=\"\(.value)\"")|.[]' >> "$cache"
}

get_public_ip() {
  local cache
  cache=$(get_cache_filename "public_ip")

  if [[ ! -f "$cache" ]]; then
    refresh_public_ip
  fi

  # shellcheck disable=SC1090
  source "$cache"

  if [[ $((LAST_CHECK + public_ip_poll_period)) -lt $(date +%s) ]]; then
    refresh_public_ip
    # shellcheck disable=SC1090
    source "$cache"
  fi

  echo "$IP"
}

main() {
  get_public_ip_settings

  get_public_ip
}

main
