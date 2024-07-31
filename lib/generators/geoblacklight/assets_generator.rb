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

    # Add our own stylesheets that reference the versions from npm
    def add_stylesheets
      copy_file "assets/_customizations.scss", "app/javascript/entrypoints/_customizations.scss"
      copy_file "assets/application.scss", "app/javascript/entrypoints/application.scss"
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
        import "../controllers/application";
        import * as bootstrap from "bootstrap";
        import githubAutoCompleteElement from "@github/auto-complete-element";
        import Blacklight from "blacklight-frontend";
        import Geoblacklight from "@geoblacklight/frontend";

        window.bootstrap = bootstrap;
        window.Blacklight = Blacklight;
        window.Geoblacklight = Geoblacklight;
      JS

      inject_into_file "app/javascript/entrypoints/application.js", imports
    end
  end
end
