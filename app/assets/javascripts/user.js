$(document).on('page:change', function() {
  $(".upload-button").on("click", function() {
    if ($('.avatar-img').length) {
      $('.avatar-img').remove();
    } else {
      $("input[type=file]").click();
    }
  });

  $('#avatar-file').change(function() {
    var fr = new FileReader();
    console.log(fr.result)
    fr.onload = function() {
      var img = $('<img>').attr('src', fr.result).addClass('avatar-img');
      $('#avatar-preview').append(img);
    };
    fr.readAsDataURL(this.files[0]);
  });

  if($('.signup-box').length) {
    componentHandler.upgradeDom();
    console.log(33)
  }
});