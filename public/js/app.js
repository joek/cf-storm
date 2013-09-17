$(function() {
  $('.btn').click(function() {
    this.value = 'Sending...';
    $('.btn').attr('disabled', true);
  });
});
