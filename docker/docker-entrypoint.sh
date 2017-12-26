#!/bin/bash

set -e

if [ "${1:0:1}" = '-' ]; then
  set -- dgidb "$@"
fi

echo "$*" | grep 'dgidb.*--help' >/dev/null && exec "$@"
echo "$*" | grep 'dgidb.*--version' >/dev/null && exec "$@"

echo "Initializing database..."
touch /var/log/postgresql.log && \
chown postgres:postgres /var/log/postgresql.log && \
gosu postgres initdb --username=postgres >/var/log/postgresql.log 2>&1 && \
echo "Starting database..." && \
gosu postgres pg_ctl -D "$PGDATA" -l "/var/log/postgresql.log" -o "-c listen_addresses='localhost'" start -w

cd "$DGIDB_SRC"
rake db:create
rake db:migrate
cd -

exec "$@"
