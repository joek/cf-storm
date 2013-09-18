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
