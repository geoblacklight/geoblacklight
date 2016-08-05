module CartoHelper
  ##
  # Creates a Carto OneClick link link, using the configuration link
  # @param [String] file_link
  # @return [String]
  def carto_link(file_link)
    params = URI.encode_www_form(
      file: file_link,
      provider: carto_provider,
      logo: Settings.APPLICATION_LOGO_URL
    )
    carto_oneclick_host + '?' + params
  end

  ##
  # Removes blank space from provider to accomodate Carto OneClick
  #
  def carto_provider
    application_name.delete(' ')
  end

  private

  ##
  # Method used to access setting and provide deprecation warnings to migrate
  def carto_oneclick_host
    if Settings.CARTODB_ONECLICK_LINK.present?
      Deprecation.warn(
        GeoblacklightHelper,
        'Settings.CARTODB_ONECLICK_LINK is deprecated and will be removed in ' \
        'Geoblacklight 2.0.0, use Settings.CARTO_ONECLICK_LINK instead'
      )
    end
    Settings.CARTO_ONECLICK_LINK || Settings.CARTODB_ONECLICK_LINK
  end
end
