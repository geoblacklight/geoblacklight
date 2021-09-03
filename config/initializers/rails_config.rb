# frozen_string_literal: true
Config.setup do |config|
  config.const_name = 'Settings'
end

# GeoBlacklight v3.3 - New Settings.FIELDS values
Settings.prepend_source!(File.expand_path('new_gbl_settings_defaults_3_3.yml', __dir__))
Settings.reload!

# GeoBlacklight v3.4 - New Settings.HOMEPAGE_MAP_GEOM option
Settings.prepend_source!(File.expand_path('new_gbl_settings_defaults_3_4.yml', __dir__))
Settings.reload!
