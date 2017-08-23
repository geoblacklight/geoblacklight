module GeoblacklightHelper
  extend Deprecation
  self.deprecation_horizon = 'Geoblacklight 2.0.0'

  def sms_helper
    content_tag(:i, '', class: 'fa fa-mobile fa-fw') + ' ' + t('blacklight.tools.sms')
  end

  def email_helper
    content_tag(:i, '', class: 'fa fa-envelope fa-fw') + ' ' + t('blacklight.tools.email')
  end

  def document_available?
    @document.public? || (@document.same_institution? && user_signed_in?)
  end

  def document_downloadable?
    document_available? && @document.downloadable?
  end

  def iiif_jpg_url
    @document.references.iiif.endpoint.sub! 'info.json', 'full/full/0/default.jpg'
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

  def geoblacklight_icon(name)
    content_tag :span,
                '',
                class: "geoblacklight-icon geoblacklight-#{name.parameterize}",
                title: name
  end

  def render_search_form_no_navbar
    render partial: 'catalog/search_form_no_navbar'
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
    t "geoblacklight.formats.#{format.downcase}"
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
    "#{t 'geoblacklight.download.download'} #{proper_case_format(format)}".html_safe
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
    content_tag :div, class: 'truncate-abstract' do
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
  # Removes blank space from provider to accomodate CartoDB OneClick
  # @deprecated Use {#carto_provider} instead.
  def cartodb_provider
    carto_provider
  end
  deprecation_deprecate cartodb_provider: 'use GeoblacklightHelper#carto_provider instead'

  ##
  # Creates a Carto OneClick link link, using the configuration link
  # @param [String] file_link
  # @return [String]
  # @deprecated Use {#carto_link} instead.
  def cartodb_link(file_link)
    carto_link(file_link)
  end
  deprecation_deprecate carto_link: 'use GeoblacklightHelper#carto_link instead'

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
       .add_previous_sibling(geoblacklight_icon(item.value))
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
end
