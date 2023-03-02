# GeoBlacklight

![CI](https://github.com/geoblacklight/geoblacklight/actions/workflows/ruby.yml/badge.svg) | [![Coverage Status](https://img.shields.io/badge/coverage-100%25-brightgreen)]() | [![Gem Version](https://img.shields.io/gem/v/geoblacklight.svg)](https://github.com/geoblacklight/geoblacklight/releases) | [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5851664.svg)](https://zenodo.org/record/5851664#.YyIculLMK2A)

GeoBlacklight is a world-class discovery platform for geospatial (GIS) holdings. It
is an open collaborative project aiming to build off of the successes
of the Blacklight Solr-powered discovery interface and the
multi-institutional [OpenGeoportal](http://opengeoportal.io/) and [OpenGeoMetadata](https://github.com/opengeometadata) federated metadata sharing
communities. We're actively looking for community input and development partners.

### Dependencies

We recommend using:
* [Ruby](https://www.ruby-lang.org/) 3+
* [Ruby on Rails](https://rubyonrails.org/) 7+

It is possible to run GeoBlacklight with Ruby 2.7 and Rails 6, but both are approaching EoL, so we highly encourage new adopters to use Ruby 3 and Rails 7.

### Installation

  Bootstrap a new GeoBlacklight Ruby on Rails application using the template script:

```bash
DISABLE_SPRING=1 rails new app-name -m https://raw.githubusercontent.com/geoblacklight/geoblacklight/main/template.rb
```
  Then run the `geoblacklight:server` rake task to run the application:

```bash
$ cd app-name
$ bundle exec rake geoblacklight:server
```

* Visit your GeoBlacklight application at: [http://localhost:3000](http://localhost:3000)
* Visit the Solr admin panel at: [http://localhost:8983/solr/#/blacklight-core](http://localhost:8983/solr/#/blacklight-core)

#### Index Example Data

Index the GeoBlacklight project's test fixtures via:

```bash
$ bundle exec rake "geoblacklight:index:seed[:remote]"
```

### Contributing

Interested in contributing to GeoBlacklight? Please see our [contributing](https://geoblacklight.org/docs/overview/contributing/) guide.

### Development

See the [Getting Started for Developers guide](https://geoblacklight.org/docs/installation/getting_started_developers/) for more information about setting up your development environment.

For more information, please see the [GeoBlacklight Documentation](https://geoblacklight.org/docs/) site.
