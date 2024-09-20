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

# Ensure the app generates with Propshaft; sprockets is no longer supported
# https://github.com/geoblacklight/geoblacklight/issues/1265
ENV["ENGINE_CART_RAILS_OPTIONS"] = ENV["ENGINE_CART_RAILS_OPTIONS"].to_s + " -a propshaft"

task(:spec).clear
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

desc "Run JavaScript unit tests"
task :javascript_tests do
  system "/bin/bash -c yarn test"
end

desc "Run test suite"
task ci: ["geoblacklight:generate"] do
  within_test_app do
    system "RAILS_ENV=test rake geoblacklight:index:seed"
  end

  # Run RSpec tests with Coverage
  Rake::Task["geoblacklight:coverage"].invoke

  # Run JavaScript tests
  Rake::Task["javascript_tests"].invoke
end

namespace :geoblacklight do
  desc "Run tests with coverage"
  task :coverage do
    ENV["COVERAGE"] = "true"
    Rake::Task["spec"].invoke
  end

  desc "Create the test rails app"
  task generate: ["engine_cart:generate"] do
    # Intentionally Empty Block
  end

  namespace :internal do
    task :seed do
      within_test_app do
        system "bundle exec rake geoblacklight:index:seed"
        system "bundle exec rake geoblacklight:downloads:mkdir"
      end
    end
  end

  desc "Run GeoBlacklight server (without Solr)"
  task :server_only, [:rails_server_args] do |_t, args|
    if File.exist? EngineCart.destination
      within_test_app do
        system "bundle update"
      end
    else
      Rake::Task["engine_cart:generate"].invoke
    end

    within_test_app do
      puts "\n^C to stop the rails server"
      puts " "
      begin
        system "bundle exec rails s #{args[:rails_server_args]}"
      rescue Interrupt
        puts "Shutting down the rails server..."
      end
    end
  end

  desc "Run GeoBlacklight and Solr with seed data for interactive development"
  task :server, [:rails_server_args] do |_t, args|
    if File.exist? EngineCart.destination
      within_test_app do
        system "bundle update"
      end
    else
      Rake::Task["engine_cart:generate"].invoke
    end

    system "docker compose up -d"
    Rake::Task["geoblacklight:internal:seed"].invoke

    begin
      within_test_app do
        puts "\nSolr server running: http://localhost:8983/solr/#/blacklight-core"
        puts " "
        begin
          system "bundle exec rails s #{args[:rails_server_args]}"
        rescue Interrupt
          puts "Shutting down..."
        end
      end
    ensure
      system "docker compose down"
    end
  end

  namespace :solr do
    desc "Start Solr and seed with sample data"
    task :start do
      system "docker compose up -d"
      Rake::Task["geoblacklight:internal:seed"].invoke
      puts "\nSolr server running: http://localhost:8983/solr/#/blacklight-core"
      puts " "
    end

    desc "Stop Solr"
    task :stop do
      system "docker compose down"
    end
  end

  desc "Stdout output asset paths"
  task :asset_paths do
    within_test_app do
      system "bundle exec rake geoblacklight:application_asset_paths"
    end
  end
end

task default: [:ci]
