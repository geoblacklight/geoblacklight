# frozen_string_literal: true

module Geoblacklight
  module Exceptions
    class WrongBoundingBoxFormat < StandardError
    end

    # Raised when config/settings.yml sets a key GeoBlacklight does not recognize.
    class InvalidSettings < StandardError
    end
  end
end
