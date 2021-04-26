# encoding: UTF-8
# frozen_string_literal: true
require 'rails'
begin
  require 'bundler/setup'
  require 'bundler/gem_tasks'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'solr_wrapper'
require 'solr_wrapper/rake_task'
require 'engine_cart/rake_task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'solr_wrapper/rake_task'

desc 'Run RuboCop style checker'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop-rspec'
  task.fail_on_error = true
end

task(:spec).clear
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

desc 'Run JavaScript unit tests'
task :javascript_tests do
  system '/bin/bash -c yarn test'
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
  Rake::Task['javascript_tests'].invoke
end

namespace :geoblacklight do
  desc 'Run tests with coverage'
  task :coverage do
    ENV['COVERAGE'] = 'true'
    Rake::Task['spec'].invoke
  end

  desc 'Create the test rails app'
  task generate: ['engine_cart:generate'] do
    # Intentionally Empty Block
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
          puts "\nSolr server running: http://localhost:#{solr.port}/solr/#/blacklight-core"
          puts "\n^C to stop"
          puts ' '
          begin
            system "bundle exec rails s #{args[:rails_server_args]}"
          rescue Interrupt
            puts 'Shutting down...'
          end
        end
      end
    end
  end

  desc 'Run Solr and seed with sample data'
  task :solr do
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
          puts "\nSolr server running: http://localhost:#{solr.port}/solr/#/blacklight-core"
          puts "\n^C to stop"
          puts ' '
          begin
            sleep
          rescue Interrupt
            puts 'Shutting down...'
          end
        end
      end
    end
  end

  desc 'Stdout output asset paths'
  task :asset_paths do
    within_test_app do
      system 'bundle exec rake geoblacklight:application_asset_paths'
    end
  end
end

task default: [:ci]
