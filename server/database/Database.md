## PostgreSQL

Windows: Add path variable `C:/Program Files/PostgreSQL/13/bin/`

### Restore

```sql
CREATE DATABASE wrestling_scoreboard;
```

```
psql --file=./database/dump/PostgreSQL-wrestling_scoreboard-dump.sql --username=postgres --host=localhost --port=5432 wrestling_scoreboard
```

### Dump

```
pg_dump --dbname=wrestling_scoreboard --file=./database/dump/PostgreSQL-wrestling_scoreboard-dump.sql --schema=public --username=postgres --host=localhost --port=5432
```