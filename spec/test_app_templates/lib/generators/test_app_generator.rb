# frozen_string_literal: true

require "rails/generators"

class TestAppGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../../spec/test_app_templates", __FILE__)

  def add_gems
    gem "blacklight"

    Bundler.with_unbundled_env do
      run "bundle install"
    end
  end

  # Install blacklight
  def run_blacklight_generator
    say_status("warning", "GENERATING BL", :yellow)
    generate "blacklight:install", "--devise", "--skip-solr"
  end

  # Install geoblacklight
  def install_engine
    say_status("warning", "GENERATING GBL", :yellow)
    generate "geoblacklight:install"
  end

  # Symlink the frontend package from the outer directory so changes to styles
  # are visible without needing to publish to npm.
  def symlink_frontend_package
    inside("..") { run "yarn link" }
    run "yarn link @geoblacklight/frontend"
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
