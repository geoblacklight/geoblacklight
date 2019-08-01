//= require geoblacklight

describe('MetadataDownloadButton', function() {
  describe('initialize', function() {
    fixture.set('<button id="foo" data-ref-endpoint="http://testdomain" data-ref-download="#bar">test element</button><a href="http://testdomain" id="bar">another test element</a>');

    it('creates a new instance and sets the download button @href value', function() {
      var button = new GeoBlacklight.MetadataDownloadButton('#foo');
      expect(button.$el.attr('id')).toBe('foo');
      expect(button.$download.attr('id')).toBe('bar');
      expect(button.$download.attr('href')).toBe('http://testdomain');
    });
  });
});
