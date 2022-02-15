# frozen_string_literal: true

module Geoblacklight
  class BboxFilterField < Blacklight::SearchState::FilterField
    # @param [String,#value] a filter item to add to the url
    # @return [Blacklight::SearchState] new state
    def add(item)
      new_state = search_state.reset_search
      params = new_state.params
      value = as_url_parameter(item)

      params[:bbox] = value.to_param

      new_state.reset(params)
    end

    # @param [String,#value] a filter to remove from the url
    # @return [Blacklight::SearchState] new state
    def remove(_item)
      new_state = search_state.reset_search
      params = new_state.params
      # value = as_url_parameter(item)

      params.delete(:bbox)
      new_state.reset(params)
    end

    # @return [Array] an array of applied filters
    def values
      params = search_state.params
      return super unless params[:bbox]

      bbox = Geoblacklight::BoundingBox.from_rectangle(params[:bbox])

      super + [bbox]
    rescue Geoblacklight::Exceptions::WrongBoundingBoxFormat => e
      Rails.logger.warn(e)

      super
    end

    # @param [String,#value] a filter to remove from the url
    # @return [Boolean] whether the provided filter is currently applied/selected
    delegate :include?, to: :values
  end
end
