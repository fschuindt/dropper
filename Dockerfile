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

# Expose ports:
# 22 to our OpenSSH server.
# 50051 to our gRPC server.
EXPOSE 22 50051

# Copy shell/entrypoint.sh script to the system.
# It starts the OpenSSH server and waits for the PostgreSQL server.
# Then fires the :dropper OTP application.
COPY shell/entrypoint.sh .

# Copy extracted BEAM code from the tarball release to the system.
COPY --from=build /export/ .

# Import the argument SSH_KEYS from docker-compose.yml.
# It's a URL of your SSH public keys file.
# Then add it to the root's OpenSSH authorized keys file.
ARG SSH_KEYS
ADD $SSH_KEYS /root/.ssh/authorized_keys

# Install bash, a PostgreSQL client and the OpenSSH server.
# Those are used by the shell/entrypoint.sh script.
# Allow the root user to login via SSH.
# Deny SSH password authentication, keys required to login.
# Change root password to "root".
# Allow the /entrypoint.sh file to execute.
RUN apk add --no-cache bash postgresql-client openssh \
    && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
    && sed -i s/#PasswordAuthentication.*/PasswordAuthentication\ no/ /etc/ssh/sshd_config \
    && echo "root:root" | chpasswd \
    && chmod +x /entrypoint.sh
