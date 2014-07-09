require 'rails/generators'

module Geoblacklight
  class Install < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc "Install Geoblacklight"

    def assets
      copy_file "geoblacklight.css.scss", "app/assets/stylesheets/geoblacklight.css.scss"
      copy_file "geoblacklight.js", "app/assets/javascripts/geoblacklight.js"
    end

    def create_blacklight_catalog
      remove_file "app/controllers/catalog_controller.rb"
      copy_file "catalog_controller.rb", "app/controllers/catalog_controller.rb"
    end

    def fixtures
      FileUtils.mkdir_p "spec/fixtures/geoblacklight_schema"
      copy_file "../../../../schema/examples/selected.json", "spec/fixtures/geoblacklight_schema/selected.json"
    end

    def add_unique_key
      inject_into_file 'app/models/solr_document.rb', after: "# self.unique_key = 'id'" do
        "\n  self.unique_key = 'layer_slug_s'"
      end
    end
    
    def inject_routes
      # route 'devise_for :users'
      # route 'constraints(:id => /[0-9A-Za-z\-\.\:\_\/]+/) do
      #          blacklight_for :catalog
      #          resources :bookmarks
      #        end'
      # route 'get \'/catalog/facet/:id\' => \'catalog#facet\''
      # route 'root :to => "catalog#index"'
      route 'post "wms/handle"'
      route 'post "download/kml"'
      route 'post "download/shapefile"'
      route 'get "download/file"'
    end
    
    def inject_gems
      gem "bootswatch-rails"
    end
    
  end
end
