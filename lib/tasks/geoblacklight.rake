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
    task :precache, %i[doc_id download_type timeout] => [:environment] do |_t, args|
      unless args[:doc_id] && args[:download_type] && args[:timeout]
        raise "Please supply required arguments [document_id, download_type and timeout]"
      end

      document = Geoblacklight::SolrDocument.find(args[:doc_id])
      raise Blacklight::Exceptions::RecordNotFound if document[:id] != args[:doc_id]

      download = "Geoblacklight::#{args[:download_type].capitalize}Download"
        .constantize.new(document, timeout: args[:timeout].to_i)
      download.get
      Rails.logger.info "Successfully downloaded #{download.file_name}"
      Rails.logger.info Geoblacklight::ShapefileDownload.file_path.to_s
    rescue Geoblacklight::Exceptions::ExternalDownloadFailed => e
      Rails.logger.error e.message + " " + e.url
    rescue NameError
      Rails.logger.error "Could not find that download type \"#{args[:download_type]}\""
    end
  end

  desc "Stdout output asset paths"
  task application_asset_paths: [:environment] do
    puts Rails.application.config.assets.paths
  end
end
