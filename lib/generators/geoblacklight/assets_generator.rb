# frozen_string_literal: true

require "rails/generators"

module Geoblacklight
  class AssetsGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc <<-DESCRIPTION
      This generator makes the following changes to your application:
       1. Copies GBL javascript into the application
       2. Removes stock Rails and Blacklight stylesheets from the application
       3. Copies GBL stylesheets into the local application
       4. Sets asset initializer values into the local application
    DESCRIPTION

    # Remove these; we reference the versions installed from npm instead
    def remove_stylesheets
      remove_file "app/assets/stylesheets/application.css"
      remove_file "app/assets/stylesheets/blacklight.scss"
    end

    # Add our own stylesheets that reference the versions from npm
    def add_stylesheets
      copy_file "assets/_customizations.scss", "app/javascript/entrypoints/_customizations.scss"
      copy_file "assets/application.scss", "app/javascript/entrypoints/application.scss"
    end

    def remove_javascript
      # Remove this since we aren't using sprockets; everything is in app/javascript instead
      remove_dir "app/assets/javascripts"
      # remove manifest.js sprockets
      remove_file "app/assets/config/manifest.js"
      # Remove this because we aren't using importmaps; the main entrypoint is in app/javascript/entrypoints/application.js
      #remove_file "app/javascript/application.js"
    end

    # Copy over the main Geoblacklight entrypoint
    def add_javascript
      copy_file "geoblacklight.js", "app/javascript/entrypoints/geoblacklight.js"
    end

    # Update the application entrypoint
    def update_application_entrypoint
      imports = <<~JS
        // JS dependencies
        import "@hotwired/turbo-rails";
        import jQuery from "jquery";
        import "popper.js";
        import bootstrap from "bootstrap";
        import Bloodhound from "typeahead.js/dist/bloodhound";
        import "typeahead.js/dist/typeahead.jquery";

        // Make imports available globally
        window.bootstrap = bootstrap;
        window.$ = jQuery;
        window.jQuery = jQuery;
        window.Bloodhound = Bloodhound;
      JS

      inject_into_file "app/javascript/entrypoints/application.js", imports
    end
  end
end
