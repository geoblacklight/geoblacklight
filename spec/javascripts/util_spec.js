//= require geoblacklight

'use strict';

describe('GeoBlacklight.Util', function() {
  describe('linkify', function() {
    it('returns a linkified string', function() {
      expect(GeoBlacklight.Util.linkify('http://www.example.com'))
        .toEqual("<a href='http://www.example.com'>http://www.example.com</a>");
    });
  });
});
