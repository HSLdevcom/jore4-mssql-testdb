# jore4-mssql-testdb

Dockerized MSSQL database for mocking JORE3 data. This is not meant to be used
in production, only for running end-to-end tests and anonymizing jore3 production
dumps.

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


## Anonymizing Jore3 production dumps

Before providing Jore3 production dumps to the team for development, possibly
contained personal data has to be removed from it. For this, you can use a
docker container based on this repository's `Dockerfile`, which does not
contain any data. Build and run as follows:
```
	docker build . --target empty -t jore3-anonymizer
	docker run -p 127.0.0.1:1435:1433/tcp -v $(pwd)/docker-image-test-data:/data -e SA_PASSWORD=<your-password> jore3-anonymizer
```

Most 3rd party mssql clients do not support backing up / restoring database
dumps. Therefore, the dump has to be made available to the mssql server inside
the docker container, e.g. via a volume. (If you use the commands from above,
you can place it in the `docker-image-test-data` folder.)

When the container is running, connect to the mssql databse with your SQL client
on port 1435, with username `sa` and the password specified above. Then follow
the steps in `anonymize-jore3-prod.sql`. Replace the `input-file.bak` and
`output-file.bak` with the actual filenames to be used.

The output file obtained from this procedure can be shared among the
development team for testing.
