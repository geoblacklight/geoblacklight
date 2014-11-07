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

  def abstract_truncator(abstract)
    if (abstract)
      if (abstract.length > 150)
        html = abstract.slice(0,150) + content_tag(:span, ("..." + link_to("more", "#", :id =>"more-abstract", :data => {no_turbolink: true})).html_safe, :id => "abstract-trunc") + content_tag(:span, abstract.slice(150,abstract.length), :id => "abstract-full", :class => "hidden")
      else
        html = abstract
      end
      content_tag(:span, html.html_safe)
    end
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

  def layer_type_image(type)
    content_tag :span, '', class: "geoblacklight-icon geoblacklight-#{type.downcase}"
  end

  def layer_institution_image(institution)
    content_tag :span, '', class: "geoblacklight-icon geoblacklight-#{institution.downcase}"
  end

  def layer_access_image(access)
    case access
    when 'Restricted'
      content_tag(:i, '', class: 'fa fa-lock fa-lg text-muted  tooltip-icon', 'data-toggle' => 'tooltip', title: 'Restricted', style: 'width: 17px;')
    when 'Public'
      content_tag(:i, '', class: 'fa fa-unlock fa-lg text-muted tooltip-icon',  'data-toggle' => 'tooltip', title: 'Public')
    else
      ""
    end
  end

end
