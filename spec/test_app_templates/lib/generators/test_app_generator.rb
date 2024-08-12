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

  def build_frontend
    run "yarn install && yarn build"
  end

  # This makes the assets available in the test app so that changes made in
  # local development can be picked up automatically
  def link_frontend
    run "yarn link"
  end

  def run_blacklight_generator
    say_status("warning", "GENERATING BL", :yellow)

    generate "blacklight:install", "--devise"
  end

  # Install geoblacklight with the `test` option
  def install_engine
    generate "geoblacklight:install", "-f --test"
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
