$(document).on('turbolinks:load', function() {
  $(".upload-button").on("click", function() {
      $("input[type=file]").click();
  });

  $('#avatar-file').change(function() {
    var fr = new FileReader();
    fr.onload = function() {
      var img = $('<img>').attr('src', fr.result);
      $('#avatar-preview').append(img);
    };
    fr.readAsDataURL(this.files[0]);
  });
});