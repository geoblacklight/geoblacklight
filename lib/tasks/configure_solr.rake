require 'rails/generators'
require 'generators/geoblacklight/install_generator'
require 'geoblacklight'
require 'fileutils'

namespace :geoblacklight do
  desc 'Configures Solr for local jetty instance'
  task :configure_solr do
    root = Gem::Specification.find_by_name('geoblacklight').gem_dir rescue '.'
    FileUtils.cp Dir.glob(File.join(root, 'schema', 'solr', 'conf', '*.*')),
                 'jetty/solr/blacklight-core/conf/',
                 verbose: true
  end
end
