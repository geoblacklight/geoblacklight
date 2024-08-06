# frozen_string_literal: true

require "rails/generators"

module Geoblacklight
  class ImportmapGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    class_option :test, type: :boolean, default: false, aliases: "-t", desc: "Indicates that app will be installed in a test environment"

    desc <<-DESCRIPTION
      This generator sets up the app to use Importmaps to manage the javascript,
      and cssbundling-rails to manage the styles.

      SCSS sources from Bootstrap and Blacklight are installed via yarn and
      built into a single CSS stylesheet by cssbundling-rails.

      JS sources from Blacklight and Geoblacklight are delivered unbundled as
      ES modules via importmap, and their dependencies are pinned to versions
      delivered via CDN.
    DESCRIPTION

    # Add our package.json and install dependencies
    # This is used so that we get local copies of the SCSS needed to build the
    # styles; JS all comes from the importmap
    def install_dependencies
      copy_file "package.json", "package.json"
      run "yarn install"
    end

    # sass-rails and sassc-rails are deprecated
    # See: https://github.com/geoblacklight/geoblacklight/issues/1265
    def remove_sass_gems
      gsub_file "Gemfile", /gem "sassc-rails"/, '# \0'
      gsub_file "Gemfile", /gem "sass-rails"/, '# \0'
    end

    # Add cssbundling-rails for sass compilation
    def install_cssbundling_rails
      gem "cssbundling-rails"
      run "bundle install"
      rails_command "css:install:sass"
    end

    # Configure cssbundling to bundle geoblacklight's sass for us
    def setup_cssbundling_entrypoints
      gsub_file "package.json", "application.sass.scss", "geoblacklight.scss"
      gsub_file "package.json", "application.css", "geoblacklight.css"
      gsub_file "package.json", " --no-source-map", ""  # turn sourcemaps on
    end

    # Add Geoblacklight's stylesheet and remove the default Blacklight one
    def add_stylesheets
      remove_file "app/assets/stylesheets/blacklight.scss"
      copy_file "assets/_customizations.scss", "app/assets/stylesheets/_customizations.scss"
      copy_file "assets/geoblacklight.scss", "app/assets/stylesheets/geoblacklight.scss"
    end

    # Add the main CSS stylesheet and remove the default one and its built file
    def add_style_entrypoint
      remove_file "app/assets/stylesheets/application.sass.scss"
      remove_file "app/assets/builds/application.css"
      copy_file "assets/application.css", "app/assets/stylesheets/application.css"
    end

    # If this is a local dev/test build, symlink the frontend package so we
    # can reference its stylesheets in development
    def link_frontend
      run "yarn link @geoblacklight/frontend" if options[:test]
    end

    # Update the main javascript entrypoint
    def update_js_entrypoint
      append_to_file "app/javascript/application.js", "import Blacklight from \"blacklight\"\n"
      append_to_file "app/javascript/application.js", "import Geoblacklight from \"geoblacklight\"\n"
    end

    # Build the styles
    def build_styles
      run "yarn build:css"
    end
  end
end
