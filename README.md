# Test SQL Playground

A simple, terminal-first SQL learning environment using Docker and Postgres. It ships with three sample databases and a resettable factory-default dataset so students can experiment freely.

## Quick Start
```bash
./start.sh
```

## Features
- Postgres 16 in Docker (rootless friendly)
- Three sample databases: `northwind`, `chinook`, `school`
- Factory reset on restart (fresh seed each time)
- Interactive DB chooser with `psql`
- Sandbox SQL file runner for quick queries
- Two dataset sizes: `light` (~1k rows per table) and `heavy` (~26k rows total)

## Install / Download
Clone the repo:
```bash
git clone https://github.com/luniiya/test-SQL-playground
cd test-sql
```

If you are using rootless Docker, set the socket path once per shell:
```bash
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
```

## Use From Console
Start the environment and choose a database:
```bash
./start.sh
```

You can select a dataset size when starting:
```bash
./start.sh light
./start.sh heavy
```

Stop the container:
```bash
./stop.sh
```

Factory reset + re-seed, then open the chooser:
```bash
./restart.sh
```

## Use The Sandbox Runner
The sandbox lets you write SQL in a file and run it against a chosen database.

1. Edit the file:
```bash
$EDITOR sandbox/newRequest.sql
```

2. Execute it:
```bash
./sandbox/sendRequest.sh
```

## Database Structure Docs
See `docs/` for table + column and relationship summaries.

## Notes
- The database is ephemeral (tmpfs). Each fresh start is a clean seed.
- If you want to persist data instead, I can switch back to a volume.

## File Map
- `start.sh` — start + open DB chooser
- `stop.sh` — stop container
- `restart.sh` — wipe + re-seed + open chooser
- `sandbox/newRequest.sql` — your SQL scratch file (reset on start)
- `sandbox/sendRequest.sh` — runs the SQL scratch file
- `sql/init/` — seed SQL files
