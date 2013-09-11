$(function() {
  $('.app-submit').click(function() {
    $('.app-submit').attr('disabled', true);
    this.value = 'Sending...';
  });
});
