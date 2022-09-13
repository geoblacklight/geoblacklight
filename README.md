# GeoBlacklight

![CI](https://github.com/geoblacklight/geoblacklight/actions/workflows/ruby.yml/badge.svg) | [![Coverage Status](https://img.shields.io/badge/coverage-100%25-brightgreen)]() | [![Gem Version](https://img.shields.io/gem/v/geoblacklight.svg)](https://github.com/geoblacklight/geoblacklight/releases)

GeoBlacklight is a world-class discovery platform for geospatial (GIS) holdings. It
is an open collaborative project aiming to build off of the successes
of the Blacklight Solr-powered discovery interface and the
multi-institutional [OpenGeoportal](http://opengeoportal.io/) and [OpenGeoMetadata](https://github.com/opengeometadata) federated metadata sharing
communities. We're actively looking for community input and development partners.

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

Interested in contributing to GeoBlacklight? Please see our [contributing](CONTRIBUTING.md) guide.

### Development

See the [Getting Started for Developers guide](https://geoblacklight.org/guides.html#getting-started-for-developers) for more information about setting up your development environment.

For more information, see our [GeoBlacklight Guides](https://geoblacklight.org/guides.html).
