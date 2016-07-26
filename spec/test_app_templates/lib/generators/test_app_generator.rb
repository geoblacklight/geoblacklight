require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root File.expand_path('../../../../spec/test_app_templates', __FILE__)

  def add_gems
    gem 'blacklight', '~> 6.3'
    gem 'teaspoon'
    gem 'teaspoon-jasmine'
    Bundler.with_clean_env do
      run 'bundle install'
    end
  end

  def run_blacklight_generator
    say_status('warning', 'GENERATING BL', :yellow)

    generate 'blacklight:install', '--devise'
  end

  def install_engine
    generate 'geoblacklight:install'
  end

  def fixtures
    FileUtils.mkdir_p 'spec/fixtures/solr_documents'
    directory 'solr_documents', 'spec/fixtures/solr_documents'
  end

  def install_teaspoon
    # Implicit copy of GeoBlacklight checked-in teaspoon_env.rb
    copy_file '../teaspoon_env.rb', 'spec/teaspoon_env.rb'
  end
end
