## PostgreSQL

### Installation

#### Windows: 
Add path variable `C:/Program Files/PostgreSQL/13/bin/`

#### Linux:
```
sudo apt-get install postgresql
sudo apt install postgresql-client-common
sudo apt-get install postgresql-client
```
You may have to login as postgres user before any operations: `sudo -u postgres -i`, and then: `psql -U postgres`


#### Postgres Password: 
```sql
ALTER USER postgres WITH PASSWORD 'my_password';
```

### Import / Restore prepopulated database

```sql
CREATE DATABASE wrestling_scoreboard;
```

```
psql --file=./database/dump/PostgreSQL-wrestling_scoreboard-dump.sql --username=postgres --host=localhost --port=5432 wrestling_scoreboard
```

### Export / Dump existing database

```
pg_dump --dbname=wrestling_scoreboard --file=./database/dump/PostgreSQL-wrestling_scoreboard-dump.sql --schema=public --username=postgres --host=localhost --port=5432
```
