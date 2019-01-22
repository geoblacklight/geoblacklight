require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root File.expand_path('../../../../spec/test_app_templates', __FILE__)

  def add_gems
    gem 'blacklight'
    gem 'teaspoon'
    gem 'teaspoon-jasmine'
    gem 'webpacker', '~> 3.5'
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

  # This is necessary in order to avoid the Yarn integrity check error
  def javascript_install
    exit_status = system('yarn --version')
    if !exit_status.nil?
      run 'yarn install'
    else
      run 'npm install'
    end
  end
end
