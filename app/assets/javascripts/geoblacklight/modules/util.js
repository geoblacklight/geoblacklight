/*global GeoBlacklight */

GeoBlacklight.Util = {
  // Regex taken from http://stackoverflow.com/questions/37684/how-to-replace-plain-urls-with-links
  linkify: function(str) {
    var urlRegEx = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-]*)?\??(?:[\-\+=&;%@\.\w]*)#?(?:[\.\!\/\\\w]*))?)/g;
    return str.toString().replace(urlRegEx, '<a href=\'$1\'>$1</a>');
  },
  /**
   * Calls the index map download template
   * @param {Object} data - GeoJSON feature properties object
   * @param {requestCallback} cb
   */
  indexMapDownloadTemplate: function(data, cb) {
    cb(HandlebarsTemplates["index_map_download"](data));
  },
  /**
   * Calls the index map template
   * @param {Object} data - GeoJSON feature properties object
   * @param {requestCallback} cb
   */
  indexMapTemplate: function(data, cb) {
    var thumbDeferred = $.Deferred();
    $.when(thumbDeferred).done(function() {
      cb(HandlebarsTemplates["index_map_info"](data));
    });
    if (data.iiifUrl && !data.thumbnailUrl) {
      var manifest = $.getJSON(data.iiifUrl, function(manifestResponse) {
        try {
          if (manifestResponse.thumbnail['@id'] !== null) {
            data.thumbnailUrl = manifestResponse.thumbnail['@id'];
            thumbDeferred.resolve();
          }
        }
        catch(err) {
          cb(HandlebarsTemplates["index_map_info"](data));
        }
      });
    } else {
      thumbDeferred.resolve();
    }
  }
};

// Basic support of CommonJS module
if (typeof exports === "object") {
  module.exports = GeoBlacklight.Util;
}
