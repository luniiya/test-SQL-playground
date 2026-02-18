A **simple, fast, and easy‑to‑set‑up** local SQL learning environment that you can **use with any editor**. It uses Docker + Postgres and ships with three sample databases. It **rolls back to factory‑default** on each restart so you can experiment freely without fear of breaking anything.

## 🪼 Preview
CLI only:
<img width="900" alt="image" src="https://github.com/user-attachments/assets/3dc4c4da-2411-44a1-a655-b00893bcf28a" />

Or using an IDE:
<img width="900" alt="image" src="https://github.com/user-attachments/assets/d981c952-1b10-4d23-b734-82cb3bbae2dd" />

## ☄️ Features
- Postgres 16 in Docker (rootless friendly)
- Three sample databases: `northwind`, `chinook`, `school`
- Factory reset on restart (fresh seed each time)
- Interactive DB chooser with `psql`
- Sandbox SQL file runner for quick queries
- Two dataset sizes: `light` (~1k rows per table) and `heavy` (~26k rows total)

## 📦 Install
Clone the repo:
```bash
git clone https://github.com/luniiya/test-SQL-playground
cd test-SQL-playground
```

<details>
<summary>Install Docker (optional)</summary>

Most people already have Docker installed. If you don’t, use the official Docker installation guide for your OS and follow their recommended steps. Once installed, verify with:

```bash
docker --version
```
</details>

## 🧋 How To Use
### start
Start the environment and choose a database:
```bash
./start.sh
```
It should output something like :
```output
┌─[ayaya@moonmelon]-< test-sql on  main >
└─❯ ./start.sh
[+] up 2/2
 ✔ Network test-sql_default Created                                                                                      0.0s
 ✔ Container test-sql-db    Created                                                                                      0.0s
Waiting for Postgres to be healthy (seed data can take a few minutes on first start)...
Choose a database:
  1) northwind
  2) chinook
  3) school
> 3
Waiting for database 'school' to be created...
Opening psql on database: school
psql (16.12 (Debian 16.12-1.pgdg13+1))
Type "help" for help.

school=#
```
You’re now in the SQL server and can run any query you want (it’s not the most pleasant UI, but it works).

### The sandbox
Without stopping `start.sh`, open `sandbox/newRequest.sql` with your favorite editor:
```bash
$EDITOR sandbox/newRequest.sql
```
Write your SQL queries in that file, then run them with:
```bash
./sandbox/sendRequest.sh
```
For example :
<img width="900" alt="image" src="https://github.com/user-attachments/assets/70bd6286-1e11-42c1-b8ec-e01c5c638bab" />

### How to stop the playground
When you’re done, stop the container:
```bash
./stop.sh
```

### How to wipe everything
Factory reset + re-seed, then open the chooser:
```bash
./restart.sh
```

## 🗂️ Database Structure Docs
See `docs/` for table + column and relationship summaries.

## 📝 Notes
- The database is ephemeral (tmpfs). Each fresh start is a clean seed.
- If you want to persist data instead, I can switch back to a volume.

## 🧭 File Map
- `start.sh` — start + open DB chooser
- `stop.sh` — stop container
- `restart.sh` — wipe + re-seed + open chooser
- `sandbox/newRequest.sql` — your SQL scratch file (reset on start)
- `sandbox/sendRequest.sh` — runs the SQL scratch file
- `sql/init/` — seed SQL files
