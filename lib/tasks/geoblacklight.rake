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
  yield
ensure
  puts "Stopping Solr"
  system_with_error_handling "docker compose stop solr"
end

namespace :geoblacklight do
  desc "Run Solr and GeoBlacklight for interactive development"
  task :server, [:rails_server_args] do |_t, args|
    with_solr do
      Rake::Task["geoblacklight:internal:seed"].invoke

      puts "Starting GeoBlacklight (Rails server)"
      puts " "
      begin
        system "bundle exec rails s #{args[:rails_server_args]}"
      rescue Interrupt
        puts "Shutting down..."
      end
    end
  end

  # Local fixtures: bundle exec rake "geoblacklight:index:seed"
  # Remote fixtures: bundle exec rake "geoblacklight:index:seed[:remote]"
  namespace :index do
    desc "Index GBL test fixture metadata into Solr"
    task :seed, [:remote] => :environment do |t, args|
      docs = []

      if args.remote
        puts "Indexing - Remote test fixtures"
        JSON.parse(
          URI.parse("https://api.github.com/repos/geoblacklight/geoblacklight/contents/spec/fixtures/solr_documents").open.read
        ).each do |fixture|
          if fixture["name"].include?(".json")
            docs << JSON.parse(URI.parse(fixture["download_url"]).open.read)
          end
        end
      else
        puts "Indexing - Local test fixtures"
        docs = Dir["spec/fixtures/solr_documents/*.json"].map { |f| JSON.parse File.read(f) }.flatten
      end

      Blacklight.default_index.connection.add docs
      Blacklight.default_index.connection.commit
    end

    desc "Ingests a GeoHydra transformed.json"
    task ingest_all: :environment do
      docs = JSON.parse(File.read(Rails.root.join("tmp", "transformed.json")))
      docs.each do |doc|
        Blacklight.default_index.connection.add doc
        Blacklight.default_index.connection.commit
      end
    end

    desc "Ingests a directory of geoblacklight.json files"
    task :ingest, [:directory] => :environment do |_t, args|
      args.with_defaults(directory: "data")
      Dir.glob(File.join(args[:directory], "**", "geoblacklight.json")).each do |fn|
        puts "Ingesting #{fn}"
        begin
          Blacklight.default_index.connection.add(JSON.parse(File.read(fn)))
        rescue => e
          puts "Failed to ingest #{fn}: #{e.inspect}"
        end
      end
      puts "Committing changes to Solr"
      Blacklight.default_index.connection.commit
    end
  end

  namespace :downloads do
    desc "Delete all cached downloads"
    task delete: :environment do
      FileUtils.rm_rf Dir.glob(Rails.root.join("tmp", "cache", "downloads", "*"))
    end
    desc "Create download directory"
    task mkdir: :environment do
      FileUtils.mkdir_p(Rails.root.join("tmp", "cache", "downloads"), verbose: true)
    end
    desc "Precaches a download"
    task :precache, [:doc_id, :download_type, :timeout] => [:environment] do |_t, args|
      unless args[:doc_id] && args[:download_type] && args[:timeout]
        fail "Please supply required arguments [document_id, download_type and timeout]"
      end
      document = Geoblacklight::SolrDocument.find(args[:doc_id])
      fail Blacklight::Exceptions::RecordNotFound if document[:id] != args[:doc_id]
      download = "Geoblacklight::#{args[:download_type].capitalize}Download"
        .constantize.new(document, timeout: args[:timeout].to_i)
      download.get
      Rails.logger.info "Successfully downloaded #{download.file_name}"
      Rails.logger.info Geoblacklight::ShapefileDownload.file_path.to_s
    rescue Geoblacklight::Exceptions::ExternalDownloadFailed => error
      Rails.logger.error error.message + " " + error.url
    rescue NameError
      Rails.logger.error "Could not find that download type \"#{args[:download_type]}\""
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

    desc "Put sample data into solr"
    task seed: :environment do
      Rake::Task["geoblacklight:index:seed"].invoke
    end
  end

  desc "Stdout output asset paths"
  task application_asset_paths: [:environment] do
    puts Rails.application.config.assets.paths
  end
end
