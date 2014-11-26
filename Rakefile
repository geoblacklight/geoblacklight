begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

BLACKLIGHT_JETTY_VERSION = '4.10.0'
ZIP_URL = "https://github.com/projectblacklight/blacklight-jetty/archive/v#{BLACKLIGHT_JETTY_VERSION}.zip"
APP_ROOT = File.dirname(__FILE__)

require 'rspec/core/rake_task'
require 'engine_cart/rake_task'
require 'jettywrapper'

task default: :ci

RSpec::Core::RakeTask.new(:spec)

desc "Load fixtures"
task :fixtures => ['engine_cart:generate'] do
  EngineCart.within_test_app do
    system "rake geoblacklight:solr:seed RAILS_ENV=test"
  end
end

desc "Execute Continuous Integration build"
task :ci => ['engine_cart:generate', 'jetty:clean', 'geoblacklight:configure_jetty'] do
  ENV['environment'] = "test"
  jetty_params = Jettywrapper.load_config
  jetty_params[:startup_wait]= 60

  Jettywrapper.wrap(jetty_params) do
    Rake::Task["fixtures"].invoke

    # run the tests
    Rake::Task["spec"].invoke
  end
end


namespace :geoblacklight do
  desc "Copies the default SOLR config for the bundled Testing Server"
  task :configure_jetty do
    FileList['schema/conf/*'].each do |f|
      cp("#{f}", 'jetty/solr/blacklight-core/conf/', :verbose => true)
    end
  end
end
