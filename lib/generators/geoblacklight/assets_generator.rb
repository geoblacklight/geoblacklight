# frozen_string_literal: true

module Geoblacklight
  # Run general asset setup and then delegate to the appropriate generator
  # Based on Blacklight::AssetsGenerator
  class AssetsGenerator < Rails::Generators::Base
    class_option :"asset-pipeline", type: :string, default: ENV.fetch("ASSET_PIPELINE", "vite"), desc: "Choose the asset pipeline to use (vite or importmap)"
    class_option :test, type: :boolean, default: ENV.fetch("CI", false), aliases: "-t", desc: "Indicates that app will be installed in a test environment"

    def run_asset_pipeline_specific_generator
      generate "geoblacklight:assets:#{options[:"asset-pipeline"]}", "--test" if options[:test]
    end
  end
end
