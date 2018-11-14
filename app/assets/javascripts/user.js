$(document).on('turbolinks:load', function() {
  $(".upload-button").on("click", function() {
    $("input[type=file]").click();
  });

  // TODO: ajaxで画像保存
  // $("#demo-show-toast").on("click", function() {
  //   var name = $('#edit-name').attr('value');
  //   var email = $('#edit-email').attr('value');
  //   var avatar = $('#avatar-img').attr('src');
  //   var id = $('#user-id-for-js').text();
  //   var url = '/users/' + id;
  //   $.ajax({
  //     url: url,
  //     type: 'PATCH',
  //     data: { name: name, email: email, avatar: avatar },
  //     dataType: 'json'
  //   })
  //   .done(function(data) {
  //   })
  //   .fail(function() {
  //   });
  // });

  $('#avatar-file').change(function() {
    var fr = new FileReader();
    fr.onload = function() {
      var img = $('<img>').attr('src', fr.result).addClass('avatar-img');
      $('#avatar-preview').append(img);
    };
    fr.readAsDataURL(this.files[0]);
  });

  componentHandler.upgradeAllRegistered();
});
