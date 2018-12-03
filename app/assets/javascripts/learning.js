$(document).on('turbolinks:load', function() {
  $("#review-slider").on("change", function() {
    $('#understanding-level').text($(this).value() + '%')
  });
});
