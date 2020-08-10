# frozen_string_literal: true
module GeoblacklightHelper
  def document_available?
    @document.public? || (@document.same_institution? && user_signed_in?)
  end

  def document_downloadable?
    document_available? && @document.downloadable?
  end

  def iiif_jpg_url
    @document.references.iiif.endpoint.sub! 'info.json', 'full/full/0/default.jpg'
  end

  def download_link_file(label, id, url)
    link_to(
      label,
      url,
      'contentUrl' => url,
      class: ['btn', 'btn-default', 'download', 'download-original'],
      data: {
        download: 'trigger',
        download_type: 'direct',
        download_id: id
      }
    )
  end

  def download_link_direct(text, document)
    link_to(
      text,
      document.direct_download[:download],
      'contentUrl' => document.direct_download[:download],
      class: ['btn', 'btn-default', 'download', 'download-original'],
      data: {
        download: 'trigger',
        download_type: 'direct',
        download_id: document.id
      }
    )
  end
  deprecation_deprecate download_link_direct: 'Use download_link_file instead'

  def download_link_hgl(text, document)
    link_to(
      text,
      download_hgl_path(id: document),
      class: ['btn', 'btn-default', 'download', 'download-original'],
      data: {
        blacklight_modal: 'trigger',
        download: 'trigger',
        download_type: 'harvard-hgl',
        download_id: document.id
      }
    )
  end

  # Generates the link markup for the IIIF JPEG download
  # @return [String]
  def download_link_iiif
    link_to(
      download_text('JPG'),
      iiif_jpg_url,
      'contentUrl' => iiif_jpg_url,
      class: ['btn', 'btn-default', 'download', 'download-generated'],
      data: {
        download: 'trigger'
      }
    )
  end

  def download_link_generated(download_type, document)
    link_to(
      t('geoblacklight.download.export_link', download_format: proper_case_format(download_type)),
      '',
      class: ['btn', 'btn-default', 'download', 'download-generated'],
      data: {
        download_path: download_path(document.id, type: download_type),
        download: 'trigger',
        download_type: download_type,
        download_id: document.id
      }
    )
  end

  ##
  # Blacklight catalog controller helper method to truncate field value to 150 chars
  # @param [SolrDocument] args
  # @return [String]
  def snippit(args)
    truncate(Array(args[:value]).flatten.join(' '), length: 150)
  end

  def render_facet_tags(facet)
    render_facet_limit(facets_from_request(facet).first,
                       partial: 'facet_tag_item',
                       layout: 'facet_tag_layout')
  end

  ##
  # Returns an SVG icon or empty HTML span element
  # @return [SVG or HTML tag]
  def geoblacklight_icon(name, **args)
    icon_name = name ? name.to_s.parameterize : 'none'
    begin
      blacklight_icon(icon_name, **args)
    rescue Blacklight::Exceptions::IconNotFound
      tag.span class: 'icon-missing geoblacklight-none'
    end
  end

  ##
  # Renders an unique array of search links based off of terms
  # passed in using the facet parameter
  #
  def render_facet_links(facet, items)
    items.uniq.map do |item|
      link_to item, search_catalog_path(f: { facet => [item] })
    end.join(', ').html_safe
  end

  ##
  # Looks up properly formatted names for formats
  #
  def proper_case_format(format)
    t("geoblacklight.formats.#{format.to_s.parameterize(separator: '_')}")
  end

  ##
  # Looks up formatted names for references
  # @param (String, Symbol) reference
  # @return (String)
  def formatted_name_reference(reference)
    t "geoblacklight.references.#{reference}"
  end

  ##
  # Wraps download text with proper_case_format
  #
  def download_text(format)
    download_format = proper_case_format(format)
    value = t('geoblacklight.download.download_link', download_format: download_format)
    value.html_safe
  end

  def download_generated_body(format)
    value = proper_case_format(format)
    value = case value
            when t('geoblacklight.formats.shapefile')
              t('geoblacklight.download.export_shapefile_link')
            when t('geoblacklight.formats.kmz')
              t('geoblacklight.download.export_kmz_link')
            when t('geoblacklight.formats.geojson')
              t('geoblacklight.download.export_geojson_link')
            else
              value
            end

    value.html_safe
  end

  ##
  # Deteremines if a feature should include help text popover
  # @return [Boolean]
  def show_help_text?(feature, key)
    Settings&.HELP_TEXT&.send(feature)&.include?(key)
  end

  ##
  # Render help text popover for a given feature and translation key
  # @return [HTML tag]
  def render_help_text_entry(feature, key)
    if I18n.exists?("geoblacklight.help_text.#{feature}.#{key}", locale)
      help_text = I18n.t("geoblacklight.help_text.#{feature}.#{key}")
      tag.h3 class: 'help-text viewer_protocol h6' do
        tag.a 'data': { toggle: 'popover', title: help_text[:title], content: help_text[:content] } do
          help_text[:title]
        end
      end
    else
      tag.span class: 'help-text translation-missing'
    end
  end

  ##
  # Deteremines if item view should include attribute table
  # @return [Boolean]
  def show_attribute_table?
    document_available? && @document.inspectable?
  end

  ##
  # Render value for a document's field as a truncate abstract
  # div. Arguments come from Blacklight::DocumentPresenter's
  # get_field_values method
  # @param [Hash] args from get_field_values
  def render_value_as_truncate_abstract(args)
    tag.div class: 'truncate-abstract' do
      Array(args[:value]).flatten.join(' ')
    end
  end

  ##
  # Selects the basemap used for map displays
  # @return [String]
  def geoblacklight_basemap
    blacklight_config.basemap_provider || 'positron'
  end

  ##
  # Renders the partials for a Geoblacklight::Reference in the web services
  # modal
  # @param [Geoblacklight::Reference]
  def render_web_services(reference)
    render(
      partial: "web_services_#{reference.type}",
      locals: { reference: reference }
    )
  rescue ActionView::MissingTemplate
    render partial: 'web_services_default', locals: { reference: reference }
  end

  ##
  # Returns a hash of the leaflet plugin settings to pass to the viewer.
  # @return[Hash]
  def leaflet_options
    Settings.LEAFLET
  end

  ##
  # Renders a facet item with an icon placed as the first child of
  # `.facet-label`. This works with `render_facet_value` and
  # `render_selected_facet_value`
  # @return String
  def render_facet_item_with_icon(field_name, item)
    doc = Nokogiri::HTML.fragment(render_facet_item(field_name, item))
    doc.at_css('.facet-label').children.first
       .add_previous_sibling(geoblacklight_icon(item.value, aria_hidden: true, classes: 'svg_tooltip'))
    doc.to_html.html_safe
  end

  ##
  # Renders the transformed metadata
  # (Renders a partial when the metadata isn't available)
  # @param [Geoblacklight::Metadata::Base] metadata the metadata object
  # @return [String]
  def render_transformed_metadata(metadata)
    render partial: 'catalog/metadata/content', locals: { content: metadata.transform.html_safe }
  rescue Geoblacklight::MetadataTransformer::TransformError => transform_err
    Geoblacklight.logger.warn transform_err.message
    render partial: 'catalog/metadata/markup', locals: { content: metadata.to_xml }
  rescue => err
    Geoblacklight.logger.warn err.message
    render partial: 'catalog/metadata/missing'
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
    icon_name = document[Settings.FIELDS.GEOM_TYPE] if Settings.USE_GEOM_FOR_RELATIONS_ICON
    icon_name = icon if icon_name.blank?
    icon_options = {}
    icon_options = { classes: 'svg_tooltip' } if Settings.USE_GEOM_FOR_RELATIONS_ICON
    geoblacklight_icon(icon_name, icon_options)
  end
end
