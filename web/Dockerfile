FROM elixir:1.14-alpine as builder

WORKDIR /midas

ENV MIX_ENV prod

#RUN apk add --update --no-cache bash git openssh openssl

#RUN mix local.hex --force && \
    #mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config
COPY assets assets
COPY priv priv
COPY lib lib

#RUN apk add --update --no-cache --virtual .gyp g++ make
#RUN mix do deps.get --only ${MIX_ENV}, deps.compile
#ENV PATH="/root/.mix/escripts:${PATH}"

WORKDIR /midas
#RUN mix assets.deploy

#COPY rel rel
#RUN mix release midas

# Run Release
FROM alpine:3.17

#RUN apk add --update --no-cache bash openssl postgresql-client libstdc++

ENV MIX_ENV prod

EXPOSE 5000

WORKDIR /midas
#COPY --from=builder /midas/dist/ .

#HEALTHCHECK CMD curl --fail http://localhost:4000/ || exit 1

#CMD ["sh", "-c", "/midas/bin/midas start"]
RUN apk add netcat-openbsd
COPY entry.sh /midas/entry.sh
RUN chmod +x ./entry.sh
ENTRYPOINT ["./entry.sh"]
