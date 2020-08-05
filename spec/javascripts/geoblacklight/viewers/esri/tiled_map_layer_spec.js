//= require geoblacklight

describe('setupInspection', function() {
  describe('Inspect attribute on the map', function() {
    it('identifyFeatures is defined', function() {
      expect(L.esri.identifyFeatures).toBeDefined();
    });
    it('Tasks is not defined', function() {
      expect(L.esri.Tasks).toBeUndefined();
    });
  });
});
