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
      def install_vite
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

      # Add our package.json with non-GBL dependencies (Blacklight, Bootstrap, etc.)
      def install_dependencies
        copy_file "package.json", "package.json"
        run "yarn install"
      end

      # This will write its own package.json if one doesn't exist, causing a
      # conflict, so it needs to happen after we copy ours
      def bundle_install
        run "bundle exec vite install"
      end

      # Pick a version of the frontend asset package and install it.
      def add_frontend
        # If in local development or CI, install the version we made linkable in
        # the test app generator. This will make it so changes made in the outer
        # directory are picked up automatically, like a symlink. Note that this
        # does NOT install the dependencies of the package, so we have to make
        # sure to install those separately. See:
        # https://classic.yarnpkg.com/lang/en/docs/cli/link/
        # https://github.com/yarnpkg/yarn/issues/2914
        if options[:test]
          run "yarn link @geoblacklight/frontend"

        # If a branch was specified (e.g. you are running a template.rb build
        # against a test branch), use the latest version available on npm
        elsif ENV["BRANCH"]
          run "yarn add @geoblacklight/frontend@latest"

        # Otherwise, pick the version from npm that matches our Geoblacklight
        # gem version
        else
          run "yarn add @geoblacklight/frontend@#{Geoblacklight::VERSION}"
        end
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
