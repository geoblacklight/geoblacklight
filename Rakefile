# frozen_string_literal: true

require "rails"
begin
  require "bundler/setup"
  require "bundler/gem_tasks"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

require "engine_cart/rake_task"
require "rspec/core/rake_task"
require "tasks/solr"

task(:spec).clear
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

desc "Run test suite"
task :ci do
  with_solr do
    Rake::Task["geoblacklight:internal:seed"].invoke
    Rake::Task["geoblacklight:coverage"].invoke
  end
end

namespace :geoblacklight do
  desc "Run tests with coverage"
  task :coverage do
    ENV["COVERAGE"] = "true"
    Rake::Task["spec"].invoke
  end

  namespace :internal do
    task seed: ["engine_cart:generate"] do
      within_test_app do
        system "bundle exec rake geoblacklight:index:seed"
      end
    end
  end

  desc "Run GeoBlacklight and Solr with seed data for interactive development"
  task :server, [:rails_server_args] do |_t, args|
    with_solr do
      Rake::Task["geoblacklight:internal:seed"].invoke

      within_test_app do
        puts "Starting GeoBlacklight (Rails server)"
        puts " "
        begin
          system "bundle exec rails s #{args[:rails_server_args]}"
        rescue Interrupt
          puts "Shutting down..."
        end
      end
    end

    desc "Stdout output asset paths"
    task :asset_paths do
      within_test_app do
        system "bundle exec rake geoblacklight:application_asset_paths"
      end
    end
  end
end

task default: [:ci]
