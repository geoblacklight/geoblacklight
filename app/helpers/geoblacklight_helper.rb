# frozen_string_literal: true

module GeoblacklightHelper
  def document_available?(document = @document)
    document.public? || (document.same_institution? && user_signed_in?)
  end

  def iiif_jpg_url
    @document.references.iiif.endpoint.sub! "info.json", "full/full/0/default.jpg"
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
    icon_name = Settings.ICON_MAPPING && Settings.ICON_MAPPING[icon_name] || icon_name
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
  # Render value for a document's field as a truncate abstract
  # div. Arguments come from Blacklight::DocumentPresenter's
  # get_field_values method
  # @param [Hash] args from get_field_values
  def render_value_as_truncate_abstract(args)
    tag.div class: "truncate-abstract" do
      Array(args[:value]).flatten.join(" ")
    end
  end

  ##
  # Selects the basemap used for map displays
  # @return [String]
  def geoblacklight_basemap
    blacklight_config.basemap_provider || "positron"
  end

  ##
  # Returns a hash of the leaflet plugin settings to pass to the viewer.
  # @return[Hash]
  def leaflet_options
    Settings.LEAFLET
  end

  ##
  # Renders the transformed metadata
  # (Renders a partial when the metadata isn't available)
  # @param [Geoblacklight::Metadata::Base] metadata the metadata object
  # @return [String]
  def render_transformed_metadata(metadata)
    render partial: "catalog/metadata/content", locals: {content: metadata.transform.html_safe}
  rescue Geoblacklight::MetadataTransformer::TransformError => transform_err
    Geoblacklight.logger.warn transform_err.message
    render partial: "catalog/metadata/markup", locals: {content: metadata.to_xml}
  rescue => err
    Geoblacklight.logger.warn err.message
    render partial: "catalog/metadata/missing"
  end

  ##
  # Determines whether or not the metadata is the first within the array of References
  # @param [SolrDocument] document the Solr Document for the item
  # @param [Geoblacklight::Metadata::Base] metadata the object for the metadata resource
  # @return [Boolean]
  def first_metadata?(document, metadata)
    document.references.shown_metadata.first.type == metadata.type
  end

  ##
  # Renders a reference url for a document
  # @param [Hash] document, field_name
  def render_references_url(args)
    return unless args[:document]&.references&.url
    link_to(
      args[:document].references.url.endpoint,
      args[:document].references.url.endpoint
    )
  end

  ## Returns the icon used based off a Settings strategy
  def relations_icon(document, icon)
    icon_html = render Geoblacklight::HeaderIconsComponent.new(document: document, fields: [Settings.FIELDS.GEOM_TYPE]) if Settings.USE_GEOM_FOR_RELATIONS_ICON
    return icon_html unless !Settings.USE_GEOM_FOR_RELATIONS_ICON || icon_html.include?("icon-missing")
    geoblacklight_icon(icon, **{})
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
