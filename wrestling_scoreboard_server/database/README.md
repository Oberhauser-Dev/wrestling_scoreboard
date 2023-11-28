## PostgreSQL

### Installation

#### Windows: 

[Install Postgres](https://www.postgresql.org/download/windows/).
Then add path the variable `C:/Program Files/PostgreSQL/<version>/bin/`

#### Linux:

```shell
sudo apt-get install postgresql
sudo apt install postgresql-client-common
sudo apt-get install postgresql-client
```

On Linux you may want to login as postgres user: `sudo -u postgres -i`

#### Tipps:

- Open psql command line: `psql -U postgres`
- List all users: `\du`
- Start the server: `postgres -D /.../PostgreSQL/16/data`

### Setup User: 

Create own user `wrestling`, replace `my_password` with the password of your choice:
```shell
psql -U postgres -c "CREATE USER wrestling WITH PASSWORD 'my_password';"
```

### Import / Restore prepopulated database & schema

Reset current database:
```shell
# sudo -u postgres psql # Use this on peer authentication
psql -U postgres
postgres=#
```
```postgresql
DROP DATABASE IF EXISTS wrestling_scoreboard;
CREATE DATABASE wrestling_scoreboard WITH OWNER = wrestling;
```

Restore prepopulated database, execute in directory `server`:
```shell
psql --file=./database/dump/PostgreSQL-wrestling_scoreboard-dump.sql --username=wrestling --host=localhost --port=5432 wrestling_scoreboard
```

### Export / Dump existing database

Export database, execute in directory `server`:
```shell
pg_dump --dbname=wrestling_scoreboard --file=./database/dump/PostgreSQL-wrestling_scoreboard-dump.sql --schema=public --username=wrestling --host=localhost --port=5432
```
