# frozen_string_literal: true

# Set BRANCH=<branch_name> to install from a specific branch
if ENV["BRANCH"]
  gem "geoblacklight", github: "geoblacklight/geoblacklight", branch: ENV["BRANCH"]
else
  gem "geoblacklight"
end

run "bundle install"

after_bundle do
  generate "blacklight:install", ENV.fetch("BLACKLIGHT_INSTALL_OPTIONS", "--devise --skip-solr")
  generate "geoblacklight:install"
  rails_command "db:migrate"
end
