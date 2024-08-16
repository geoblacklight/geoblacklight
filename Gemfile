source "https://rubygems.org"

# Specify your gem's dependencies in geoblacklight.gemspec
gemspec

# BEGIN ENGINE_CART BLOCK
# engine_cart: 2.6.0
# engine_cart stanza: 2.5.0
# the below comes from engine_cart, a gem used to test this Rails engine gem in the context of a Rails app.
file = File.expand_path("Gemfile", ENV["ENGINE_CART_DESTINATION"] || ENV["RAILS_ROOT"] || File.expand_path(".internal_test_app", File.dirname(__FILE__)))
if File.exist?(file)
  begin
    eval_gemfile file
  rescue Bundler::GemfileError => e
    Bundler.ui.warn "[EngineCart] Skipping Rails application dependencies:"
    Bundler.ui.warn e.message
  end
else
  Bundler.ui.warn "[EngineCart] Unable to find test application dependencies in #{file}, using placeholder dependencies"

  if ENV["RAILS_VERSION"]
    if ENV["RAILS_VERSION"] == "edge"
      gem "rails", github: "rails/rails"
      ENV["ENGINE_CART_RAILS_OPTIONS"] = "--edge"
    else
      gem "rails", ENV["RAILS_VERSION"]
    end
  end
end
# END ENGINE_CART BLOCK
