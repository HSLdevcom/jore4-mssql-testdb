# Available tags can be found from
# https://mcr.microsoft.com/en-us/artifact/mar/mssql/server/tags
FROM mcr.microsoft.com/mssql/server:2022-CU18-ubuntu-22.04 AS empty

USER root

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
ENV \
  ACCEPT_EULA=Y \
  MSSQL_PID=Developer

# Copy startup scripts
COPY --chmod=755 --chown=mssql ./scripts /usr/src/app/scripts

# Entrypoint for loading sql dumps and starting the mssql server
CMD ["/bin/bash", "./scripts/entrypoint.sh"]

HEALTHCHECK --interval=5s --timeout=5s --start-period=30s --retries=30 \
    CMD /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "SELECT 1"

USER mssql

# extends the :empty image and copies the init data to the /initialize folder
# from which the entrypoint automatically load it
FROM empty AS schema-only

USER root
COPY --chmod=644 --chown=mssql ./data/schema_only.sql /initialize/init-data.sql
USER mssql
