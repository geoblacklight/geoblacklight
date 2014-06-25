require 'rails/generators'
require 'generators/geoblacklight/install_generator'

namespace :geoblacklight do
  namespace :solr do
    desc "Put sample data into solr"
    task :seed => :environment do
      docs = JSON::parse(File.read("#{Rails.root}/spec/fixtures/geoblacklight_schema/selected.json"))
      Blacklight.solr.add docs
      Blacklight.solr.commit
    end
  end
end
