FROM elixir:1.12.2
ENV MIX_ENV=prod
RUN apt-get update && \
    apt-get install -y inotify-tools

COPY mix.exs mix.lock ./

# Fetch and compile the dependencies
RUN mix do local.hex --force, local.rebar --force, deps.get, deps.compile,

COPY . .
RUN mix release

CMD ["_build/prod/rel/scheduler/bin/scheduler", "start"]
ENTRYPOINT ["scheduler"]