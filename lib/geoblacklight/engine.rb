# frozen_string_literal: true

require "blacklight"
require "coderay"
require "config"
require "commonmarker"
require "faraday"
require "faraday/follow_redirects"
require "geoblacklight/version"
require "nokogiri"
require "mime/types"
require "geo_combine"

module Geoblacklight
  class Engine < ::Rails::Engine
    # GeoblacklightHelper is needed by all helpers, so we inject it
    # into action view base here.
    initializer "geoblacklight.helpers" do
      config.after_initialize do
        ActionView::Base.send :include, GeoblacklightHelper
      end
    end

    PRECOMPILE_ASSETS = %w[favicon.ico].freeze

    # Make the source JS and CSS available to built apps
    initializer "geoblacklight.assets" do |app|
      app.config.assets.paths << Geoblacklight::Engine.root.join("app/javascript")
      app.config.assets.paths << Geoblacklight::Engine.root.join("app/assets/images")
      app.config.assets.paths << Geoblacklight::Engine.root.join("app/assets/stylesheets")
      app.config.assets.precompile += Geoblacklight::Engine::PRECOMPILE_ASSETS
    end

    # Add the Geoblacklight importmap to the built app's importmap
    initializer "geoblacklight.importmap", before: "importmap" do |app|
      next unless app.config.respond_to?(:importmap)

      app.config.importmap.paths << Geoblacklight::Engine.root.join("config/importmap.rb")
      app.config.importmap.cache_sweepers << Geoblacklight::Engine.root.join("app/javascript")
    end
  end
end
