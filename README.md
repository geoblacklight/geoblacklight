# GeoBlacklight

![CI](https://github.com/geoblacklight/geoblacklight/actions/workflows/ruby.yml/badge.svg) | [![Coverage Status](https://img.shields.io/badge/coverage-100%25-brightgreen)]() | [![Gem Version](https://img.shields.io/gem/v/geoblacklight.svg)](https://github.com/geoblacklight/geoblacklight/releases)

GeoBlacklight is a world-class discovery platform for geospatial (GIS) holdings. It
is an open collaborative project aiming to build off of the successes
of the Blacklight Solr-powered discovery interface and the
multi-institutional [OpenGeoportal](http://opengeoportal.io/) and [OpenGeoMetadata](https://github.com/opengeometadata) federated metadata sharing
communities. We're actively looking for community input and development partners.

### Installation

In order to create a new GeoBlacklight application from the template, run the following:

```
$ DISABLE_SPRING=1 rails new app-name -m https://raw.githubusercontent.com/geoblacklight/geoblacklight/main/template.rb
```

To launch app:

```
$ cd app-name
$ rake geoblacklight:server
```

Note that this method launches an application that does not have any fixture records to be examined. You may want to launch a test application that has fixture data loaded into a Solr core. If so, refer to the [development guide](https://geoblacklight.org/guides.html#getting-started-for-developers). For further information on installing and configuring a blank app, see the [installation guide](https://geoblacklight.org/guides.html#geoblacklight-quick-start)

### Contributing
Interested in contributing to GeoBlacklight? Please see our [contributing](CONTRIBUTING.md) guide.

### Development

See the [Getting Started for Developers guide](https://geoblacklight.org/guides.html#getting-started-for-developers) for more information about setting up your development environment.


For more information, see our [GeoBlacklight Guides](https://geoblacklight.org/guides.html).
