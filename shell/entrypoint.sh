#!/bin/bash

# Generate SSH host keys for the OpenSSH server.
# Only if they don't exist.
ssh-keygen -A

# Starts the OpenSSH Daemon.
/usr/sbin/sshd

# Wait for the PostgreSQL server to be up.
until psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DATABASE" -c '\q'; do
  >&2 echo "Can't access PostgreSQL server, sleeping now."
  sleep 2
done

>&2 echo "PostgreSQL server is up!"

# Run the "migrate" release command.
bin/dropper migrate

# Start the :dropper OTP application.
bin/dropper foreground
