FROM mcr.microsoft.com/mssql/server:2017-CU22-ubuntu-16.04 AS empty

# Create workdir
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Create directories for loading sql dumps
# Note: for importing built-in data, we are using the /initialize folder, because when mapping the
# /data folder to host, its contents get emptied
RUN mkdir -p /initialize
RUN mkdir -p /data
VOLUME /data

# Set up exposed port
EXPOSE 1433

# The username is always "sa"
# Password is to be defined with "SA_PASSWORD" environment variable
ENV ACCEPT_EULA Y
ENV MSSQL_PID Developer

# Copy startup scripts
COPY ./scripts /usr/src/app/scripts

# Entrypoint for loading sql dumps and starting the mssql server
CMD /bin/bash ./scripts/entrypoint.sh

HEALTHCHECK --interval=5s --timeout=5s --start-period=60s --retries=50 \
    CMD /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "SELECT 1"

# extends the :empty image and copies the init data to the /initialize folder
# from which the entrypoint automatically load it
FROM empty AS schema-only

COPY ./data/schema_only.sql /initialize/init-data.sql