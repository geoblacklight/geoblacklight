# frozen_string_literal: true

Config.setup do |config|
  config.const_name = "Settings"
end

# GeoBlacklight v4.1 - New Settings values
Settings.prepend_source!(File.expand_path('new_gbl_settings_defaults_4_1.yml', __dir__))
Settings.reload!