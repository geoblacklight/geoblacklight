# frozen_string_literal: true

require "rails/generators"

module Geoblacklight
  module Assets
    class ViteGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __dir__)

      class_option :test, type: :boolean, default: false, aliases: "-t", desc: "Indicates that app will be installed in a test environment"

      desc <<-DESCRIPTION
        This generator sets up the app to use Vite as the bundler for styles and javascript using the vite_rails gem. All of the frontend assets
        get moved to a directory called app/frontend, and the two main
        entrypoints for the application's styles and javascript are copied
        into app/frontend/entrypoints.

        Geoblacklight's frontend assets are installed from the npm package. In
        local development they automatically reference the versions from the
        outer directory (the Geoblacklight repository).
      DESCRIPTION

      # Install Vite
      def install_vite
        gem "vite_rails", "~> 3.0"
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

      # Add our package.json with frontend dependencies (leaflet, etc.)
      def install_dependencies
        copy_file "package.json", "package.json"
        run "yarn install"
      end

      # This will write its own package.json if one doesn't exist, causing a
      # conflict, so it needs to happen after we copy ours
      def bundle_install
        run "bundle exec vite install"
      end

      # Pick a version of the frontend asset package and install it. If in local
      # development or test, just reference the files directly from one level
      # up. If a branch is specified, use the latest package version. Otherwise,
      # pick the version that matches our Geoblacklight gem version.
      def add_frontend
        if options[:test]
          run "yarn add file:#{Geoblacklight::Engine.root}"
        elsif ENV["BRANCH"]
          run "yarn add @geoblacklight/frontend@latest"
        else
          run "yarn add @geoblacklight/frontend@#{Geoblacklight::VERSION}"
        end
      end

      # We won't use this directory and will store assets under app/frontend,
      # as per vite-rails's defaults
      def remove_unused_assets
        remove_dir "app/assets"
      end

      # We don't use the importmap-generated entrypoint
      def remove_importmap_entrypoint
        remove_file "app/javascript/application.js"
      end

      # Move the other generated javascript for stimulus into app/frontend
      def move_existing_javascript
        run "mv app/javascript/ app/frontend/javascript/"
      end

      # Add our own stylesheets, which import Blacklight's and other dependencies
      def add_stylesheets
        copy_file "assets/_customizations.scss", "app/frontend/stylesheets/_customizations.scss"
        copy_file "assets/geoblacklight.scss", "app/frontend/stylesheets/geoblacklight.scss"
      end

      # Add the main style entrypoint
      def add_style_entrypoint
        copy_file "assets/application.scss", "app/frontend/entrypoints/application.scss"
      end

      # Replace the default generated Vite entrypoint with our own
      def add_js_entrypoints
        remove_file "app/frontend/entrypoints/application.js"
        copy_file "assets/application.js", "app/frontend/entrypoints/application.js"
      end
    end
  end
end
