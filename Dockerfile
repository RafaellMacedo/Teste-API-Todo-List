# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.3.1
FROM ruby:$RUBY_VERSION-slim

WORKDIR /rails

RUN apt-get update -qq && apt-get install -y \
      build-essential \
      libpq-dev \
      pkg-config \
      nodejs \
      npm \
      git \
      curl \
      libvips \
      postgresql-client && \
    rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle \
    PATH="/usr/local/bundle/bin:$PATH"

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
