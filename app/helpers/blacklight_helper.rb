# frozen_string_literal: true

# @deprecated GeoBlacklight 5 no longer ships a BlacklightHelper override. The
#   relations container is rendered by Geoblacklight::Document::SidebarComponent
#   instead. Applications that define their own BlacklightHelper are unaffected.
module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior
  include Geoblacklight::GeoblacklightHelperBehavior
  include Blacklight::CatalogHelperBehavior

  # @deprecated
  def render_document_sidebar_partial(document = @document)
    super + (render "relations_container", document: document)
  end
end
