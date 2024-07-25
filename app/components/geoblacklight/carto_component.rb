# frozen_string_literal: true

module Geoblacklight
  class CartoComponent < ViewComponent::Base
    attr_reader :document
    def initialize(document:, **)
      @document = document
      super
    end

    def key
      "carto"
    end

    ##
    # Creates a Carto OneClick link, using the configuration link
    # @param [String] file_link
    # @return [String]
    def carto_link
      params = URI.encode_www_form(
        file: document.carto_reference,
        provider: carto_provider,
        logo: Settings.APPLICATION_LOGO_URL
      )
      "#{carto_oneclick_host}?#{params}"
    end

    ##
    # Removes blank space from provider to accomodate Carto OneClick
    #
    def carto_provider
      helpers.application_name.delete(" ")
    end

    private

    ##
    # Method used to access setting and provide deprecation warnings to migrate
    def carto_oneclick_host
      Settings.CARTO_ONECLICK_LINK
    end
  end
end
