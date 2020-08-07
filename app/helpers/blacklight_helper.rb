# frozen_string_literal: true
module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior
  include Geoblacklight::GeoblacklightHelperBehavior
  include Blacklight::CatalogHelperBehavior

  def render_document_sidebar_partial(document = @document)
    super(document) + (render 'relations_container', document: document)
  end
end
