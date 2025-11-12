# frozen_string_literal: true

require "rails/generators"

module Geoblacklight
  module Assets
    class ImportmapGenerator < Rails::Generators::Base
      source_root Geoblacklight::Engine.root.join("lib", "generators", "geoblacklight", "templates")

      class_option :test, type: :boolean, default: false, aliases: "-t", desc: "Indicates that app will be installed in a test environment"

      desc <<-DESCRIPTION
        This generator sets up the app to use Importmaps to manage the javascript,
        and dartsass-rails to manage the styles.

        SCSS sources from Bootstrap and Blacklight are installed via yarn and
        built into a single CSS stylesheet.

        JS sources from the Blacklight and Geoblacklight gems are delivered as
        ES modules via importmap, and their dependencies are pinned to versions
        delivered via CDN.
      DESCRIPTION

      # Add the customization overrides and insert before bootstrap import
      def add_customizations
        copy_file "assets/_customizations.scss", "app/assets/stylesheets/_customizations.scss"
        gsub_file "app/assets/stylesheets/_customizations.scss", "@geoblacklight/frontend/app/assets/", ""
        insert_into_file "app/assets/stylesheets/application.bootstrap.scss", "@import 'customizations';\n", before: "@import 'bootstrap/scss/bootstrap';"
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
        append_to_file "app/assets/stylesheets/application.bootstrap.scss", "@import '@geoblacklight/frontend/app/assets/stylesheets/geoblacklight/geoblacklight';"
      end

      # Ensure import of Blacklight's JS uses the name that importmap has pinned
      def update_blacklight_import
        gsub_file "app/javascript/application.js", "blacklight-frontend", "blacklight"
      end

      # Import Geoblacklight's JS using the name that importmap has pinned
      def add_geoblacklight_js
        append_to_file "app/javascript/application.js", "import Geoblacklight from \"geoblacklight\";"
      end

      # Add pins for application dependencies to the importmap
      def update_importmap
        gsub_file "config/importmap.rb", "bootstrap.min.js", "https://cdn.skypack.dev/bootstrap@5.3.3"
        append_to_file "config/importmap.rb" do
          <<~CONTENT
            pin "@github/auto-complete-element", to: "https://cdn.skypack.dev/@github/auto-complete-element"
            pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/dist/umd/popper.min.js"
          CONTENT
        end
      end

      # Run the build so styles are available for the first load of the app
      def build_styles
        run "yarn build:css"
      end
    end
  end
end
