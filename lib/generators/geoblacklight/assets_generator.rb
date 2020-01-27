# frozen_string_literal: true

require 'rails/generators'

module Geoblacklight
  class AssetsGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    desc <<-DESCRIPTION
      This generator makes the following changes to your application:
       1. Copies GBL javascript into the application
       2. Removes stock Rails and Blacklight stylesheets from the application
       3. Copies GBL stylesheets into the local application
       4. Sets asset initializer values into the local application
    DESCRIPTION

    def add_javascript
      copy_file 'assets/geoblacklight.js', 'app/assets/javascripts/geoblacklight.js'

      if Rails.version.to_i == 6
        append_to_file 'app/assets/javascripts/application.js',
                       "\n// Required by GeoBlacklight\n//= require geoblacklight"
      end
    end

    def remove_stylesheets
      remove_file 'app/assets/stylesheets/application.css'
      remove_file 'app/assets/stylesheets/blacklight.scss'
    end

    def add_stylesheets
      copy_file 'assets/application.scss', 'app/assets/stylesheets/application.scss'
      copy_file 'assets/_blacklight.scss', 'app/assets/stylesheets/_blacklight.scss'
      copy_file 'assets/_customizations.scss', 'app/assets/stylesheets/_customizations.scss'
      copy_file 'assets/_geoblacklight.scss', 'app/assets/stylesheets/_geoblacklight.scss'
    end

    def add_initializers
      append_to_file 'config/initializers/assets.rb',
                     "\nRails.application.config.assets.precompile += %w( favicon.ico )\n"

      append_to_file 'config/initializers/assets.rb',
                     "\nRails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'images')\n"
    end
  end
end
