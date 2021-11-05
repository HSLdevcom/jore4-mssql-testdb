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
        /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d master -i "{}"
}

function wait_and_populate {
    echo "Waiting for MSSQL to start..."
    /usr/src/app/scripts/wait-for-it.sh --host=localhost --port=1433 --timeout=120

    # We must wait a few additional seconds, otherwise login might fail
    # with "Error: 18456, Severity: 14, State: 7."
    sleep 5s

    echo "Initialize the MS SQL database contents..."
    import_from_folder "/initialize"

    echo "Importing user-defined SQL dumps..."
    import_from_folder "/data"

    echo "Allow access to MSSQL instance"
    # set the password to the desired one so that loging in is enabled
    /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d master \
        -Q "ALTER LOGIN sa WITH PASSWORD = '${SA_PASSWORD_FINAL}' OLD_PASSWORD = '${SA_PASSWORD}';"
    SA_PASSWORD="$SA_PASSWORD_FINAL"
}

# wait for the server to start up and initialize it with the given SQL dump (in the background)
wait_and_populate &

# start up the actual server
/opt/mssql/bin/sqlservr
