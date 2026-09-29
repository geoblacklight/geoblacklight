# frozen_string_literal: true

# The app can be generated using Devise auth, Rails auth, or no auth. These
# are for signing in and/or skipping tests depending on which is the case.
module AuthenticationHelpers
  # :devise, :rails, or nil if the app has no authentication
  def self.provider
    if defined?(Devise)
      :devise
    elsif ApplicationController.respond_to?(:allow_unauthenticated_access)
      :rails
    end
  end

  def skip_without_authentication
    skip "the test app has no authentication" unless AuthenticationHelpers.provider
  end

  module Requests
    # Sign a new user in by posting the sign-in form
    def sign_in
      skip_without_authentication
      user = FactoryBot.create(:user)

      if AuthenticationHelpers.provider == :devise
        post user_session_path, params: {user: {email: user.email, password: user.password}}
      else
        post session_path, params: {email_address: user.email_address, password: user.password}
      end
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers
  config.include AuthenticationHelpers::Requests, type: :request
end
