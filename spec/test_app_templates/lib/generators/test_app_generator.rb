# frozen_string_literal: true
require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root File.expand_path('../../../../spec/test_app_templates', __FILE__)

  def fix_sqlite3_version_requirement
    return unless Gem.loaded_specs['rails'].version.to_s <= '5.2.2'

    # Hack for https://github.com/rails/rails/issues/35153
    # Adapted from https://github.com/projectblacklight/blacklight/pull/2065
    gsub_file('Gemfile', /^gem 'sqlite3'$/, 'gem "sqlite3", "~> 1.3.6"')
  end

  def add_gems
    gem 'blacklight'
    gem 'teaspoon'
    gem 'teaspoon-jasmine'
    gem 'webpacker'
    Bundler.with_clean_env do
      run 'bundle install'
    end
  end

  def run_blacklight_generator
    say_status('warning', 'GENERATING BL', :yellow)

    generate 'blacklight:install', '--devise'
  end

  def install_engine
    generate 'geoblacklight:install', '-f'
  end

  def integrate_webpacker
    generate 'geoblacklight:webpacker', '-f'
  end

  def fixtures
    FileUtils.mkdir_p 'spec/fixtures/solr_documents'
    directory 'solr_documents', 'spec/fixtures/solr_documents'
    FileUtils.mkdir_p 'spec/fixtures/metadata'
    directory 'metadata', 'spec/fixtures/metadata'
  end

  def install_teaspoon
    # Implicit copy of GeoBlacklight checked-in teaspoon_env.rb
    copy_file '../teaspoon_env.rb', 'spec/teaspoon_env.rb'
  end
end
