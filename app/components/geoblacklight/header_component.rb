# frozen_string_literal: true

module Geoblacklight
  class HeaderComponent < Blacklight::HeaderComponent
    def not_landing_page?
      controller_name == "catalog" && (helpers.has_search_parameters? || params[:action] == "show")
    end
  end
end
