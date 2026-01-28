# frozen_string_literal: true

module Geoblacklight
  # Set up the delivery strategies for CSS and JS assets.
  class AssetsGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc <<-DESCRIPTION
      This generator sets up delivery of JS and CSS. It assumes that the JS
      pipeline is importmaps (the default in Rails 8) and that no CSS bundling
      is being used (also the default in Rails 8).

      JS sources from the Blacklight and Geoblacklight gems are delivered as
      ES modules via importmap, and their dependencies are pinned to versions
      delivered via CDN.

      CSS needed for Geoblacklight's dependencies (e.g. leaflet viewer) are
      imported via CDN in the app's main CSS stylesheet. Geoblacklight's own
      stylesheet is imported directly via propshaft.
    DESCRIPTION

    # Switch Blacklight's bootstrap and popper imports to ESM versions so we
    # can import individual modules
    def use_bootstrap_esm
      gsub_file "config/importmap.rb", %r{dist/js/bootstrap.js}, "dist/js/bootstrap.esm.js"
      gsub_file "config/importmap.rb", %r{dist/umd/popper.min.js}, "dist/esm/popper.js"
    end

    # Add an import for Geoblacklight's JS
    def add_geoblacklight_js
      append_to_file "app/javascript/application.js", 'import Geoblacklight from "geoblacklight";'
    end

    # Add an import for Geoblacklight's stylesheet
    def add_geoblacklight_styles
      append_to_file "app/assets/stylesheets/application.css", "@import url(\"geoblacklight/geoblacklight.css\");\n"
    end

    # Copy default customizations stylesheet
    def copy_customizations_stylesheet
      copy_file "assets/customizations.css", "app/assets/stylesheets/customizations.css"
    end

    # Add an import for your local customizations stylesheet
    def add_customization_styles
      append_to_file "app/assets/stylesheets/application.css", "@import url(\"customizations.css\");\n"
    end
  end
end
