module GeoblacklightHelper

  def date_to_year(date)
    Date.parse(date).to_formatted_s(:number).slice(0,4)
  end

  def sms_helper()
    content_tag(:i, '', :class => 'fa fa-mobile fa-fw') + ' ' + t('blacklight.tools.sms')
  end

  def email_helper
    content_tag(:i, '', :class => 'fa fa-envelope fa-fw') + ' ' + t('blacklight.tools.email')
  end

  def metadata_helper
    content_tag(:i, '', :class => 'fa fa-download fa-fw') + ' ' + t('Metadata')
  end

  def document_available?
    @document.public? || (@document.same_institution? && user_signed_in?)
  end

  def document_downloadable?
    document_available? && @document.downloadable?
  end

  def snippit(text)
    if (text)
      if (text.length > 150)
        text.slice(0,150) + '...'
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

  def layer_type_image(type)
    content_tag :span, '', class: "geoblacklight-icon geoblacklight-#{type.downcase}"
  end

  def layer_institution_image(institution)
    content_tag :span, '', class: "geoblacklight-icon geoblacklight-#{institution.downcase}"
  end

  def layer_access_image(access)
    case access.downcase
    when 'restricted'
      content_tag(:i, '', class: 'fa fa-lock fa-lg text-muted  tooltip-icon', 'data-toggle' => 'tooltip', title: 'Restricted', style: 'width: 17px;')
    when 'public'
      content_tag(:i, '', class: 'fa fa-unlock fa-lg text-muted tooltip-icon',  'data-toggle' => 'tooltip', title: 'Public')
    else
      ""
    end
  end

  ##
  # Renders an unique array of search links based off of terms
  # passed in using the facet parameter
  #
  def render_facet_links(facet, items)
    items.uniq.map { |item| link_to item, catalog_index_path(f: { "#{facet}" => [item] }) }.join(', ').html_safe
  end
end
