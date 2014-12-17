# Geoblacklight

[![Build Status](https://travis-ci.org/geoblacklight/geoblacklight.svg?branch=master)](https://travis-ci.org/geoblacklight/geoblacklight) | [![Coverage Status](https://img.shields.io/coveralls/geoblacklight/geoblacklight.svg)](https://coveralls.io/r/geoblacklight/geoblacklight?branch=coveralls)

GeoBlacklight is a world-class discovery platform for geospatial (GIS) holdings. It
is an open collaborative project aiming to build off of the successes
of the Blacklight Solr-powered discovery interface and the
multi-institutional OpenGeoportal federated metadata sharing
communities. We're actively looking for community input and development partners.

###[Installation](https://github.com/geoblacklight/geoblacklight/wiki/Installation)

Creating a new GeoBlacklight application from the template

```
$ rails new app-name -m https://raw.githubusercontent.com/geoblacklight/geoblacklight/master/template.rb
```

To install Solr (with Jetty)

```
$ cd app-name
$ rake jetty:download
$ rake jetty:unzip
$ rake geoblacklight:configure_jetty
```

Or install with [Docker](https://github.com/geoblacklight/geoblacklight-docker)
For more information see the [installation guide](https://github.com/geoblacklight/geoblacklight/wiki/Installation)

###[Contributing](https://github.com/geoblacklight/geoblacklight/wiki/Contributing)

1. Fork it ( http://github.com/my-github-username/geoblacklight/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Also, if you wish to ask questions or participate further, email the [GeoBlacklight Working Group](https://groups.google.com/forum/#!forum/geoblacklight-working-group) at [geoblacklight-working-group@googlegroups.com](mailto:geoblacklight-working-group@googlegroups.com).

###[Development](https://github.com/geoblacklight/geoblacklight/wiki/Development)

See the [development guide](https://github.com/geoblacklight/geoblacklight/wiki/Development) on our wiki for more information about setting up your development environment.


Please see the full documentation hosted on our Wiki [Wiki](https://github.com/geoblacklight/geoblacklight/wiki)
