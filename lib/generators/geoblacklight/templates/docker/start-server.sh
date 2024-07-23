#!/bin/sh

bundle install
yarn install
bundle exec rake db:prepare
bundle exec rake geoblacklight:index:seed
bundle exec rails server -b 0.0.0.0
