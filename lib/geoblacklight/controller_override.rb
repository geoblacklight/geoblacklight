module Geoblacklight
  module ControllerOverride
    extend ActiveSupport::Concern
    def web_services
      @response, @document = fetch params[:id]
      respond_to do |format|
        format.html do
          return render layout: false if request.xhr?
        end
      end
    end

    def metadata
      @response, @document = fetch params[:id]
      respond_to do |format|
        format.html do
          return render layout: false if request.xhr?
        end
      end
    end
  end
end
