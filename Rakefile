# encoding: UTF-8
require 'rails'
begin
  require 'bundler/setup'
  require 'bundler/gem_tasks'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'solr_wrapper'
require 'engine_cart/rake_task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

EngineCart.fingerprint_proc = EngineCart.rails_fingerprint_proc

desc 'Run style checker'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop-rspec'
  task.fail_on_error = true
end

desc 'Run test suite and style checker'
task spec: :rubocop do
  RSpec::Core::RakeTask.new(:spec)
end

desc 'Run Teaspoon JavaScript tests'
task :teaspoon do
  system('teaspoon --require=.internal_test_app/spec/teaspoon_env.rb')
end

desc 'Run test suite'
task ci: ['geoblacklight:generate'] do
  SolrWrapper.wrap do |solr|
    solr.with_collection(name: 'blacklight-core', dir: File.join(File.expand_path('.', File.dirname(__FILE__)), 'solr', 'conf')) do
      within_test_app do
        system 'RAILS_ENV=test rake geoblacklight:index:seed'
      end
      Rake::Task['geoblacklight:coverage'].invoke
    end
  end
  # Run JavaScript tests
  Rake::Task['teaspoon'].invoke
end

namespace :geoblacklight do
  desc 'Run tests with coverage'
  task :coverage do
    ENV['COVERAGE'] = 'true'
    Rake::Task['spec'].invoke
  end

  desc 'Create the test rails app'
  task generate: ['engine_cart:generate'] do
  end

  namespace :internal do
    task seed: ['engine_cart:generate'] do
      within_test_app do
        system 'bundle exec rake geoblacklight:index:seed'
        system 'bundle exec rake geoblacklight:downloads:mkdir'
      end
    end
  end

  desc 'Run Solr and GeoBlacklight for interactive development'
  task :server, [:rails_server_args] do |_t, args|
    if File.exist? EngineCart.destination
      within_test_app do
        system 'bundle update'
      end
    else
      Rake::Task['engine_cart:generate'].invoke
    end

    SolrWrapper.wrap(port: '8983') do |solr|
      solr.with_collection(name: 'blacklight-core', dir: File.join(File.expand_path('.', File.dirname(__FILE__)), 'solr', 'conf')) do
        Rake::Task['geoblacklight:internal:seed'].invoke

        within_test_app do
          system "bundle exec rails s #{args[:rails_server_args]}"
        end
      end
    end
  end
end

task default: [:ci]
