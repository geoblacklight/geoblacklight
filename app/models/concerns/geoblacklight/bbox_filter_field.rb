# frozen_string_literal: true

module Geoblacklight
  class BboxFilterField < Blacklight::SearchState::FilterField
    # this accessor is unnecessary after Blacklight 7.25.0
    attr_accessor :filters_key

    def initialize(*args)
      super
      @filters_key = :bbox
    end

    # @param [String,#value] a filter item to add to the url
    # @return [Blacklight::SearchState] new state
    def add(item)
      new_state = search_state.reset_search
      params = new_state.params
      value = as_url_parameter(item)

      params[filters_key] = value.to_param

      new_state.reset(params)
    end

    # @param [String,#value] a filter to remove from the url
    # @return [Blacklight::SearchState] new state
    def remove(_item)
      new_state = search_state.reset_search
      params = new_state.params

      params.delete(filters_key)
      new_state.reset(params)
    end

    # @return [Array] an array of applied filters
    def values(except: [])
      params = search_state.params
      return [] if except.include?(:filters) || params[filters_key].blank?

      [Geoblacklight::BoundingBox.from_rectangle(params[filters_key])]
    rescue Geoblacklight::Exceptions::WrongBoundingBoxFormat => e
      Rails.logger.warn(e)

      []
    end

    # @param [String,#value] a filter to remove from the url
    # @return [Boolean] whether the provided filter is currently applied/selected
    delegate :include?, to: :values

    # @since Blacklight v7.25.0
    # normal filter fields demangle when they encounter a hash, which they assume to be a number-indexed map
    def needs_normalization?(value_params)
      value_params.is_a?(Hash) && value_params.keys.map(&:to_s).all? { |k| k =~ /^\d+$/ }
    end

    # @since Blacklight v7.25.0
    # value should be the first value from a mangled hash,
    # otherwise return the value as-is
    def normalize(value_params)
      needs_normalization?(value_params) ? value_params.values : value_params
    end
  end
end
