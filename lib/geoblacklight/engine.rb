require 'blacklight'
require 'leaflet-rails'
# move towards removing httparty, replaced by faraday
require 'httparty'
require 'font-awesome-rails'
require 'rails_config'
require 'faraday'

module Geoblacklight
  class Engine < ::Rails::Engine

    Blacklight::Configuration.default_values[:view].split.partials = ['index']
    Blacklight::Configuration.default_values[:view].delete_field('list')

    # GeoblacklightHelper is needed by all helpers, so we inject it
    # into action view base here.
    initializer 'geoblacklight.helpers' do |app|
      ActionView::Base.send :include, GeoblacklightHelper
    end

    config.to_prepare do
      Geoblacklight.inject!
    end
  end
end
