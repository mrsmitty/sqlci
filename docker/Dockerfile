FROM mcr.microsoft.com/mssql/server:2019-latest

# Elevate to root to install required packages
USER root
RUN apt-get update \
    && apt-get install unzip libunwind8 libicu60 libssl1.0.0 -y

# Install SQLPackage for Linux and make it executable
RUN wget -progress=bar:force -q -O sqlpackage.zip https://go.microsoft.com/fwlink/?linkid=2113331 \
    && unzip -qq sqlpackage.zip -d /opt/sqlpackage \
    && chmod +x /opt/sqlpackage/sqlpackage \
    && chown -R mssql /opt/sqlpackage \
    && mkdir /tmp/db \
    && chown -R mssql /tmp/db

# Lower the privilege
USER mssql

# Add the DACPAC to the image
COPY test.dacpac /tmp/db/db.dacpac

# Configure external build arguments to allow configurability.
ARG DBNAME=Test
ARG PASSWORD

# Configure the required environmental variables
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=$PASSWORD

# Launch SQL Server, confirm startup is complete, deploy the DACPAC, then terminate SQL Server.
# See https://stackoverflow.com/a/51589787/488695
RUN ( /opt/mssql/bin/sqlservr & ) | grep -q "Service Broker manager has started" \
    && /opt/sqlpackage/sqlpackage /a:Publish /tsn:. /tdn:${DBNAME} /tu:sa /tp:$SA_PASSWORD /sf:/tmp/db/db.dacpac \
    && rm -r /tmp/db \
    && pkill sqlservr 
