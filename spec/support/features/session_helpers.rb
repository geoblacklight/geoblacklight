# frozen_string_literal: true

module Features
  module SessionHelpers
    def sign_in
      skip_without_authentication
      visit (AuthenticationHelpers.provider == :devise) ? new_user_session_path : new_session_path
      fill_in_sign_in_form FactoryBot.create(:user)
      # Wait for the persistent "Log Out" nav link rather than the one-shot
      # "Signed in successfully." flash, which can render and then become
      # non-visible before Capybara's default wait time elapses.
      expect(page).to have_link "Log Out"
    end

    def fill_in_sign_in_form(user)
      if AuthenticationHelpers.provider == :devise
        fill_in "user_email", with: user.email
        fill_in "user_password", with: user.password
        click_button "Log in"
      else
        fill_in "email_address", with: user.email_address
        fill_in "password", with: user.password
        click_button "Sign in"
      end
    end
  end
end
