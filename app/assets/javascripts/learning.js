$(document).on('turbolinks:load', function() {
  $("#review-slider").on("change", function() {
    $('#review-level').text($(this).val() + '%')
  });

  $(".learning-upload-button").on("click", function() {
    $("input[type=file]").click();
  });

  $('#learning-image-files').change(function() {
    var fr = new FileReader();
    fr.onload = function() {
      var img = $('<img>').attr('src', fr.result).addClass('learning-image');
      $('#learning-images-preview').append(img);
    };
    fr.readAsDataURL(this.files[0]);
  });
});
