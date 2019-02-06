gem 'blacklight', '~> 7.0'
gem 'geoblacklight', '~> 2.0'
gem 'webpacker', '~> 3.5'

# Hack for https://github.com/rails/rails/issues/35153
# Adapted from https://github.com/projectblacklight/blacklight/pull/2065
gemfile = File.expand_path('Gemfile')
IO.write(gemfile, File.open(gemfile) do |f|
  text = f.read
  text.gsub(/^gem 'sqlite3'$/, 'gem "sqlite3", "~> 1.3.6"')
end)

run 'bundle install'

generate 'blacklight:install', '--devise'
generate 'geoblacklight:install', '-f'
generate 'geoblacklight:webpacker', '-f'

rake 'db:migrate'
