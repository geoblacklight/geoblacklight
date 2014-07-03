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
    case type
    when "Polygon"
      image_tag('geoblacklight/type_polygon.png', 'data-toggle' => 'tooltip', title: 'Polygon', :class => 'tooltip-icon')
    when "Line"
      image_tag('geoblacklight/type_arc.png', 'data-toggle' => 'tooltip', title: 'Line', :class => 'tooltip-icon')
    when "Point"
      image_tag('geoblacklight/type_dot.png', 'data-toggle' => 'tooltip', title: 'Point', :class => 'tooltip-icon')
    when "Raster"
      image_tag('geoblacklight/type_raster.png', 'data-toggle' => 'tooltip', title: 'Raster', :class => 'tooltip-icon')
    when "Paper Map"
      image_tag('geoblacklight/type_map.png', 'data-toggle' => 'tooltip', title: 'Paper Map', :class => 'tooltip-icon')
    when "LibraryRecord"
      content_tag(:i, '', class: 'fa fa-book fa-lg text-muted tooltip-icon',  'data-toggle' => 'tooltip', title: 'Library Record')
    else
      ""
    end
  end

  def layer_institution_image(institution)
    case institution
    when /Stanford/
      image_tag('geoblacklight/src_stanford.png', 'data-toggle' => 'tooltip', title: 'Stanford', :class => 'tooltip-icon')
    when /Berkeley/
      image_tag('geoblacklight/src_berkeley.png', 'data-toggle' => 'tooltip', title: 'UC Berkeley', :class => 'tooltip-icon')
    when /Harvard/
      image_tag('geoblacklight/src_harvard.png', 'data-toggle' => 'tooltip', title: 'Harvard', :class => 'tooltip-icon')
    when /MIT/
      image_tag('geoblacklight/src_mit.png', 'data-toggle' => 'tooltip', title: 'MIT', :class => 'tooltip-icon')
    when /Tufts/
      image_tag('geoblacklight/src_tufts.png', 'data-toggle' => 'tooltip', title: 'Tufts', :class => 'tooltip-icon')
    when /MassGIS/
      image_tag('geoblacklight/src_massgis.png', 'data-toggle' => 'tooltip', title: 'MassGIS', :class => 'tooltip-icon')
    else
      ""
    end
  end

  def layer_access_image(access)
    case access
    when 'Restricted'
      content_tag(:i, '', class: 'fa fa-lock fa-lg text-muted  tooltip-icon', 'data-toggle' => 'tooltip', title: 'Restricted')
    when 'Public'
      content_tag(:i, '', class: 'fa fa-unlock fa-lg text-muted tooltip-icon',  'data-toggle' => 'tooltip', title: 'Public')
    else
      ""
    end
  end

end
