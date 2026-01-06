# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.4.8
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config nodejs npm curl libsqlite3-0

RUN npm install --global yarn

ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Rails app lives here
WORKDIR /rails

# Install gems and javascript packages
COPY Gemfile .
RUN bundle install
COPY package.json .
RUN yarn install

FROM ghcr.io/geoblacklight/geoblacklight:base AS app

# Add application code
COPY . .

# Run the server script by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["sh", "start-server"]
