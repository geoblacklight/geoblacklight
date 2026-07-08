module Geoblacklight
  module Document
    # Link to the export modal for generated downloads
    class ExportLinkComponent < ViewComponent::Base
      attr_reader :document

      def initialize(document:, **)
        @document = document
        super()
      end

      def call
        link_to(
          I18n.t("geoblacklight.export.export"),
          helpers.export_solr_document_path(id: document.id),
          class: "nav-link",
          data: {blacklight_modal: "trigger"}
        )
      end

      def key
        "export"
      end
    end
  end
end
