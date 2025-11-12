# frozen_string_literal: true

require "rails/generators"

module Geoblacklight
  module Assets
    class ViteGenerator < Rails::Generators::Base
      source_root Geoblacklight::Engine.root.join("lib", "generators", "geoblacklight", "templates")

      class_option :test, type: :boolean, default: false, aliases: "-t", desc: "Indicates that app will be installed in a test environment"

      desc <<-DESCRIPTION
      This generator sets up the app to use Vite as the bundler for styles and
      javascript using the vite_rails gem. Existing stylesheets for Blacklight
      are removed and replaced with a single JS entrypoint file and a single
      SCSS entrypoint file, which will be bundled by Vite.

      Geoblacklight's frontend assets are installed from the npm package. In
      local development they automatically reference the versions from the
      outer directory (the Geoblacklight repository) via a yarn symlink.
      DESCRIPTION

      # Install Vite
      def install_vite_rails
        gem "vite_rails", "~> 3.0"
        run "bundle install"
      end

      # Add our version of the Blacklight base layout with Vite helper tags
      def geoblacklight_base_layout
        copy_file "base.html.erb", "app/views/layouts/blacklight/base.html.erb"
      end

      # Copy Vite config files
      def copy_config_vite_json
        copy_file "vite.json", "config/vite.json"
        copy_file "vite.config.ts", "vite.config.ts"
      end

      # Run the vite install generator (create binstubs, etc.)
      def setup_vite
        run "bundle exec vite install"
      end

      # The vite_rails gem doesn't currently install the vite-plugin-rails
      # node package, so we need to do that manually.
      def install_dev_dependencies
        run "yarn add --dev vite-plugin-rails"
      end

      # Remove generated npm scripts from rollup and replace with our own.
      # Adds a shortcut so that 'yarn build' runs our vite pipeline
      # No easy way to do this with yarn, so we use `npm pkg`...
      def setup_npm_scripts
        run "npm pkg delete scripts"
        run "npm pkg set scripts.build=\"vite build\""
      end

      # Add our own stylesheets that reference the versions from npm
      def add_stylesheets
        copy_file "assets/_customizations.scss", "app/javascript/stylesheets/_customizations.scss"
        copy_file "assets/geoblacklight.scss", "app/javascript/stylesheets/geoblacklight.scss"
        copy_file "assets/application.scss", "app/javascript/entrypoints/application.scss"
      end

      # Replace the default generated Vite entrypoint with our own
      def add_javascript
        remove_file "app/javascript/entrypoints/application.js"
        copy_file "assets/application.js", "app/javascript/entrypoints/application.js"
      end
    end
  end
end
