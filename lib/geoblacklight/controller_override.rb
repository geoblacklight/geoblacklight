module Geoblacklight
  module ControllerOverride
    extend ActiveSupport::Concern
    def web_services
      @response, @document = fetch params[:id]
    end

    def metadata
      @response, @document = fetch params[:id]
    end
  end
end
