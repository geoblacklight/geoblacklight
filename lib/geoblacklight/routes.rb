module Geoblacklight
  module Routes
    extend ActiveSupport::Concern
    included do |klass|
      klass.default_route_sets += [:web_services_routes]
    end

    def web_services_routes(primary_resource)
      add_routes do |options|
        get "#{primary_resource}/:id/web_services" => "#{primary_resource}#web_services", as: "web_services_#{primary_resource}"
      end
    end
  end
end
