# frozen_string_literal: true

module GeoblacklightHelper
  include Blacklight::LayoutHelperBehavior

  # Let the facets take up more space for the locator map
  def sidebar_classes
    "page-sidebar col-lg-4 order-first"
  end

  # Make the search results take up less space so the facets can take more
  def main_content_classes
    "col-lg-8"
  end

  # Needed so we keep the defaults instead of using sidebar_classes
  def show_sidebar_classes
    "page-sidebar col-lg-3"
  end

  # Needed so we keep the defaults instead of using main_content_classes
  def show_content_classes
    "col-lg-9 show-document"
  end

  def document_available?(document)
    document.public? || (document.same_institution? && user_signed_in?)
  end

  ##
  # Blacklight catalog controller helper method to truncate field value to 150 chars
  # @param [SolrDocument] args
  # @return [String]
  def snippit(args)
    truncate(Array(args[:value]).flatten.join(" "), length: 150)
  end

  ##
  # Returns an SVG icon or empty HTML span element
  # @return [SVG or HTML tag]
  def geoblacklight_icon(name, **args)
    icon_name = name ? name.to_s.parameterize : "none"
    camel_icon = icon_name.tr("-", "_").camelize.delete(" ")
    begin
      render "Blacklight::Icons::#{camel_icon}Component".constantize.new(name: icon_name, **args)
    rescue NameError
      tag.span class: "icon-missing geoblacklight-none"
    end
  end

  ##
  # Looks up formatted names for references
  # @param (String, Symbol) reference
  # @return (String)
  def formatted_name_reference(reference)
    t "geoblacklight.references.#{reference}"
  end

  ##
  # Renders a reference url for a document
  # @param [Hash] document, field_name
  def render_references_url(args)
    url = args[:document]&.references&.url
    return unless url

    endpoint = url.endpoint
    link_to(endpoint, endpoint)
  end

  ## Returns the data-page attribute value used as the JS map selector
  def results_js_map_selector(controller_name)
    case controller_name
    when "bookmarks"
      "bookmarks"
    else
      "index"
    end
  end
end
