# PostgreSQL Database

## Installation

### Windows: 

[Install Postgres](https://www.postgresql.org/download/windows/).
Then add this to your system PATH variable `C:/Program Files/PostgreSQL/<version>/bin/`

### Debian:

```shell
sudo apt install postgresql
sudo apt install postgresql-client-common
sudo apt install postgresql-client
```

## Setup

### Tipps:

- Open psql command line: `psql -U postgres`
- List all users: `\du`
- Start the database server: `postgres -D /.../PostgreSQL/16/data`

Login as admin:
```shell
PGPASSWORD=my-password
psql -U postgres # For creation and dropping
psql -U postgres -d wrestling_scoreboard # For altering database wrestling_scoreboard
psql -U postgres -d wrestling_scoreboard -c "SELECT semver FROM migration LIMIT 1;" # Run command
```

On Linux you may want to log in as postgres user: `sudo -u postgres -i`

Use this on peer authentication:
```shell
sudo -u postgres psql postgres # For creation and dropping
sudo -u postgres psql wrestling_scoreboard # For altering database wrestling_scoreboard
sudo -u postgres psql wrestling_scoreboard -c "SELECT semver FROM migration LIMIT 1;" # Run command
```

### User

Create own user `wrestling`, replace `my-password` with the password of your choice:
```shell
psql -U postgres -c "CREATE USER wrestling WITH PASSWORD 'my-password';"
```

### Import / Restore prepopulated database & schema

You can `Export`, `Restore`, `Reset` or `Upgrade` your database from the server web page.
Or you execute these steps manually:

Reset `wrestling_scoreboard` database from within the database `postgres`:
```shell
psql -U postgres -c "DROP DATABASE IF EXISTS wrestling_scoreboard;"
psql -U postgres -c "CREATE DATABASE wrestling_scoreboard WITH OWNER = wrestling;"
```

Assign `wrestling` as owner of `public` schema from within the database `wrestling_scoreboard`:
```shell
psql -U postgres -d wrestling_scoreboard -c "ALTER SCHEMA public OWNER TO wrestling;"
```

For peer authentication execute these commands inside the according psql shell.

Restore prepopulated database, execute in directory `server`:
```shell
psql --file=./database/dump/PostgreSQL-wrestling_scoreboard-dump.sql --username=wrestling --host=localhost --port=5432 wrestling_scoreboard
```

### Export / Dump existing database

Export database, execute in directory `server`:
```shell
pg_dump --dbname=wrestling_scoreboard --file=./database/dump/PostgreSQL-wrestling_scoreboard-dump.sql --schema=public --username=wrestling --host=localhost --port=5432
```
