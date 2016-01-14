module Geoblacklight
  module Routes
    extend ActiveSupport::Concern
    included do |klass|
      klass.default_route_sets += [:web_services_routes]
    end

    def web_services_routes(primary_resource)
      add_routes do
        post 'wms/handle'
        resources :download, only: [:show, :file]
        get 'download/file/:id' => 'download#file', as: :download_file
        get 'download/hgl/:id' => 'download#hgl', as: :download_hgl
        get "#{primary_resource}/:id/web_services" => "#{primary_resource}#web_services", as: "web_services_#{primary_resource}"
        get "#{primary_resource}/:id/metadata" => "#{primary_resource}#metadata", as: "metadata_#{primary_resource}"
      end
    end
  end
end
