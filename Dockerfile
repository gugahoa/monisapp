ARG OTP_VERSION=22.0

##################################################
# Base - setup project and docker cache for build
FROM erlang:${OTP_VERSION}-alpine as base

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.9.1" \
	LANG=C.UTF-8

RUN set -xe \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
	&& ELIXIR_DOWNLOAD_SHA256="94daa716abbd4493405fb2032514195077ac7bc73dc2999922f13c7d8ea58777" \
	&& buildDeps=' \
		ca-certificates \
		curl \
		make \
	' \
	&& apk add --no-cache --virtual .build-deps $buildDeps \
	&& curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
	&& echo "$ELIXIR_DOWNLOAD_SHA256  elixir-src.tar.gz" | sha256sum -c - \
	&& mkdir -p /usr/local/src/elixir \
	&& tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
	&& rm elixir-src.tar.gz \
	&& cd /usr/local/src/elixir \
	&& make install clean \
	&& apk del .build-deps
  
# Install building packages
RUN apk --no-cache add git build-base npm
RUN mix do local.hex --force, local.rebar --force

WORKDIR /build

# Cache dependencies
COPY ./mix.* ./
RUN mix deps.get

COPY ./assets/package.json ./assets/package.json
RUN npm install --prefix ./assets

# Cache configs
COPY ./config ./config

#################################################
# Builder - stage for running lint, test and dev
FROM base as builder

WORKDIR /build
COPY . .
RUN rm -rf ./_build

##########################################
# Release - builds release for production
FROM builder as release

ENV MIX_ENV prod

WORKDIR /build

RUN npm run deploy --prefix ./assets
RUN mix do phx.digest, release

#######################################
# Script runner - minimal script runner environment
FROM alpine:3.9 as runner

RUN apk add --update --no-cache bash openssl curl

WORKDIR /app

COPY --from=release /build/priv/static /priv/static
COPY --from=release /build/_build/prod/rel/monis_app ./
RUN chown -R nobody: /app
USER nobody

#######################################
# Runtime - minimal production runtime
FROM runner as runtime

# Set APP_VERSION at last, to reuse cached layers
ARG APP_VERSION
ENV APP_VERSION $APP_VERSION

ENV PORT 4040
EXPOSE $PORT

# Set release binary as entrypoint, no shell access
ENTRYPOINT ["/app/bin/monis_app"]
CMD ["start"]

