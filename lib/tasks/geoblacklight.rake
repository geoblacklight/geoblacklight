# frozen_string_literal: true

require "rails/generators"
require "generators/geoblacklight/install_generator"

def system_with_error_handling(*args)
  Open3.popen3(*args) do |_stdin, stdout, stderr, thread|
    puts stdout.read
    raise "Unable to run #{args.inspect}: #{stderr.read}" unless thread.value.success?
  end
end

def with_solr(&block)
  puts "Starting Solr"
  system_with_error_handling "docker compose up -d solr"
  sleep 5 # give solr a few seconds to load the core config and be ready
  yield
ensure
  puts "Stopping Solr"
  system_with_error_handling "docker compose stop solr"
end

namespace :geoblacklight do
  desc "Run Solr and GeoBlacklight for interactive development"
  task :server, [:rails_server_args] do |_t, args|
    with_solr do
      Rake::Task["geoblacklight:index:seed"].invoke

      puts "Starting GeoBlacklight (Rails server)"
      puts " "
      begin
        system "bundle exec rails s #{args[:rails_server_args]}"
      rescue Interrupt
        puts "Shutting down..."
      end
    end
  end

  # Get fixture items bundled with the gem and index them into Solr
  namespace :index do
    desc "Index GBL test fixture metadata into Solr"
    task seed: :environment do
      puts "Indexing test fixtures"

      gem_path = Gem::Specification.find_by_name("geoblacklight").gem_dir
      fixtures_path = File.join(gem_path, "spec", "fixtures", "solr_documents", "*.json")
      docs = Dir[fixtures_path].flat_map { |f| JSON.parse(File.read(f)) }

      Blacklight.default_index.connection.add docs
      Blacklight.default_index.connection.commit
    end
  end

  desc "Stdout output asset paths"
  task application_asset_paths: [:environment] do
    puts Rails.application.config.assets.paths
  end
end
