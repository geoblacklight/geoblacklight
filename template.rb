# frozen_string_literal: true

gem "blacklight", "~> 8.0"
gem "geoblacklight", "~> 4.0"

run "bundle install"

generate "blacklight:install", "--devise"
generate "geoblacklight:install", "-f"

rake "db:migrate"
