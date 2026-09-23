# frozen_string_literal: true

module Geoblacklight
  ##
  # A document's thumbnail image, stacked over the fallback icon that would
  # stand in for it. The icon is on the page from the start, so a result has
  # something to show while the image is still on its way - and keeps it if the
  # image never arrives. The browser does the swap on its own: see search.css.
  class ThumbnailComponent < ViewComponent::Base
    attr_reader :url, :fallback

    # @param [String] url the thumbnail image URL
    # @param [String] fallback rendered icon shown until the image loads
    # @param [Hash] image_options attributes for the image tag
    def initialize(url:, fallback:, image_options: {})
      @url = url
      @fallback = fallback
      @image_options = image_options
      super()
    end

    # An application's options win over our defaults, but the class that stacks
    # the image over the fallback is merged in rather than replaced.
    def image_options
      {alt: "", loading: "lazy"}.merge(@image_options).merge(
        class: Array(@image_options[:class]) + ["thumbnail-image"]
      )
    end
  end
end
