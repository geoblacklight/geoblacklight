# frozen_string_literal: true

require "blacklight"
require "coderay"
require "config"
require "faraday"
require "geoblacklight/version"
require "nokogiri"
require "mime/types"
require "handlebars_assets"
require "vite_ruby"

module Geoblacklight
  class Engine < ::Rails::Engine
    delegate :vite_ruby, to: :class

    def self.vite_ruby
      @vite_ruby ||= ViteRuby.new(root: root)
    end

    # Expose compiled assets via Rack::Static when running in the host app.
    config.app_middleware.use(Rack::Static,
      urls: ["/#{vite_ruby.config.public_output_dir}"],
      root: root.join(vite_ruby.config.public_dir))

    initializer "vite_rails_engine.proxy" do |app|
      if vite_ruby.run_proxy?
        app.middleware.insert_before 0, ViteRuby::DevServerProxy, ssl_verify_none: true, vite_ruby: vite_ruby
      end
    end

    initializer "vite_rails_engine.logger" do
      config.after_initialize do
        vite_ruby.logger = Rails.logger
      end
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
