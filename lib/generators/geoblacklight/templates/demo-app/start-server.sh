#!/bin/sh

bundle install
yarn install

# Build and Install local copy of @geoblackligt/frontend
# These steps are included in the docker image instead if the image build script
# to reduce the size of the layers that docker compose has to pull with each new version.
gempath=$(bundle exec gem which geoblacklight | sed 's/\/lib\/geoblacklight.rb//')
if [ ! -d "$gempath/dist/" ]; then
  cd $gempath
  yarn install
  yarn vite build
  cd -
fi
yarn add file:$gempath

# Start the server
bundle exec rake db:prepare
bundle exec rake geoblacklight:index:seed
bundle exec rails server -b 0.0.0.0
