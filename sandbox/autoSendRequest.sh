#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SANDBOX_DIR="${ROOT_DIR}/sandbox"
DEFAULT_SQL_FILE="${SANDBOX_DIR}/newRequest.sql"
WATCH_TARGET="${1:-$DEFAULT_SQL_FILE}"
shift "$(( $# > 0 ? 1 : 0 ))"

VERBOSE="${AUTO_SEND_VERBOSE:-0}"

if [[ ! -f "$WATCH_TARGET" ]]; then
  echo "Watch target not found: $WATCH_TARGET" >&2
  exit 1
fi

SEND_REQUEST_SCRIPT="${SANDBOX_DIR}/sendRequest.sh"
if [[ ! -x "$SEND_REQUEST_SCRIPT" ]]; then
  echo "sendRequest.sh is missing or not executable: $SEND_REQUEST_SCRIPT" >&2
  exit 1
fi

get_mtime() {
  local file="$1"
  if stat -c %Y "$file" >/dev/null 2>&1; then
    stat -c %Y "$file"
  else
    stat -f %m "$file"
  fi
}

run_send_request() {
  if [[ "$VERBOSE" -eq 1 ]]; then
    echo "Running sendRequest.sh for $WATCH_TARGET"
  fi
  if ! SEND_REQUEST_QUIET=$(( VERBOSE == 0 ? 1 : 0 )) "$SEND_REQUEST_SCRIPT" "$@"; then
    echo "sendRequest.sh exited with an error; continuing to watch." >&2
  fi
}

last_mtime="$(get_mtime "$WATCH_TARGET")"
run_send_request "$@"

printf 'Watching %s for overwrites. Press q or Ctrl+C to stop.\n' "$WATCH_TARGET"

while true; do
  if IFS= read -r -t 0.5 -n 1 input; then
    if [[ "$input" == "q" || "$input" == "Q" ]]; then
      echo "Stopping watcher."
      break
    fi
  fi
  current_mtime="$(get_mtime "$WATCH_TARGET")"
  if [[ "$current_mtime" != "$last_mtime" ]]; then
    last_mtime="$current_mtime"
    run_send_request "$@"
  fi
done
