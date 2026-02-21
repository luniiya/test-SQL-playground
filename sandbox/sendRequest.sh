#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="$ROOT_DIR/docker-compose.yml"
CONTAINER_NAME="test-sql-db"
SQL_FILE="$ROOT_DIR/sandbox/newRequest.sql"
DBS=(northwind chinook school hr)
LAST_DB_FILE="$ROOT_DIR/sandbox/last_db"

try_docker() {
  docker info >/dev/null 2>&1
}

ensure_docker() {
  if try_docker; then
    return 0
  fi

  # Try rootless socket if default isn't working.
  export DOCKER_HOST="unix:///run/user/$(id -u)/docker.sock"
  if try_docker; then
    return 0
  fi

  cat <<'MSG'
Docker is not reachable.
- If rootless Docker is running, ensure DOCKER_HOST is set to:
  unix:///run/user/$(id -u)/docker.sock
- Otherwise start Docker and try again.
MSG
  exit 1
}

choose_db() {
  echo "Choose a database:" >&2
  local i=1
  for db in "${DBS[@]}"; do
    echo "  $i) $db" >&2
    i=$((i + 1))
  done
  echo -n "> " >&2
  read -r choice
  if [[ ! "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#DBS[@]} )); then
    echo "Invalid selection." >&2
    exit 1
  fi
  echo "${DBS[$((choice - 1))]}"
}

ensure_docker

if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "Container ${CONTAINER_NAME} is not running. Start it with ./start.sh first." >&2
  exit 1
fi

if [[ ! -f "$SQL_FILE" ]]; then
  echo "Missing SQL file: $SQL_FILE" >&2
  exit 1
fi

if [[ -n "${1:-}" ]]; then
  db="$1"
elif [[ -f "$LAST_DB_FILE" ]]; then
  db="$(cat "$LAST_DB_FILE")"
else
  db="$(choose_db)"
fi

case " ${DBS[*]} " in
  *" $db "*) ;;
  *)
    echo "Unknown database: $db" >&2
    exit 1
    ;;
esac

printf '%s\n' "$db" > "$LAST_DB_FILE"
if [[ -z "${SEND_REQUEST_QUIET:-}" ]]; then
  echo "Running $SQL_FILE on database: $db"
fi

docker exec -i "$CONTAINER_NAME" psql -U postgres -d "$db" < "$SQL_FILE"
