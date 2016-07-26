# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geoblacklight/version'

Gem::Specification.new do |spec|
  spec.name          = 'geoblacklight'
  spec.version       = Geoblacklight::VERSION
  spec.authors       = ['Mike Graves', 'Darren Hardy', 'Eliot Jordan', 'Jack Reed']
  spec.email         = ['mgraves@mit.edu', 'drh@stanford.edu', 'eliotj@princeton.edu', 'pjreed@stanford.edu']
  spec.summary       = 'A discovery platform for geospatial holdings'
  spec.description   = 'GeoBlacklight provides a world-class discovery platform for geospatial (GIS) holdings. It is an open collaborative project aiming to build off of the successes of the Blacklight Solr-powered discovery interface and the multi-institutional OpenGeoportal federated metadata sharing communities.'
  spec.homepage      = 'http://github.com/geoblacklight/geoblacklight'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files -z`.split(%Q{\x0})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'blacklight', '~> 6.3'
  spec.add_dependency 'leaflet-rails', '~> 0.7.3'
  spec.add_dependency 'font-awesome-rails', '~> 4.1.0.0'
  spec.add_dependency 'rails_config', '~> 0.4.2'
  spec.add_dependency 'faraday'
  spec.add_dependency 'coderay'
  spec.add_dependency 'geoblacklight-icons', '>= 0.2'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 11.0.1'
  spec.add_development_dependency 'rspec-rails', '~> 3.4.2'
  spec.add_development_dependency 'jettywrapper', '>= 2.0'
  spec.add_development_dependency 'engine_cart', '~> 0.10'
  spec.add_development_dependency 'capybara', '~> 2.3.0'
  spec.add_development_dependency 'poltergeist', '~> 1.5'
  spec.add_development_dependency 'factory_girl_rails'
  spec.add_development_dependency 'database_cleaner'
end
