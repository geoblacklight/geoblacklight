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

    config.to_prepare do
      unless SearchHistoryController.helpers.is_a?(Geoblacklight::ViewHelperOverride)
        SearchHistoryController.send(:helper, Geoblacklight::ViewHelperOverride)
      end
    end
  end
end
