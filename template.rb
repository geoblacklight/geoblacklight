gem 'blacklight'
gem 'geoblacklight', github: 'geoblacklight/geoblacklight'
gem 'jettywrapper'

run 'bundle install'

generate 'blacklight:install', '--devise'
generate 'geoblacklight:install'

rake 'db:migrate'
