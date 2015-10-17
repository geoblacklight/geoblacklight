module Geoblacklight
  ##
  # Adds helper behavior logic for GeoBlacklight, to used alongside
  # BlacklightHelperBehavior
  module GeoblacklightHelperBehavior
    ##
    # @param [SolrDocument]
    # @return [String]
    def wxs_identifier(document = nil)
      document ||= @document
      presenter(document).wxs_identifier
    end

    ##
    # Use the Geoblacklight::DocumentPresenter
    def presenter_class
      Geoblacklight::DocumentPresenter
    end
  end
end
