module GeoblacklightHelper

  def sms_helper()
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

  def snippit(text)
    if text
      if text.length > 150
        text.slice(0, 150) + '...'
      else
        text
      end
    else
      ''
    end
  end

  def render_facet_tags(facet)
    render_facet_limit(facets_from_request(facet).first, partial: 'facet_tag_item', layout: 'facet_tag_layout')
  end

  def geoblacklight_icon(name)
    content_tag :span, '', class: "geoblacklight-icon geoblacklight-#{name.downcase.gsub(' ', '-')}", title: name
  end

  def render_search_form_no_navbar
    render partial: 'catalog/search_form_no_navbar'
  end

  ##
  # Renders an unique array of search links based off of terms
  # passed in using the facet parameter
  #
  def render_facet_links(facet, items)
    items.uniq.map { |item| link_to item, catalog_index_path(f: { "#{facet}" => [item] }) }.join(', ').html_safe
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
      args[:value]
    end
  end

  ##
  # Selects the basemap used for map displays
  # @return [String]
  def geoblacklight_basemap
    blacklight_config.basemap_provider || 'mapquest'
  end

  ##
  # Creates a CartoDB OneClick link link, using the configuration link
  # @param [String] file_link
  # @return [String]
  def cartodb_link(file_link)
    params  = URI.encode_www_form(
      file: file_link,
      provider: application_name,
      logo: Settings.APPLICATION_LOGO_URL
    )
    Settings.CARTODB_ONECLICK_LINK + '?' + params
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
end
