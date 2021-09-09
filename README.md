# jore4-mssql-testdb

Dockerized MSSQL database for mocking JORE3 data. This is not meant to be used
in production, only for running end-to-end tests.

Docker image is based on
[mcr.microsoft.com/mssql/server](https://hub.docker.com/_/microsoft-mssql-server)

## Docker reference

Warnings:

The mssql service starts up with a different password so that it cannot be
connected while the migrations are running. When the migrations are done, the
password is restored to the one defined with `SA_PASSWORD`.

Versions:

`hsldevcom/jore4-mssql-testdb:empty` - only runs the mssql server, no db
instance gets created. (But the default `master` db still exists)

`hsldevcom/jore4-mssql-testdb:schema-only` - contains a db with the name
`jore3testdb` with schema only.

TODO: `hsldevcom/jore4-mssql-testdb:with-dump` - contains a db with the name
`jore3testdb` and some additional test data.

Ports:

TCP port `1433` used to connect to the MSSQL database instance.

Volumes:

`/data`: for importing dump data. Can also extend the `:schema-only` or
`:with-dump` versions.

Environment variables:

| Environment variable | Example   | Description                                                                 |
| -------------------- | --------- | --------------------------------------------------------------------------- |
| SA_PASSWORD          | \*\*\*    | The password for the admin user to log in. Username is always "sa"          |
| MSSQL_PID            | Developer | Edition of MSSQL Server to run (Express, Standard, etc). Default: Developer |
