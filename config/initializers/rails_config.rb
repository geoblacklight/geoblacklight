# frozen_string_literal: true
Config.setup do |config|
  config.const_name = 'Settings'
end

# GeoBlacklight v3.3 - New Settings.FIELDS values
Settings.prepend_source!(File.expand_path('new_gbl_settings_defaults_3_3.yml', __dir__))
Settings.reload!
