# frozen_string_literal: true
module Geoblacklight
  module Metadata
    class Html < Base
      def transform
        ActionController::Base.helpers.tag.iframe('',
                                                   src: @reference.endpoint,
                                                   scrolling: 'yes',
                                                   frameborder: 0)
      end
    end
  end
end
