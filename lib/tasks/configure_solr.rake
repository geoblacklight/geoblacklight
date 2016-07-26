require 'rails/generators'
require 'generators/geoblacklight/install_generator'
require 'geoblacklight'
require 'fileutils'

namespace :geoblacklight do
  desc 'Configures Solr for local jetty instance'
  task :configure_solr do
    root = Gem::Specification.find_by_name('geoblacklight').gem_dir rescue '.'
    [
      {
        src: "schema/solr/conf/schema.xml",
        file: 'schema.xml'
      },
      {
        src: "schema/solr/conf/solrconfig.xml",
        file: 'solrconfig.xml'
      }
    ].each do |item|
      FileUtils.cp File.join(root, item[:src]), "jetty/solr/blacklight-core/conf/#{item[:file]}", verbose: true
    end
  end

  # Leaving this task in for backwards compatibility
  desc 'Runs geoblacklight:configure_solr, you should just use geoblacklight:configure_solr'
  task configure_jetty: :configure_solr
end
