# frozen_string_literal: true

module Geoblacklight
  class DataDictionaryDownloadComponent < ViewComponent::Base
    attr_reader :document

    def initialize(document:, action:, **)
      @document = document
      super()
    end

    def key
      "data_dictionary"
    end
  end
end
