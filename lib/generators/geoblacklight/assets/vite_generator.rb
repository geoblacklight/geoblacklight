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

      # This will write its own package.json if one doesn't exist, causing a
      # conflict, so it needs to happen after blacklight generates its own
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

      # Install the peer dependencies of the frontend asset package.
      #
      # This is necessary so that the generated app can reference e.g. leaflet's
      # css and javascript from node_modules at the top level, rather than
      # nested under @geoblacklight/frontend as a dependency.
      #
      # NPM would do this for us, but yarn does not, so we have to do it
      # manually. This method references the peer deps listed in package.json
      # so that they aren't listed in two places.
      def install_peer_dependencies
        pkg_path = Geoblacklight::Engine.root.join("package.json")  # top-level package.json
        pkg = JSON.load_file(pkg_path)
        pkg["peerDependencies"].each do |dep, version|
          run "yarn add #{dep}@#{version} --fixed"  # --fixed interprets version as a literal
        end
      end

      # The vite_rails gem doesn't currently install the vite-plugin-rails
      # node package, so we need to do that manually as well.
      def install_dev_dependencies
        run "yarn add --dev vite-plugin-rails"
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
