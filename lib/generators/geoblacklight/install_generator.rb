require 'rails/generators'

module Geoblacklight
  class Install < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc "Install Geoblacklight"

    def assets
      copy_file "geoblacklight.css.scss", "app/assets/stylesheets/geoblacklight.css.scss"
      copy_file "geoblacklight.js", "app/assets/javascripts/geoblacklight.js"
    end

  end
end
