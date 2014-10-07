Blacklight.onLoad(function() {
  var downloads = [];
  $('[data-download-path]').each(function(i, element) {
    downloads.push(new GeoBlacklight.Download(element));
  });
});

GeoBlacklight.Download = function(element) {
  var _this = this;
  _this.element = $(element);
  _this.url = _this.element.data('download-path');
  _this.buttonGroup = _this.element.closest('.btn-group');
  _this.spinner = $('<i class="fa fa-spinner fa-spin fa-2x fa-align-center"></i>');
  _this.buttonGroup.append(_this.spinner.hide());
  _this.setupClickListener();
};

GeoBlacklight.Download.prototype = {
  setupClickListener: function() {
    var _this = this;
    _this.element.on('click', function(e) {
      e.preventDefault();
      _this.requestDownload();
    });
  },
  requestDownload: function() {
    var _this = this;
    _this.spinner.show();
    $.ajax({
      url: _this.url,
      dataType: 'json'
    }).done(function(data) {
      _this.renderFlashMessage(data);
      _this.spinner.hide();
    }).fail(function(data, e) {
      _this.spinner.hide();
    });
  },
  renderFlashMessage: function(response) {
    $.each(response, function(i, val) {
      var flashHtml = '<div class="alert alert-' + val[0] + '"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>' + val[1] + '</div>';
      $('div.flash_messages').append(flashHtml);
    });
  }
};
