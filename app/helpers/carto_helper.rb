# frozen_string_literal: true
module CartoHelper
  ##
  # Creates a Carto OneClick link, using the configuration link
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
    Settings.CARTO_ONECLICK_LINK
  end
end
