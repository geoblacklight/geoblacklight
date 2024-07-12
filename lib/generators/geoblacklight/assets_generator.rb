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
      copy_file "assets/_customizations.scss", "app/assets/stylesheets/_customizations.scss"
      copy_file "assets/application.scss", "app/assets/stylesheets/application.scss"
      copy_file "application.css", "app/javascript/entrypoints/application.css"
    end

    def remove_javascript
      # Remove this since we aren't using sprockets; everything is in app/javascript instead
      remove_dir "app/assets/javascripts"
      # Remove this because we aren't using importmaps; the main entrypoint is in app/javascript/entrypoints/application.js
      remove_file "app/javascript/application.js"
    end

    # Copy over the controllers and Vite entrypoints
    def add_javascript
      directory "javascript/controllers", "app/javascript/controllers"
      copy_file "geoblacklight.js", "app/javascript/entrypoints/geoblacklight.js"
    end

    # We just imported new controllers, so regenerate the stimulus manifest
    def regenerate_controller_manifest
      rails_command "stimulus:manifest:update"
    end

    # Import JS dependencies from node_modules
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

        // Import our stimulus controllers
        import "../controllers";
      JS

      inject_into_file "app/javascript/entrypoints/application.js", imports
    end

    def add_initializers
      append_to_file "config/initializers/assets.rb",
        "\nRails.application.config.assets.precompile += %w( favicon.ico )\n"

      append_to_file "config/initializers/assets.rb",
        "\nRails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'images')\n"
    end
  end
end
