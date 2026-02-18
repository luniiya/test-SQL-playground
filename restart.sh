#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$ROOT_DIR/docker-compose.yml"

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

# Tear down and recreate so the database resets to the default seed data.
docker compose -f "$COMPOSE_FILE" down

exec "$ROOT_DIR/start.sh"
