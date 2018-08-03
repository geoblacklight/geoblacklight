gem 'blacklight', '>= 6.11'
gem 'geoblacklight', '>= 1.9'

run 'bundle install'

generate 'blacklight:install', '--devise'
generate 'geoblacklight:install', '-f'

rake 'db:migrate'
