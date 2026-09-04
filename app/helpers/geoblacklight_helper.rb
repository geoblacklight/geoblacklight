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

  # If you turn off dark mode support, Geoblacklight will display in light mode,
  # but ogm-viewer will still try to honor a system dark mode preference. This
  # ensures that everything stays light until you explicitly enable dark mode.
  def geoblacklight_viewer_theme
    return if blacklight_config.dark_mode_support

    "light"
  end

  ##
  # Transform markdown into HTML
  # @param [String] value markdown to transform
  # @return [ActiveSupport::SafeBuffer] rendered HTML
  def markdown_to_html(value)
    Commonmarker.to_html(value).html_safe
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

  ##
  # Blacklight view_config.thumbnail_method contract. Renders the document's
  # configured thumbnail_url as an <img>, or nil if unavailable/disabled.
  # @param [SolrDocument] document
  # @param [Hash] image_options
  # @return [String, nil]
  def geoblacklight_thumbnail(document, image_options = {})
    return unless Geoblacklight.configuration.thumbnails_enabled

    url = document.thumbnail_url
    return if url.blank?

    image_tag url, {loading: "lazy"}.merge(image_options)
  end

  ##
  # Blacklight view_config.default_thumbnail (Symbol) contract. Falls back to
  # a placeholder icon based on the document's resource/data type.
  # @param [SolrDocument] document
  # @param [Hash] _image_options unused; icons aren't rendered as <img>
  # @return [String, nil]
  def geoblacklight_default_thumbnail(document, _image_options = {})
    return unless Geoblacklight.configuration.thumbnails_enabled

    default_thumbnail_icon(document)
  end

  private

  ##
  # @param [SolrDocument] document
  # @return [String]
  def default_thumbnail_icon(document)
    dataset_type = document.resource_type&.find { |type| type.include?(" data") }&.gsub(" data", "")
    name = [dataset_type, document.resource_class&.first].compact.first
    geoblacklight_icon(name)
  end
end
