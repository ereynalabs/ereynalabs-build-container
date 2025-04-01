##
# @copyright Copyright (C) 2025, Ereyna Labs Ltd. - All Rights Reserved
# @file Dockerfile
# @parblock
# This file is subject to the terms and conditions defined in file 'LICENSE.md',
# which is part of this source code package.  Proprietary and confidential.
# @endparblock
# @author Dave Linten <david@ereynalabs.com>
#

#
# Build container
#
FROM --platform=$TARGETPLATFORM gcc:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
ENV CI=1

# Pull vars from global
ARG BUILD_TYPE
ARG PROJECT_NAME
ARG PROJECT_NAMESPACE
ARG APP_BIN_TARGET
ARG APP_LIB_TARGET
ARG APP_WWW_TARGET
ARG APP_TEST_TARGET
ARG APP_DATABASE_NAME
ARG SOURCE_LOCATION
ARG BUILD_LOCATION

# Install necessary packages
RUN apt update && apt install -y \
    wget \
    gnupg \
    lsb-release


# Add PostgreSQL official repository
RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | tee /etc/apt/trusted.gpg.d/postgresql.asc \
    && apt update

# Install PostgreSQL 17
RUN apt install -y postgresql-17 postgresql-contrib cmake autoconf libtool openssl git git-lfs util-linux \
  libssl-dev zlib1g-dev libbrotli-dev libmariadb-dev libsqlite3-dev libjsoncpp-dev libhiredis-dev rsync openssl jq \
  nodejs npm chromium python3 python3-pip

# Set up PostgreSQL data directory and permissions
RUN mkdir -p /var/lib/postgresql/17/main && \
    chown -R postgres:postgres /var/lib/postgresql && \
    chown -R postgres:postgres /var/log/postgresql && \
    chmod -R 700 /var/lib/postgresql




