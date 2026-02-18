#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$ROOT_DIR/docker-compose.yml"
INIT_LINK="$ROOT_DIR/sql/init"
LAST_DATASET_FILE="$ROOT_DIR/sandbox/last_dataset"

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

ensure_docker

# Reset the sandbox SQL file on each start.
cat > "$ROOT_DIR/sandbox/newRequest.sql" <<'EOF'
-- Write your SQL here. End statements with semicolons.
-- Example:
-- SELECT * FROM students;
EOF

choose_dataset() {
  echo "Choose dataset size:" >&2
  echo "  1) light (~1k rows per table)" >&2
  echo "  2) heavy (~26k rows total)" >&2
  echo -n "> " >&2
  read -r choice
  case "$choice" in
    1) echo "light" ;;
    2) echo "heavy" ;;
    *) echo "Invalid selection." >&2; exit 1 ;;
  esac
}

dataset="${1:-}"
if [[ -z "$dataset" && -f "$LAST_DATASET_FILE" ]]; then
  dataset="$(cat "$LAST_DATASET_FILE")"
fi

if [[ "$dataset" != "light" && "$dataset" != "heavy" ]]; then
  dataset="$(choose_dataset)"
fi

printf '%s\n' "$dataset" > "$LAST_DATASET_FILE"
rm -rf "$INIT_LINK"
ln -s "$ROOT_DIR/sql/init-$dataset" "$INIT_LINK"

# Ensure a clean seed every start.
docker compose -f "$COMPOSE_FILE" down >/dev/null 2>&1 || true

# Delegate to the main entry script so it prompts for a database.
exec "$ROOT_DIR/scripts/sql-env" start
