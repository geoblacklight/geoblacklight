module Geoblacklight
  module Relations
    # Display a single record related to this one
    class RelationComponent < ViewComponent::Base
      attr_reader :document, :sibling_count, :browse_label_key

      def initialize(document:, field: nil, sibling_count: nil, browse_label_key: nil)
        @document = document
        @field = field
        @sibling_count = sibling_count
        @browse_label_key = browse_label_key
        super()
      end

      def description
        safe_join(Array(document.description).map { |value| helpers.markdown_to_html(value) })
      end

      # sibling_count includes the current document itself, so there's only something
      # worth browsing to when it's more than just that one document.
      def render_sibling_link?
        sibling_count.to_i > 1
      end

      def sibling_search_path
        helpers.search_catalog_path(f: {@field => [document.id]})
      end
    end
  end
end
