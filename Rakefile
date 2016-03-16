begin
  require 'bundler/gem_tasks'
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

BLACKLIGHT_JETTY_VERSION = '4.10.3'.freeze
ZIP_URL = "https://github.com/projectblacklight/blacklight-jetty/archive/v#{BLACKLIGHT_JETTY_VERSION}.zip".freeze
APP_ROOT = File.dirname(__FILE__)

require 'rspec/core/rake_task'
require 'engine_cart/rake_task'
require 'jettywrapper'
require 'rubocop/rake_task'

Dir.glob('lib/tasks/configure_solr.rake').each { |r| load r }

task default: :ci

desc 'Run style checker'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop-rspec'
  task.fail_on_error = true
end

desc 'Run test suite and style checker'
task spec: :rubocop do
  RSpec::Core::RakeTask.new(:spec)
end

desc 'Load fixtures'
task fixtures: ['engine_cart:generate'] do
  EngineCart.within_test_app do
    system 'rake geoblacklight:solr:seed RAILS_ENV=test'
    system 'rake geoblacklight:downloads:mkdir'
  end
end

desc 'Run Teaspoon JavaScript tests'
task :teaspoon do
  system('teaspoon --require=.internal_test_app/spec/teaspoon_env.rb')
end

desc 'Execute Continuous Integration build'
task :ci do
  if Rails.env.test?
    Rake::Task['engine_cart:generate'].invoke
    Rake::Task['jetty:clean'].invoke
    Rake::Task['geoblacklight:configure_solr'].invoke
    ENV['environment'] = 'test'
    jetty_params = Jettywrapper.load_config
    jetty_params[:startup_wait] = 60

    Jettywrapper.wrap(jetty_params) do
      Rake::Task['fixtures'].invoke

      # run the tests
      Rake::Task['spec'].invoke
    end
    # Run JavaScript tests
    Rake::Task['teaspoon'].invoke
  else
    system('rake ci RAILS_ENV=test')
  end
end
