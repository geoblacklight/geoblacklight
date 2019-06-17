# GeoBlacklight

[![CircleCI](https://circleci.com/gh/geoblacklight/geoblacklight.svg?style=svg)](https://circleci.com/gh/geoblacklight/geoblacklight) | [![Coverage Status](https://img.shields.io/coveralls/geoblacklight/geoblacklight.svg)](https://coveralls.io/r/geoblacklight/geoblacklight?branch=coveralls) | [![Gem Version](https://img.shields.io/gem/v/geoblacklight.svg)](https://github.com/geoblacklight/geoblacklight/releases)

GeoBlacklight is a world-class discovery platform for geospatial (GIS) holdings. It
is an open collaborative project aiming to build off of the successes
of the Blacklight Solr-powered discovery interface and the
multi-institutional OpenGeoportal federated metadata sharing
communities. We're actively looking for community input and development partners.

### [Installation](https://github.com/geoblacklight/geoblacklight/wiki/Installation)

Creating a new GeoBlacklight application from the template

```
$ rails new app-name -m https://raw.githubusercontent.com/geoblacklight/geoblacklight/master/template.rb
```

To launch app:

```
$ cd app-name
$ rake geoblacklight:server
```

For more information see the [installation guide](https://github.com/geoblacklight/geoblacklight/wiki/Installation)

### Webpacker
GeoBlacklight can use [Webpacker](https://github.com/rails/webpacker) in order to manage JavaScript dependencies and assets, which requires that either [Yarn](https://yarnpkg.com/) or the [Node Package Manager](https://www.npmjs.com/) be available on the system where this is deployed.  How Webpacker interacts with Rails is overviewed within its own documentation, including [how best to configure JavaScript processing settings](https://github.com/rails/webpacker/blob/master/docs/webpack.md).  We encourage you to review this.

### Contributing
Interested in contributing to GeoBlacklight? Please see our [contributing](CONTRIBUTING.md) guide.

### [Development](https://github.com/geoblacklight/geoblacklight/wiki/Development)

See the [development guide](https://github.com/geoblacklight/geoblacklight/wiki/Development) on our wiki for more information about setting up your development environment.


Please see the full documentation hosted on our Wiki [Wiki](https://github.com/geoblacklight/geoblacklight/wiki)
