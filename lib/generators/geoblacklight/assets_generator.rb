# frozen_string_literal: true

module Geoblacklight
  # Run general asset setup and then delegate to the appropriate generator
  # Based on Blacklight::AssetsGenerator
  class AssetsGenerator < Rails::Generators::Base
    class_option :test, type: :boolean, default: ENV.fetch("CI", false), aliases: "-t", desc: "Indicates that app will be installed in a test environment"

    def run_asset_generator
      generate "geoblacklight:assets:importmap", "--test=true" if options[:test]
    end
  end
end
