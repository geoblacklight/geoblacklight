# frozen_string_literal: true

module Geoblacklight
  # Display login link
  class LoginLinkComponent < ViewComponent::Base
    attr_reader :document

    def initialize(document:)
      @document = document
      super()
    end

    def render?
      document.restricted? && document.same_institution? && !helpers.user_signed_in?
    end
  end
end
