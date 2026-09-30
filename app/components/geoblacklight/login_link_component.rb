# frozen_string_literal: true

module Geoblacklight
  # Display login link
  class LoginLinkComponent < ViewComponent::Base
    attr_reader :document

    def initialize(document:)
      @document = document
      super()
    end

    def before_render
      store_return_location if render?
    end

    def render?
      document.restricted? &&
        document.same_institution? &&
        helpers.blacklight_login_path.present? &&
        !helpers.current_user_signed_in?
    end

    private

    # Bring the user back to this record once they've signed in, for either
    # Devise or Rails auth.
    def store_return_location
      controller.store_location_for(:user, request.original_url) if controller.respond_to?(:store_location_for)
      controller.send(:store_location_for_rails_authentication)
    end
  end
end
