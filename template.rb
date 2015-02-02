gem 'blacklight'
gem 'geoblacklight'
gem 'jettywrapper'

run 'bundle install'

generate 'blacklight:install', '--devise'
generate 'geoblacklight:install', '--jettywrapper'

rake 'db:migrate'
