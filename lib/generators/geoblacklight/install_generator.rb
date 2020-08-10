# frozen_string_literal: true
require 'rails/generators'

module Geoblacklight
  class Install < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Install Geoblacklight'

    def mount_geoblacklight_engine
      inject_into_file 'config/routes.rb', "mount Geoblacklight::Engine => 'geoblacklight'\n", before: /^end/
    end

    def inject_geoblacklight_routes
      routes = <<-"ROUTES"
        concern :gbl_exportable, Geoblacklight::Routes::Exportable.new
        resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
          concerns :gbl_exportable
        end
        concern :gbl_wms, Geoblacklight::Routes::Wms.new
        namespace :wms do
          concerns :gbl_wms
        end
        concern :gbl_downloadable, Geoblacklight::Routes::Downloadable.new
        namespace :download do
          concerns :gbl_downloadable
        end
        resources :download, only: [:show]
      ROUTES

      inject_into_file 'config/routes.rb', routes, before: /^end/
    end

    def generate_assets
      generate 'geoblacklight:assets'
    end

    def create_blacklight_catalog
      remove_file 'app/controllers/catalog_controller.rb'
      copy_file 'catalog_controller.rb', 'app/controllers/catalog_controller.rb'
    end

    def rails_config
      copy_file 'settings.yml', 'config/settings.yml'
    end

    def solr_config
      directory '../../../../solr', 'solr'
    end

    def include_geoblacklight_solrdocument
      inject_into_file 'app/models/solr_document.rb', after: 'include Blacklight::Solr::Document' do
        "\n include Geoblacklight::SolrDocument"
      end
    end

    def add_unique_key
      inject_into_file 'app/models/solr_document.rb', after: "# self.unique_key = 'id'" do
        "\n  self.unique_key = 'layer_slug_s'"
      end
    end

    def add_spatial_search_behavior
      inject_into_file 'app/models/search_builder.rb', after: 'include Blacklight::Solr::SearchBuilderBehavior' do
        "\n  include Geoblacklight::SpatialSearchBehavior"
      end
    end

    # Turn off JQuery animations during testing
    def inject_disable_jquery_animations
      inject_into_file 'app/views/layouts/application.html.erb', before: '</head>' do
        "  <%= javascript_tag '$.fx.off = true;' if Rails.env.test? %>\n"
      end
    end

    def create_downloads_directory
      FileUtils.mkdir_p('tmp/cache/downloads') unless File.directory?('tmp/cache/downloads')
    end

    def disable_turbolinks
      gsub_file('app/assets/javascripts/application.js', %r{\/\/= require turbolinks}, '')
    end

    def update_application_name
      gsub_file('config/locales/blacklight.en.yml', 'Blacklight', 'GeoBlacklight')
    end

    # Ensure that assets/images exists
    def create_image_assets_directory
      FileUtils.mkdir_p('app/assets/images') unless File.directory?('app/assets/images')
    end

    def bundle_install
      Bundler.with_clean_env do
        run 'bundle install'
      end
    end
  end
end
