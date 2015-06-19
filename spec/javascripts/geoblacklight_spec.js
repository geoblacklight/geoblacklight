//= require geoblacklight

describe('GeoBlacklight', function() {
  describe('loads and makes available libraries', function() {
    it('Leaflet is defined', function() {
      expect(L).toBeDefined();
    });

    it('History.js is defined', function() {
      expect(History).toBeDefined();
    });
  });
});
