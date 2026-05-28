# frozen_string_literal: true

module Geoblacklight
  # Set up the delivery strategies for CSS and JS assets.
  class AssetsGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc <<-DESCRIPTION
      This generator sets up compilation/delivery of JS and CSS. It assumes that
      the JS pipeline is importmaps (the default in Rails 8) and that the CSS
      pipeline has already been created via the `rails new` option --css=bootstrap.

      JS sources from the Blacklight and Geoblacklight gems are delivered as
      ES modules via importmap, and their dependencies are pinned to versions
      delivered via CDN.

      CSS needed for Geoblacklight's dependencies (e.g. leaflet viewer) are
      imported via CDN in the app's main bootstrap stylesheet. Geoblacklight's own
      stylesheet is imported from the frontend asset package installed via yarn.
    DESCRIPTION

    # Switch Blacklight's bootstrap and popper imports to ESM versions so we
    # can import individual modules
    def use_bootstrap_esm
      gsub_file "config/importmap.rb", %r{dist/js/bootstrap.js}, "dist/js/bootstrap.esm.js"
      gsub_file "config/importmap.rb", %r{dist/umd/popper.min.js}, "dist/esm/popper.js"
    end

    # Import Geoblacklight's JS using the name that importmap has pinned
    def add_geoblacklight_js
      append_to_file "app/javascript/application.js", 'import Geoblacklight from "geoblacklight";'
    end

    # Add Geoblacklight's stylesheet
    def add_geoblacklight_styles
      append_to_file "app/assets/stylesheets/application.css", "@import url(\"geoblacklight.css\");"
    end

    # Add the CSS customization override stylesheet
    def add_customizations
      copy_file "assets/customizations.css", "app/assets/stylesheets/customizations.css"
      append_to_file "app/assets/stylesheets/application.css", "\n@import url(\"customizations.css\");"
    end
  end
end
