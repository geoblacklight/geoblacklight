# GeoBlacklight

[![CircleCI](https://circleci.com/gh/geoblacklight/geoblacklight.svg?style=svg)](https://circleci.com/gh/geoblacklight/geoblacklight) | [![Coverage Status](https://raw.githubusercontent.com/geoblacklight/geoblacklight/coverage-badge/coverage.svg)]() | [![Gem Version](https://img.shields.io/gem/v/geoblacklight.svg)](https://github.com/geoblacklight/geoblacklight/releases)

GeoBlacklight is a world-class discovery platform for geospatial (GIS) holdings. It
is an open collaborative project aiming to build off of the successes
of the Blacklight Solr-powered discovery interface and the
multi-institutional [OpenGeoportal](http://opengeoportal.io/) and [OpenGeoMetadata](https://github.com/opengeometadata) federated metadata sharing
communities. We're actively looking for community input and development partners.

### [Installation](https://github.com/geoblacklight/geoblacklight/wiki/Installation)

In order to create a new GeoBlacklight application from the template, run the following:

```
$ DISABLE_SPRING=1 rails new app-name -m https://raw.githubusercontent.com/geoblacklight/geoblacklight/main/template.rb
```

To launch app:

```
$ cd app-name
$ rake geoblacklight:server
```

Note that this method launches an application that does not have any fixture records to be examined. You may want to launch a test application that has fixture data loaded into a Solr core. If so, refer to the [development guide](https://github.com/geoblacklight/geoblacklight/wiki/Development). For further information on installing a blank app, see the [installation guide](https://github.com/geoblacklight/geoblacklight/wiki/Installation)

### Contributing
Interested in contributing to GeoBlacklight? Please see our [contributing](CONTRIBUTING.md) guide.

### [Development](https://github.com/geoblacklight/geoblacklight/wiki/Development)

See the [development guide](https://github.com/geoblacklight/geoblacklight/wiki/Development) on our wiki for more information about setting up your development environment.


Please see the full documentation hosted on our [Wiki](https://github.com/geoblacklight/geoblacklight/wiki)
