A **simple, fast and easy to setup** local SQL learning environment that you can **use with any of your favorit editor**. It uses Docker and Postgres and ships with three sample databases and **roll back** to **factory-default** at each restart to experiment freely without fear of breaking anything.

## Preview
CLI only :
<img width="2183" height="1270" alt="image" src="https://github.com/user-attachments/assets/3dc4c4da-2411-44a1-a655-b00893bcf28a" />

Or using an IDE :
<img width="2102" height="1252" alt="image" src="https://github.com/user-attachments/assets/d981c952-1b10-4d23-b734-82cb3bbae2dd" />


## Features
- Postgres 16 in Docker (rootless friendly)
- Three sample databases: `northwind`, `chinook`, `school`
- Factory reset on restart (fresh seed each time)
- Interactive DB chooser with `psql`
- Sandbox SQL file runner for quick queries
- Two dataset sizes: `light` (~1k rows per table) and `heavy` (~26k rows total)

## How to install
Clone the repo:
```bash
git clone https://github.com/luniiya/test-SQL-playground
cd test-SQL-playground
```

Install docker :

## How to use
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
Now you are into the SQL server, you can run any request you want, even tho it's not really pleasent to use.

### The sandbox
Without stopping start.sh, open with your favourite editor newRequest.sql :
```bash
$EDITOR sandbox/newRequest.sql
```
then in this file you can write your request then run it with 
```bash
./sandbox/sendRequest.sh
```
For example :
<img width="2126" height="955" alt="image" src="https://github.com/user-attachments/assets/70bd6286-1e11-42c1-b8ec-e01c5c638bab" />

### How to stop the playground
when your done, stop the container:
```bash
./stop.sh
```

### How to wipe everything
Factory reset + re-seed, then open the chooser:
```bash
./restart.sh
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
