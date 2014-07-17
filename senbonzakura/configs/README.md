General Note
------------

This directory is used for storing configs used by both flask and the celery workers.

The config files are all `ini` format.

- `default.ini` is the default file used by the flask frontend.
- `worker.ini` is the default file used by the celery workers.

**Note:** `default.ini` and `worker.ini` both need to have the same DB and Cache URIs for the application to function properly.
Typically both default.ini and worker.ini are identical copies of one another.


MySQL Configuration
-------------------
When working with MySQL you need add a few things to the my.cnf config file for mysqld.

Under the `[mysqld]` section add:

1. `innodb_file_format = Barracuda`
2. `innodb_large_prefix = 1`
3. `innodb_file_per_table=true`

These are required to let InnoDB (the default MySQL storage engine) to store
keys longer than 255 chars.

You also need to create the database you specify in the DB URI (DB called 'partial' according to the default configs)
