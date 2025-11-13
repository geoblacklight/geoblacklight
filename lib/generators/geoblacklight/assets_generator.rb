# frozen_string_literal: true

module Geoblacklight
  # Run general asset setup and then delegate to the appropriate generator
  # Based on Blacklight::AssetsGenerator
  class AssetsGenerator < Rails::Generators::Base
    class_option :"asset-pipeline", type: :string, default: ENV.fetch("ASSET_PIPELINE", "vite"), desc: "Choose the asset pipeline to use (vite or importmap)"
    class_option :test, type: :boolean, default: ENV.fetch("CI", false), aliases: "-t", desc: "Indicates that app will be installed in a test environment"

    # Pick a version of the frontend asset package and install it.
    #
    # If a branch was specified (e.g. you are running a template.rb build
    # against a test branch), use the latest version available on npm.
    #
    # Otherwise, pick the version from npm that matches our Geoblacklight
    # gem version.
    def add_frontend
      if ENV["BRANCH"]
        run "yarn add @geoblacklight/frontend@latest"
      else
        run "yarn add @geoblacklight/frontend@#{Geoblacklight::VERSION}"
      end
    end

    def run_asset_pipeline_specific_generator
      generated_options = "--test=true" if options[:test]
      generator = if options[:"asset-pipeline"]
        "geoblacklight:assets:#{options[:"asset-pipeline"]}"
      else
        "geoblacklight:assets:vite"
      end

      generate generator, generated_options
    end
  end
end
