$(document).on('turbolinks:load', function() {
  $("#review-slider").on("change", function() {
    $('#review-level').text($(this).val() + '%')
  });
});
