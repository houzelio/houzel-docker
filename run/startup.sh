#!/bin/sh

mkdir -p tmp/

export RAILS_ENV=$RAILS_ENV

bundle exec rails db:migrate
bundle exec puma --config config/puma.rb
