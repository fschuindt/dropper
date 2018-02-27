#!/bin/sh

while ! pg_isready -h dropper_postgres -p 5432 > /dev/null 2> /dev/null; do
  echo "Waiting for the PostgreSQL server."
  sleep 2
done

/bin/dropper command Elixir.Dropper.ReleaseTasks migrate
