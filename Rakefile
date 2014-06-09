require "bundler/gem_tasks"

ZIP_URL = "https://github.com/projectblacklight/blacklight-jetty/archive/v4.6.0.zip"
APP_ROOT = File.dirname(__FILE__)

require 'rspec/core/rake_task'
require 'engine_cart/rake_task'

require 'jettywrapper'

task default: :ci

RSpec::Core::RakeTask.new(:spec)

desc "Load fixtures"
task :fixtures => ['engine_cart:generate'] do
  EngineCart.within_test_app do
    system "rake blacklight_maps:solr:seed RAILS_ENV=test"
  end
end

desc "Execute Continuous Integration build"
task :ci => ['engine_cart:generate', 'jetty:clean', 'blacklight_maps:configure_jetty'] do

  require 'jettywrapper'
  jetty_params = Jettywrapper.load_config('test')

  error = Jettywrapper.wrap(jetty_params) do
    Rake::Task['fixtures'].invoke
    Rake::Task['spec'].invoke
  end
  raise "test failures: #{error}" if error
end


namespace :geoblacklight do
  desc "Copies the default SOLR config for the bundled Testing Server"
  task :configure_jetty do
    FileList['solr_conf/conf/*'].each do |f|
      cp("#{f}", 'jetty/solr/blacklight-core/conf/', :verbose => true)
    end
  end
end
