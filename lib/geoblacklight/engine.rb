require 'blacklight'
require 'leaflet-rails'
require 'font-awesome-rails'
require 'rails_config'
require 'faraday'
require 'nokogiri'
require 'coderay'
require 'geoblacklight-icons'

module Geoblacklight
  class Engine < ::Rails::Engine
    Blacklight::Configuration.default_values[:view].split.partials = ['index']
    Blacklight::Configuration.default_values[:view].delete_field('list')
    # GeoblacklightHelper is needed by all helpers, so we inject it
    # into action view base here.
    initializer 'geoblacklight.helpers' do
      ActionView::Base.send :include, GeoblacklightHelper
      ActionView::Base.send :include, CartoHelper
    end

    config.to_prepare do
      Geoblacklight.inject!
    end
  end
end
