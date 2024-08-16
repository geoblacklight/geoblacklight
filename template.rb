# frozen_string_literal: true

gem "blacklight", "~> 8.0"

# Ensure the app generates with Propshaft; sprockets is no longer supported
# https://github.com/geoblacklight/geoblacklight/issues/1265
ENV["ENGINE_CART_RAILS_OPTIONS"] = ENV["ENGINE_CART_RAILS_OPTIONS"].to_s + " -a propshaft"

# Install latest version of geoblacklight gem if running
# generator with a development branch.
if ENV["BRANCH"]
  gem "geoblacklight", github: "geoblacklight/geoblacklight", branch: ENV["BRANCH"]
else
  gem "geoblacklight", "~> 4.0"
end

run "bundle install"

generate "blacklight:install", "--devise"
generate "geoblacklight:install", "-f"

if ENV["ASSET_PIPELINE"]
  generate "geoblacklight:assets:#{ENV["ASSET_PIPELINE"]}"
else
  generate "geoblacklight:assets:vite"
end

rake "db:migrate"
