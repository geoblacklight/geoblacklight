gem 'blacklight', '>= 6.3'
gem 'geoblacklight', '>= 1.1.1'

run 'bundle install'

generate 'blacklight:install', '--devise'
generate 'geoblacklight:install', '--solrwrapper'

rake 'db:migrate'
