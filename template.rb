gem 'blacklight', '~> 7.0'
gem 'geoblacklight', '~> 2.0'
gem 'webpacker', '~> 3.5'

run 'bundle install'

generate 'blacklight:install', '--devise'
generate 'geoblacklight:install', '-f'
generate 'geoblacklight:webpacker', '-f'

rake 'db:migrate'
