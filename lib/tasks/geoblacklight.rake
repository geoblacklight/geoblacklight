require 'rails/generators'
require 'generators/geoblacklight/install_generator'

namespace :geoblacklight do
  namespace :solr do
    desc "Put sample data into solr"
    task :seed => :environment do
      # docs = JSON::parse(File.read("#{Rails.root}/spec/fixtures/geoblacklight_schema/selected.json"))
      docs = Dir['spec/fixtures/solr_documents/*.json'].map { |f| JSON.parse File.read(f) }.flatten
      Blacklight.solr.add docs
      Blacklight.solr.commit
    end
    
    desc "Ingests a GeoHydra transformed.json"
    task :ingest_all => :environment do
      docs = JSON::parse(File.read("#{Rails.root}/tmp/transformed.json"))
      docs.each do |doc|
        Blacklight.solr.add doc
        Blacklight.solr.commit
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
