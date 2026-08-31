# frozen_string_literal: true

require "blacklight"
require "coderay"
require "config"
require "faraday"
require "geoblacklight/version"
require "nokogiri"
require "mime/types"
require "handlebars_assets"

module Geoblacklight
  class Engine < ::Rails::Engine
    # Register GeoBlacklight's deprecator so that applications can configure it
    # alongside Rails' own, e.g. `config.active_support.deprecation = :raise`.
    initializer "geoblacklight.deprecator" do |app|
      app.deprecators[:geoblacklight] = Geoblacklight.deprecation if app.respond_to?(:deprecators)
    end

    # Warn about application configuration that GeoBlacklight 5 removes. This
    # runs once per boot rather than per request, because nothing in
    # GeoBlacklight calls the deprecated templates or settings on the
    # application's behalf.
    config.after_initialize do
      Geoblacklight::DeprecatedConfiguration.warn!
    end

    # GeoblacklightHelper is needed by all helpers, so we inject it
    # into action view base here.
    initializer "geoblacklight.helpers" do
      config.after_initialize do
        ActionView::Base.send :include, GeoblacklightHelper
        ActionView::Base.send :include, CartoHelper
      end
    end

    config.to_prepare do
      unless SearchHistoryController.helpers.is_a?(Geoblacklight::ViewHelperOverride)
        SearchHistoryController.send(:helper, Geoblacklight::ViewHelperOverride)
      end
    end
  end
end
