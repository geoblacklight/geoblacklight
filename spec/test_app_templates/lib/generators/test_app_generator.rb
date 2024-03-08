# frozen_string_literal: true

require "rails/generators"

class TestAppGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../../spec/test_app_templates", __FILE__)

  def add_gems
    gem "blacklight"

    # In CI, Javascript and Webpacker are removed when generating Rails 6.x
    # applications to enable Vite. Disabling javascript during test app
    # generation removes Turbolinks. This gem is required and needs to be
    # re-added.
    if ENV["RAILS_VERSION"] && Gem::Version.new(ENV["RAILS_VERSION"]) < Gem::Version.new("7.0")
      gem "turbolinks"
    end

    Bundler.with_clean_env do
      run "bundle install"
    end
  end

  def run_blacklight_generator
    say_status("warning", "GENERATING BL", :yellow)

    generate "blacklight:install", "--devise"
  end

  def install_engine
    generate "geoblacklight:install", "-f"
  end

  # Symlink fixture document directories so the test app doesn't have to be
  # regenerated when they are changed or updated.
  def fixtures
    solr_docs_path = Rails.root.join("..", "spec", "fixtures", "solr_documents")
    metadata_path = Rails.root.join("..", "spec", "fixtures", "metadata")
    FileUtils.mkdir_p "spec/fixtures"
    FileUtils.symlink solr_docs_path, "spec/fixtures/solr_documents"
    FileUtils.symlink metadata_path, "spec/fixtures/metadata"
  end
end
