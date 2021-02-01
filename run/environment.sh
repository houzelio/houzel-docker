#!/bin/sh

bundle config set clean true --deployment --without test development
bundle install
rm -rf vendor/bundle/cache/\*.gem
find vendor/bundle/gems/ -name "\*.c" -delete
find vendor/bundle/gems/ -name "\*.o" -delete

yarn install --production

bundle exec rails houzel:secret
bundle exec rails webpacker:compile
rm config/houzel.yml config/database.yml

rm -rf node_modules tmp/cache app/assets vendor/assets spec
