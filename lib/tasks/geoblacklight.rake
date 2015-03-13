require 'rails/generators'
require 'generators/geoblacklight/install_generator'

namespace :geoblacklight do
  namespace :solr do
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
  end
end
