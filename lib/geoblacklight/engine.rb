require 'blacklight'
require 'leaflet-rails'
require 'httparty'
require 'font-awesome-rails'
require 'rails_config'

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
