# frozen_string_literal: true

module Geoblacklight
  class WebServicesComponent < ViewComponent::Base
    with_collection_parameter :ref

    def initialize(ref:, document:)
      @ref = ref
      @document = document
      @type = ref.type.to_s
      super()
    end

    def render?
      Settings.WEBSERVICES_SHOWN.include? @type
    end

    def render_web_services
      component_class_name = "Geoblacklight::WebServices#{@type.camelize}Component"
      component_class = component_class_name.constantize
      render component_class.new(reference: @ref, document: @document)
    rescue
      render Geoblacklight::WebServicesDefaultComponent.new(reference: @ref)
    end
  end
end
