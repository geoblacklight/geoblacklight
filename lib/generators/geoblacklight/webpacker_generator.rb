# frozen_string_literal: true
require 'rails/generators'

module Geoblacklight
  class Webpacker < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Integrate Webpacker for GeoBlacklight'

    def webpacker_install
      run 'bundle exec rails webpacker:install'
    end

    def webpacker_config
      copy_file 'webpacker.yml', 'config/webpacker.yml'
    end

    def procfile
      copy_file 'Procfile', 'Procfile'
    end

    def javascript_install
      # This overrides the default dependencies specified using
      # webpacker:install
      copy_file 'package.json', 'package.json'
      yarn_available = system('yarn --version')
      if yarn_available
        run 'yarn install'
        run 'yarn upgrade'
      else
        run 'npm install'
        run 'npm update'
      end
    end
  end
end
