# @TODO: Remove
#
# Blacklight 7.0 introduces ActionBuilder, which adds controller methods from
# CatalogController config.add_show_tools_partial statements
#
# module Geoblacklight
#  module ControllerOverride
#    extend ActiveSupport::Concern
#    def web_services
#      @response, @document = search_service.fetch(params[:id])
#      respond_to do |format|
#        format.html do
#          return render layout: false if request.xhr?
#        end
#      end
#    end
#
#    def metadata
#      @response, @document = search_service.fetch(params[:id])
#      respond_to do |format|
#        format.html do
#          return render layout: false if request.xhr?
#        end
#      end
#    end
#  end
# end
