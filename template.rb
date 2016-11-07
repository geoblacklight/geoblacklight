gem 'blacklight', '>= 6.3'
gem 'geoblacklight', '>= 1.3'

run 'bundle install'

generate 'blacklight:install', '--devise'
generate 'geoblacklight:install', '--solrwrapper', '-f'

rake 'db:migrate'
