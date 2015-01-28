gem 'blacklight'
gem 'geoblacklight'
gem 'jettywrapper'

add_source 'https://rails-assets.org'

run 'bundle install'

generate 'blacklight:install', '--devise'
generate 'geoblacklight:install', '--jettywrapper'

rake 'db:migrate'
