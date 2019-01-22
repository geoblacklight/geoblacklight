gem 'blacklight', '>= 6.11'
gem 'geoblacklight', '>= 1.9'
gem 'webpacker', '~> 3.5'

run 'bundle install'

generate 'blacklight:install', '--devise'
generate 'geoblacklight:install', '-f'

run 'bundle exec rails webpacker:install'
run 'yarn --version'
if $CHILD_STATUS.exitstatus.zero?
  run 'bundle exec rails yarn:install'
else
  run 'npm install'
end
rake 'db:migrate'
