require 'blacklight'
require 'leaflet-rails'

module Geoblacklight
  class Engine < ::Rails::Engine

    # GeoblacklightHelper is needed by all helpers, so we inject it
    # into action view base here. 
    initializer 'geoblacklight.helpers' do |app|
      ActionView::Base.send :include, GeoblacklightHelper
    end
  end
end
