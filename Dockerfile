FROM ruby:2.5.8-alpine3.11 AS build

ENV HZL_VERSION=v1.0.0-beta

ENV GEM_HOME="/houzel/vendor/bundle"
ENV RAILS_ENV="production"

RUN apk add --no-cache --virtual .build-deps \
        build-base \
        shadow \
        autoconf \
        automake \
        tzdata \
        postgresql-dev \
        postgresql-client \
        git \
        nodejs \
        yarn && \
        rm -rf /tmp/*

RUN mkdir -p /houzel/vendor/bundle

RUN wget https://github.com/houzelio/houzel/archive/$HZL_VERSION.tar.gz -qO \
    latest_houzel.gzipped

WORKDIR /

RUN tar --extract \
    --strip-components=1 \
    --file=latest_houzel.gzipped --directory=/houzel && \
    rm -Rfv latest_houzel.gzipped

ENV BUNDLE_PATH="$GEM_HOME" \
    BUNDLE_BIN="$GEM_HOME/bin" \
    BUNDLE_APP_CONFIG="/houzel/.bundle"
ENV PATH $BUNDLE_BIN:$PATH

COPY ./run/environment.sh environment.sh
WORKDIR /houzel
COPY ./config/houzel.yml ./config/database.yml config/
RUN /environment.sh

FROM ruby:2.5.8-alpine3.11

ENV GEM_HOME="/houzel/vendor/bundle"
ENV RAILS_ENV="production"

ARG HZL_UID=2000
ARG HZL_GID=2000

RUN apk add --no-cache --virtual .build-deps \
        shadow \
        tzdata \
        postgresql-dev \
        postgresql-client && \
        rm -rf /tmp/*

RUN addgroup --gid ${HZL_GID} houzel && \
    adduser -D -u ${HZL_UID} -G houzel -h /houzel -D houzel

COPY --chown=houzel --from=build /houzel /houzel

ENV BUNDLE_PATH="$GEM_HOME" \
    BUNDLE_BIN="$GEM_HOME/bin" \
    BUNDLE_APP_CONFIG="/houzel/.bundle"
ENV PATH $BUNDLE_BIN:$PATH

COPY ./run/startup.sh startup.sh
USER houzel
WORKDIR /houzel

CMD ["/startup.sh"]
