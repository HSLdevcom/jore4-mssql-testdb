#!/bin/bash

set -euo pipefail

function generate_password () {
  # SIGPIPE ensues from writing into the pipe after the reading stops so use
  # echo for pipefail.
  echo "$(LC_CTYPE=C </dev/urandom tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"
}

# use a different password while the migrations are loaded so that the instance can't yet be connected to
SA_PASSWORD_FINAL="$SA_PASSWORD"
SA_PASSWORD=$(generate_password)

# find all .sql files from given folder and import them in alphabetical order
function import_from_folder {
    find "$1" -name '*.sql' -print0 | sort -z | xargs -r0 -I{} \
        /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P "$SA_PASSWORD" -d master -i "{}"
}

function wait_for_startup {
    RETRIES=24
    WAIT_BETWEEN=5
    for i in $(seq 1 $RETRIES); do
        sleep $WAIT_BETWEEN
        echo "Checking if MSSQL server can be connected to. Trial #$i"
        /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P "$SA_PASSWORD" -d master \
            -Q "SELECT 1;" && echo "Success!" && return 0
    done
    echo "Could not connect to MSSQL server"
    exit 1
}

function wait_and_populate {
    echo "Waiting for MSSQL to start..."
    wait_for_startup

    echo "Initialize the MS SQL database contents..."
    import_from_folder "/initialize"

    echo "Importing user-defined SQL dumps..."
    import_from_folder "/data"

    echo "Allow access to MSSQL instance"
    # set the password to the desired one so that loging in is enabled
    /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P "$SA_PASSWORD" -d master \
        -Q "ALTER LOGIN sa WITH PASSWORD = '${SA_PASSWORD_FINAL}' OLD_PASSWORD = '${SA_PASSWORD}';"
    SA_PASSWORD="$SA_PASSWORD_FINAL"

    echo "MSSQL container is ready to accept connections"
}

# wait for the server to start up and initialize it with the given SQL dump (in the background)
wait_and_populate &

# start up the actual server
/opt/mssql/bin/sqlservr
