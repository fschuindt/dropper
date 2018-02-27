# -----------------------------------------------------------------
# Build
# -----------------------------------------------------------------
FROM elixir:1.6.1-alpine as build

# Copy source from current external dir.
COPY . .

RUN apk add --no-cache git

# Install dependencies and build Release.
RUN export MIX_ENV=prod && \
    rm -rf _build && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix release

# Create the '/export' dir and extract the tarball release into.
RUN mkdir /export && \
    export REL=`ls -d _build/prod/rel/dropper/releases/*/` && \
    tar -xzf "$REL/dropper.tar.gz" -C /export

# -----------------------------------------------------------------
# Deploy
# -----------------------------------------------------------------
FROM erlang:20.2.3-alpine

# Set environment variables and expose port.
EXPOSE 50051
ENV REPLACE_OS_VARS=true
#   PORT=50051

# Add bash to the system.
RUN apk add --no-cache bash

# Copy extracted source from the build tarball release to here.
COPY --from=build /export/ .

# Set default entrypoint and start command.
ENTRYPOINT ["bin/dropper"]
CMD ["foreground"]
