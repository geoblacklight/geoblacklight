# frozen_string_literal: true

module Features
  module SessionHelpers
    def sign_up_with(email, password)
      visit new_user_registration_path
      fill_in "Email", with: email
      fill_in "Password", with: password
      click_button "Sign up"
    end

    def sign_in
      user = FactoryBot.create(:user)
      user.save
      visit new_user_session_path
      fill_in "user_email", with: user.email
      fill_in "user_password", with: user.password
      click_button "Log in"
      # Wait for the persistent "Log Out" nav link rather than the one-shot
      # "Signed in successfully." flash, which can render and then become
      # non-visible before Capybara's default wait time elapses.
      expect(page).to have_link "Log Out"
    end
  end
end
