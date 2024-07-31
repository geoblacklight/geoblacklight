# frozen_string_literal: true

require "rails/generators"

module Geoblacklight
  class AssetsGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc <<-DESCRIPTION
      This generator makes the following changes to your application:
       1. Removes stock Rails and Blacklight stylesheets from the application
       2. Copies GBL stylesheets into the local application
       3. Updates the application entrypoint to import Geoblacklight's javascript
    DESCRIPTION

    # Remove the default Sprockets manifest and Blacklight's stylesheet
    def remove_stylesheets
      remove_file "app/assets/stylesheets/application.css"
      remove_file "app/assets/stylesheets/blacklight.scss"
    end

    # Add our own stylesheets, which import Blacklight's and other dependencies
    def add_stylesheets
      copy_file "assets/application.css", "app/assets/stylesheets/application.css"
      copy_file "assets/_customizations.scss", "app/assets/stylesheets/_customizations.scss"
      copy_file "assets/geoblacklight.scss", "app/assets/stylesheets/geoblacklight.scss"
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
