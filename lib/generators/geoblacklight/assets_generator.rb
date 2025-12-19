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

    # Pick a version of the frontend asset package and install it.
    #
    # In CI, install from the local filesystem (i.e. the outer Geoblacklight
    # directory).
    #
    # If a branch was specified (e.g. you are running a template.rb build
    # against a test branch), use the latest version available on npm.
    #
    # Otherwise, pick the version from npm that matches our Geoblacklight
    # gem version.
    def add_package
      if ENV["CI"]
        run "yarn add file:#{Geoblacklight::Engine.root}"
      elsif ENV["BRANCH"]
        run "yarn add @geoblacklight/frontend@latest"
      else
        run "yarn add @geoblacklight/frontend@#{Geoblacklight::VERSION}"
      end
    end

    # Switch Blacklight's bootstrap and popper imports to ESM versions so we
    # can import individual modules
    def use_bootstrap_esm
      gsub_file "config/importmap.rb", %r{dist/js/bootstrap.js}, "dist/js/bootstrap.esm.js"
      gsub_file "config/importmap.rb", %r{dist/umd/popper.min.js}, "dist/esm/popper.js"
    end

    # Add the SCSS customization overrides and insert before bootstrap import
    def add_customizations
      copy_file "assets/_customizations.scss", "app/assets/stylesheets/_customizations.scss"
      gsub_file "app/assets/stylesheets/_customizations.scss", "@geoblacklight/frontend/app/assets/", ""
      insert_into_file "app/assets/stylesheets/application.bootstrap.scss", "@import 'customizations';\n",
        before: "@import 'bootstrap/scss/bootstrap';"
    end

    # Add CDN imports for CSS files used by Geoblacklight (leaflet, openlayers)
    def add_leaflet_ol_css_cdn
      insert_into_file "app/assets/stylesheets/application.bootstrap.scss", before: "@import 'customizations';\n" do
        <<~SCSS
          /* GeoBlacklight dependencies CSS */
          @import url("https://cdn.skypack.dev/leaflet@1.9.4/dist/leaflet.css");
          @import url("https://cdn.jsdelivr.net/npm/leaflet-fullscreen@1.0.2/dist/leaflet.fullscreen.css");
          @import url("https://cdn.skypack.dev/ol@8.1.0/ol.css");

        SCSS
      end
    end

    # Add an import for Geoblacklight's stylesheet
    def add_geoblacklight_styles
      append_to_file "app/assets/stylesheets/application.bootstrap.scss",
        "@import '@geoblacklight/frontend/app/assets/stylesheets/geoblacklight/geoblacklight';"
    end

    # Import Geoblacklight's JS using the name that importmap has pinned
    def add_geoblacklight_js
      append_to_file "app/javascript/application.js", 'import Geoblacklight from "geoblacklight";'
    end

    # Run the build so styles are available for the first load of the app
    def build_styles
      run "yarn build:css"
    end
  end
end
