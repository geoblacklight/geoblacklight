/*global GeoBlacklight */

GeoBlacklight.Util = {
  // Regex taken from http://stackoverflow.com/questions/37684/how-to-replace-plain-urls-with-links
  linkify: function(str) {
    var urlRegEx = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-]*)?\??(?:[\-\+=&;%@\.\w]*)#?(?:[\.\!\/\\\w]*))?)/g;
    return str.toString().replace(urlRegEx, '<a href=\'$1\'>$1</a>');
  }
};
