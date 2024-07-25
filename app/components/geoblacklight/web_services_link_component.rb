# frozen_string_literal: true

module Geoblacklight
  class WebServicesLinkComponent < ViewComponent::Base
    def initialize(document:)
      @document = document
      super
    end

    def render?
      (Settings.WEBSERVICES_SHOWN & @document.references.refs.map(&:type).map(&:to_s)).any?
    end

    def web_services_link
      link_to "Web services",
        helpers.web_services_solr_document_path(id: @document.id),
        class: ["btn", "btn-primary", "sidebar-btn"],
        id: "web-services-button",
        data: {blacklight_modal: "trigger"}
    end
  end
end
