# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    # Rails' built-in authentication calls the column email_address, where Devise calls it email
    if AuthenticationHelpers.provider == :rails
      sequence(:email_address) { |n| "user#{n}@example.com" }
    else
      sequence(:email) { |n| "user#{n}@example.com" }
    end
    password { "password" }
    password_confirmation { "password" }
  end
end
