Blacklight.onLoad(function(){
  $('.document').each(function(index, value){
    value = $(value);
    value.find('[data-layer-id]').on('click', function(){
      value.find('.collapse').toggle();
    });
  });
});