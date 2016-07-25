require 'rails/generators'
require 'generators/geoblacklight/install_generator'

namespace :geoblacklight do
  desc 'Run Solr and GeoBlacklight for interactive development'
  task :server, [:rails_server_args] do |_t, args|
    SolrWrapper.wrap(port: '8983') do |solr|
      solr.with_collection(name: 'blacklight-core', dir: File.join(File.expand_path('../../', File.dirname(__FILE__)), 'solr', 'conf')) do
        system "bundle exec rails s #{args[:rails_server_args]}"
      end
    end
  end

  namespace :index do
    desc "Put sample data into solr"
    task :seed => :environment do
      docs = Dir['spec/fixtures/solr_documents/*.json'].map { |f| JSON.parse File.read(f) }.flatten
      Blacklight.default_index.connection.add docs
      Blacklight.default_index.connection.commit
    end

    desc "Ingests a GeoHydra transformed.json"
    task :ingest_all => :environment do
      docs = JSON::parse(File.read("#{Rails.root}/tmp/transformed.json"))
      docs.each do |doc|
        Blacklight.default_index.connection.add doc
        Blacklight.default_index.connection.commit
      end
    end

    desc "Ingests a directory of geoblacklight.json files"
    task :ingest, [:directory] => :environment do |_t, args|
      args.with_defaults(directory: 'data')
      Dir.glob(File.join(args[:directory], '**', 'geoblacklight.json')).each do |fn|
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
    desc 'Delete all cached downloads'
    task delete: :environment do
      FileUtils.rm_rf Dir.glob("#{Rails.root}/tmp/cache/downloads/*")
    end
    desc 'Create download directory'
    task mkdir: :environment do
      FileUtils.mkdir_p Dir.glob("#{Rails.root}/tmp/cache/downloads")
    end
    desc 'Precaches a download'
    task :precache, [:doc_id, :download_type, :timeout] => [:environment] do |t, args|
      begin
        fail 'Please supply required arguments [document_id, download_type and timeout]' unless args[:doc_id] && args[:download_type] && args[:timeout]
        document = Geoblacklight::SolrDocument.find(args[:doc_id])
        fail Blacklight::Exceptions::RecordNotFound if document[:layer_slug_s] != args[:doc_id]
        download = "Geoblacklight::#{args[:download_type].capitalize}Download"
                   .constantize.new(document, timeout: args[:timeout].to_i)
        download.get
        Rails.logger.info "Successfully downloaded #{download.file_name}"
        Rails.logger.info "#{Geoblacklight::ShapefileDownload.file_path}"
      rescue Geoblacklight::Exceptions::ExternalDownloadFailed => error
        Rails.logger.error error.message + ' ' + error.url
      rescue NameError
        Rails.logger.error "Could not find that download type \"#{args[:download_type]}\""
      end
    end
  end
end
