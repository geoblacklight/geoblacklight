# frozen_string_literal: true

require "rails/generators"

module Geoblacklight
  class Install < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    desc "Install Geoblacklight"

    class_option :test, type: :boolean, default: false, aliases: "-t", desc: "Indicates that app will be installed in a test environment"

    def allow_geoblacklight_params
      gbl_params = <<-PARAMS
        before_action :allow_geoblacklight_params

        def allow_geoblacklight_params
          # Blacklight::Parameters will pass these to params.permit
          blacklight_config.search_state_fields.append(Settings.GBL_PARAMS)
        end
      PARAMS

      inject_into_file "app/controllers/application_controller.rb", gbl_params, before: /^end/
    end

    def raise_unpermitted_params
      inject_into_file "config/environments/test.rb", "config.action_controller.action_on_unpermitted_parameters = :raise\n", before: /^end/
    end

    def mount_geoblacklight_engine
      inject_into_file "config/routes.rb", "mount Geoblacklight::Engine => 'geoblacklight'\n", before: /^end/
    end

    def inject_geoblacklight_routes
      routes = <<-ROUTES
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

      inject_into_file "config/routes.rb", routes, before: /^end/
    end

    def generate_assets
      generate "geoblacklight:assets"
    end

    def create_blacklight_catalog
      remove_file "app/controllers/catalog_controller.rb"
      copy_file "catalog_controller.rb", "app/controllers/catalog_controller.rb"
    end

    def rails_config
      copy_file "settings.yml", "config/settings.yml"
    end

    def solr_config
      directory "../../../../solr", "solr"
    end

    def include_geoblacklight_solrdocument
      inject_into_file "app/models/solr_document.rb", after: "include Blacklight::Solr::Document" do
        "\n include Geoblacklight::SolrDocument"
      end
    end

    def add_unique_key
      inject_into_file "app/models/solr_document.rb", after: "# self.unique_key = 'id'" do
        "\n  self.unique_key = Settings.FIELDS.UNIQUE_KEY"
      end
    end

    def add_spatial_search_behavior
      inject_into_file "app/models/search_builder.rb", after: "include Blacklight::Solr::SearchBuilderBehavior" do
        "\n  include Geoblacklight::SuppressedRecordsSearchBehavior"
      end
    end

    # Turn off JQuery animations during testing
    def inject_disable_jquery_animations
      inject_into_file "app/views/layouts/application.html.erb", before: "</head>" do
        "  <%= javascript_tag '$.fx.off = true;' if Rails.env.test? %>\n"
      end
    end

    def create_downloads_directory
      FileUtils.mkdir_p("tmp/cache/downloads") unless File.directory?("tmp/cache/downloads")
    end

    def update_application_name
      gsub_file("config/locales/blacklight.en.yml", "Blacklight", "GeoBlacklight")
    end

    # Ensure that assets/images exists
    def create_image_assets_directory
      FileUtils.mkdir_p("app/assets/images") unless File.directory?("app/assets/images")
    end

    # Vite - Required for successful installation
    def install_vite_rails
      append_to_file "Gemfile" do
        "gem \"vite_rails\", \"~> 3.0\""
      end
    end

    # Vite - GBL Base Layout with Vite Helper Tags
    def geoblacklight_base_layout
      copy_file "base.html.erb", "app/views/layouts/blacklight/base.html.erb"
    end

    def copy_package_json
      if options[:test]
        # If building engine cart test app, use specific package.json so the
        # locally built frontend javascript is used instead of the npm package.
        copy_file "package-test.json", "package.json"
      else
        copy_file "package.json", "package.json"
      end
    end

    # Vite - Config files
    def copy_config_vite_json
      copy_file "vite.json", "config/vite.json"
      copy_file "vite.config.ts", "vite.config.ts"
      run "yarn install"
    end

    # Run bundle with vite install
    def bundle_install
      Bundler.with_clean_env do
        run "bundle install"
        run "bundle exec vite install"
      end
    end

    # Vite - Copy over the Vite entrypoints
    def copy_vite_entrypoints
      copy_file "clover.js", "app/javascript/entrypoints/clover.js"
      copy_file "ol.js", "app/javascript/entrypoints/ol.js"
      copy_file "geoblacklight.js", "app/javascript/entrypoints/geoblacklight.js"
    end
  end
end
