# Geoblacklight

GeoBlacklight started at Stanford and its goal is to provide a
world-class discovery platform for geospatial (GIS) holdings. It
is an open collaborative project aiming to build off of the successes
of the Blacklight Solr-powered discovery interface and the
multi-institutional OpenGeoportal federated metadata sharing
communities. We are currently in a collaborative design phase and
we're actively looking for community input and development partners.
More coming soon!

## Features

* Text search with scoring formula
* Facet by institution, year, publisher, data type, access, format
* Facet by place, subject
* Sort by relevance, year, publisher, title
* Results list view icons and snippets
* Detail map view for WMS features
* Detail map view feature inspection
* Slugs
* MODS display
* Results list map view of bounding boxes
* WMS/WFS/WCS links
* Download Shapefile
* Download KML
* Download Metadata (for Stanford)
* Built-in sample Solr 4.7 index

## Features to port from alpha

* Blacklight bookmarks and history
* Facet pagination (more>> link)
* Login for persistent bookmarks and history

## TODO

* Refactoring to `lib/`
* Test suites
* Spatial search
* Spatial relevancy
* Download GeoTIFF
* Clip to map view for download(?)
* Download Metadata (for non-Stanford)
* Facet by language, projection, collection (dummy data)
* Citation and share buttons
* Featured datasets and articles
* Sitemap export
* geoblacklight-schema
    * FGDC-based conversion of external OGP records
    * MODS-based conversion for Stanford records

## Development

To install a development instance of Geoblacklight follow these instructions.

Clone the repository (using `--recurse`)

    git clone --recurse git@github.com:sul-dlss/geoblacklight.git

Download and configure `jetty`

    rake jetty:download jetty:unzip
    rake geoblacklight:configure_jetty

Create a test app (created at `/spec/internal`)

    rake engine_cart:generate
    
Boot `jetty`

    rake jetty:start
    
Boot GeoBlacklight test app

    cd spec/internal
    rake geoblacklight:solr:seed # to load sample documents into jetty Solr instance
    rails server
    
Note that if you're using Rails with Spring enabled, we've found the the `rails generate` commands
will stall. The workaround is to kill the spring daemon process.

## Installation

Add this line to your application's `Gemfile`:

    gem 'geoblacklight'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install geoblacklight

## Usage

For a non-development instance:

1. Populate a Solr 4.7 index with geoblacklight-schema documents
2. Configure your GeoBlacklight application's `config/solr.yml` to point to the Solr index
3. `rails s` to run GeoBlacklight

## Contributing

1. Fork it ( http://github.com/my-github-username/geoblacklight/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
