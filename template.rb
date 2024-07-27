# frozen_string_literal: true

gem "blacklight", "~> 7.0"
gem "geoblacklight", "~> 4.0"

# Hack for https://github.com/rails/rails/issues/35153
# Adapted from https://github.com/projectblacklight/blacklight/pull/2065
gemfile = File.expand_path("Gemfile")
File.write(gemfile, File.open(gemfile) do |f|
  text = f.read
  text.gsub(/^gem 'sqlite3'$/, 'gem "sqlite3", "~> 1.3.6"')
end)

run "bundle install"

generate "blacklight:install", "--devise"
generate "geoblacklight:install", "-f"

rake "db:migrate"
