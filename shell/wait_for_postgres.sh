#!/bin/bash

until psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DATABASE" -c '\q'; do
  >&2 echo "Can't access PostgreSQL server, sleeping now."
  sleep 2
done

>&2 echo "PostgreSQL server is up!"
exec $1
