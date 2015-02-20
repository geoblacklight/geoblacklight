require 'rails/generators'
require 'generators/geoblacklight/install_generator'
require 'geoblacklight'
require 'open-uri'

namespace :geoblacklight do
  desc 'Copies the default SOLR config for the included Solr'
  task :configure_solr do
    files_urls = [
      {
        url: 'https://raw.githubusercontent.com/geoblacklight/geoblacklight-schema/master/conf/schema.xml',
        file: 'schema.xml'
      },
      {
        url: 'https://raw.githubusercontent.com/geoblacklight/geoblacklight-schema/master/conf/solrconfig.xml',
        file: 'solrconfig.xml'
      }
    ]
    files_urls.each do |item|
      puts item.inspect
      begin
        open(item[:url]) do |io|
          IO.copy_stream(io, "jetty/solr/blacklight-core/conf/#{item[:file]}")
        end
      rescue Exception => e
        abort "Unable to download #{item[:file]} from #{item[:url]} #{e.message}"
      end
    end
  end

  # Leaving this task in for backwards compatibility
  desc 'Runs geoblacklight:configure_solr, you should just use geoblacklight:configure_solr'
  task :configure_jetty do
    Rake::Task['geoblacklight:configure_solr'].invoke
  end
end
