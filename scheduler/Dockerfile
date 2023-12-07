FROM elixir:1.14.1-alpine as build

RUN mix do local.hex --force, local.rebar --force
ENV MIX_ENV=prod
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile
COPY priv priv
COPY lib lib
RUN mix compile

RUN mix release

CMD ["_build/prod/rel/scheduler/bin/scheduler", "start"]
ENTRYPOINT ["scheduler"]