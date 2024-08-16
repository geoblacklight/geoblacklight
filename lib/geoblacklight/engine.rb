# frozen_string_literal: true

require "blacklight"
require "coderay"
require "config"
require "faraday"
require "geoblacklight/version"
require "nokogiri"
require "mime/types"

module Geoblacklight
  class Engine < ::Rails::Engine
    # GeoblacklightHelper is needed by all helpers, so we inject it
    # into action view base here.
    initializer "geoblacklight.helpers" do
      config.after_initialize do
        ActionView::Base.send :include, GeoblacklightHelper
      end
    end

    PRECOMPILE_ASSETS = %w[favicon.ico geoblacklight/geoblacklight.umd.cjs geoblacklight/geoblacklight.umd.cjs.map geoblacklight/geoblacklight.js geoblacklight/geoblacklight.js.map].freeze

    # Make the source JS and CSS available to built apps
    initializer "geoblacklight.assets" do |app|
      app.config.assets.paths << Geoblacklight::Engine.root.join("app/javascript")
      app.config.assets.paths << Geoblacklight::Engine.root.join("app/assets")
      app.config.assets.precompile += Geoblacklight::Engine::PRECOMPILE_ASSETS
    end

    # Add the Geoblacklight importmap to the built app's importmap
    initializer "geoblacklight.importmap", before: "importmap" do |app|
      next unless app.config.respond_to?(:importmap) # skip for Vite

      app.config.importmap.paths << Engine.root.join("config/importmap.rb")
      app.config.importmap.cache_sweepers << Engine.root.join("app/assets/javascripts")
    end
  end
end
