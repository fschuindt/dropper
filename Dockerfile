# -----------------------------------------------------------------
# Build Release
# -----------------------------------------------------------------
FROM elixir:1.6.1-alpine as build

# Copy our source from current dir.
COPY . .

# Some Hex dependencies will pull from GitHub.
# So Git is needed.
RUN apk add --no-cache git

# Install dependencies and build Release.
RUN export MIX_ENV=prod && \
    rm -rf _build && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix release

# Create the '/export' dir and extract the tarball release into it.
RUN mkdir /export && \
    export REL=`ls -d _build/prod/rel/dropper/releases/*/` && \
    tar -xzf "$REL/dropper.tar.gz" -C /export

# -----------------------------------------------------------------
# Deploy "Kind of"
# It will set up our Erlang machine with our compiled Elixir code.
#
# But in order to achieve hot-upgrades, the deploy worflow is
# different. See edeliver: https://github.com/edeliver/edeliver
# -----------------------------------------------------------------
FROM erlang:20.2.3-alpine

# Expose the 50051 port to be used by the gRPC server.
EXPOSE 50051

# Copy the shell/wait_for_postgres.sh bash script to the system.
# It waits the dropper_database to be up, then fires the application.
COPY shell/wait_for_postgres.sh .

# Add bash and the PostgreSQL client to the system.
# This client is needed by the shell/wait_for_postgres.sh script.
# Also allow the script to execute.
# Docker Compose will call it.
RUN apk add --no-cache bash postgresql-client && \
    chmod +x wait_for_postgres.sh

# Copy extracted BEAM code from the tarball release to the system.
COPY --from=build /export/ .
