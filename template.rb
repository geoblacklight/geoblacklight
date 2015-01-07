gem 'blacklight'
gem 'geoblacklight', github: 'geoblacklight/geoblacklight'
gem 'jettywrapper'

add_source "https://rails-assets.org"

run 'bundle install'

generate 'blacklight:install', '--devise'
generate 'geoblacklight:install'

rake 'db:migrate'
