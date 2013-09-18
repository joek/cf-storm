$(function() {
  $('.btn').click(function() {
    if(!$(this).attr('href')){
        $('.btn').attr('disabled', true);
    };
  });
});

$(function() {
  $('.trigger-unmap-confirmation').click(function() {
    $('.unmap-confirmed').toggle();
  });
});


$(function() {
  $('#health-monitor').knob({
      'max': 100,
      'min': 0,
      'readOnly': true,
      'fgColor': '#33ff44',
      'bgColor': '#DDDDDD'
  });
});
