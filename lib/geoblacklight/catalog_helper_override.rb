# frozen_string_literal: true
module Geoblacklight
  module CatalogHelperOverride
    ##
    # Removes spatial query from params
    # @param [Symbol] symbol of field to be removed
    # @param [Hash] request parameters
    def remove_spatial_filter_group(field, source_params = params)
      p = source_params.dup.to_h
      p.delete(field.to_s)
      p
    end
  end
end
