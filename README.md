# ![DropperLogo](https://s18.postimg.org/43c8wcpi1/eyedropper_small.png) [WIP] Dropper
*A Elixir gRPC prototype.*

## To Do
- [ ] Testing.
- [x] Typespecs.
- [x] gRPC write.
- [ ] gRPC read.
- [ ] Allow Ecto errors to be on top.
- [ ] Refactor the way the database-related logic is implemented.
- [x] Docker Containerization.
- [x] Set a release in Distillery.
- [x] Secure Distillery release cookies in a `.env` file.
- [ ] Upgrade to Elixir 1.6.2.
- [ ] Implement [edeliver](https://github.com/edeliver/edeliver) for Erlang hot-upgrades.

## Setup and run

### With Docker
First, clone the repository: `$ git clone git@github.com:fschuindt/dropper.git`.

Then:
```
$ cd dropper
$ docker-compose up
```

### Manually
Make sure you have installed the Elixir 1.6.1 environment in your machine. Also a running PostgreSQL server is required.

First, clone the repository, then enters it:
```
$ git clone git@github.com:fschuindt/dropper.git
$ cd dropper
```

Create a `.envrc` file with the following content:
```
export REPLACE_OS_VARS=true

export POSTGRES_HOST=localhost
export POSTGRES_DATABASE=dropper_repo
export POSTGRES_USER=fschuindt
export POSTGRES_PASSWORD=

export RELEASE_DEV_COOKIE=s3cr3t_dev
export RELEASE_PROD_COOKIE=s3cr3t_prod
```

Edit it to fit with your PostgreSQL credentials.

Once you have your `.envrc` (or `.env`, your choice) file, load it using [Direnv](https://github.com/direnv/direnv) or similar. You can even export those variables manually. But it's important you have them set.

With that in place, create the application database into your PostgreSQL server. If you haven't changed it in your environment file, it's named `dropper_repo` (an [Ecto](https://github.com/elixir-ecto/ecto) default). Just be sure to match the `DROPPER_DATABASE` environment variable here.
```
$ psql -c 'create database dropper_repo';
```

Now we can install the dependencies and compile the release:

**(This is just one single command)**
```
$ mix local.hex --force && \
mix local.rebar --force && \
mix deps.get && \
mix release
```

Run the migrations and start the server:
```
$ _build/dev/rel/dropper/bin/dropper migrate
$ _build/dev/rel/dropper/bin/dropper foreground
```
