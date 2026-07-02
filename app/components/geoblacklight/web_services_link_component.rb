# frozen_string_literal: true

module Geoblacklight
  class WebServicesLinkComponent < ViewComponent::Base
    attr_reader :document

    def initialize(document:, **)
      @document = document
      super()
    end

    def call
      link_to(
        I18n.t("geoblacklight.references.services"),
        helpers.web_services_solr_document_path(id: document.id),
        class: "nav-link",
        data: {blacklight_modal: "trigger"}
      )
    end

    def key
      "web_services"
    end
  end
end
