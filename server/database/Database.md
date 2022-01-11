## PostgreSQL

### Installation

#### Windows: 
Add path variable `C:/Program Files/PostgreSQL/<version>/bin/`

#### Linux:
```
sudo apt-get install postgresql
sudo apt install postgresql-client-common
sudo apt-get install postgresql-client
```

You have to login as postgres user before any operations: `sudo -u postgres -i`, and then: `psql -U postgres`
List all users: `\du`

#### Postgres Password: 
```sql
CREATE USER wrestling WITH PASSWORD 'my_password';
DROP DATABASE IF EXISTS wrestling_scoreboard;
CREATE DATABASE wrestling_scoreboard;
GRANT ALL PRIVILEGES ON DATABASE wrestling_scoreboard to wrestling;
\q
```

### Import / Restore prepopulated database

```
psql --file=./database/dump/PostgreSQL-wrestling_scoreboard-dump.sql --username=wrestling --host=localhost --port=5432 wrestling_scoreboard
```

### Export / Dump existing database

```
pg_dump --dbname=wrestling_scoreboard --file=./database/dump/PostgreSQL-wrestling_scoreboard-dump.sql --schema=public --username=wrestling --host=localhost --port=5432
```
