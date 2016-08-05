gem 'blacklight'
gem 'geoblacklight'

run 'bundle install'

generate 'blacklight:install', '--devise'
generate 'geoblacklight:install', '--solrwrapper'

rake 'db:migrate'
