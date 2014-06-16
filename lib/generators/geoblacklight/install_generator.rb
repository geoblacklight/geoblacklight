require 'rails/generators'

module Geoblacklight
  class Install < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc "Install Geoblacklight"

    def assets
      copy_file "geoblacklight.css.scss", "app/assets/stylesheets/geoblacklight.css.scss"
      copy_file "geoblacklight.js", "app/assets/javascripts/geoblacklight.js"
    end

    def create_blacklight_catalog
      remove_file "app/controllers/catalog_controller.rb"
      copy_file "catalog_controller.rb", "app/controllers/catalog_controller.rb"
    end

    def fixtures
      FileUtils.mkdir_p "spec/fixtures/geoblacklight_schema"
      copy_file "../../../../spec/fixtures/geoblacklight_schema/transformed.json", "spec/fixtures/geoblacklight_schema/transformed.json"
    end
  end
end
