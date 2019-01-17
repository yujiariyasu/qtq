$(document).on('turbolinks:load', function() {
  $(".upload-button").on("click", function() {
    $("#avatar-file").click();
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
    $('.edit-avatar-img').remove()
    $('.delete-user-image-button').remove()
    var fr = new FileReader();
    fr.onload = function() {
      var img = $('<img>').attr('src', fr.result).addClass('edit-avatar-img');
      var span = '<span class="delete-user-image-button">×</span>'
      $('#avatar-preview').append(img);
      $('#avatar-preview').append(span);
      $('#delete_avatar_flag').val('false')
    };
    fr.readAsDataURL(this.files[0]);
  });

  $(document).on("click", ".delete-user-image-button", function(){
    $('#avatar-file').val('')
    $('#avatar-preview').html('')
    $('#delete_avatar_flag').val('true')
  });

  componentHandler.upgradeAllRegistered();

  // $(".side-user-image").on({"click":function(){
  //   $(this).addClass("animated pulse");
  // },"webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend":function(){
  //   $(this).removeClass("animated pulse");
  // }});

  $(".user-main-comparison").on({"click":function(){
    $(this).addClass("animated bounce");
  },"webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend":function(){
    $(this).removeClass("animated bounce");
  }});

  $(".user-main-schedule").on({"click":function(){
    $(this).addClass("animated swing");
  },"webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend":function(){
    $(this).removeClass("animated swing");
  }});

  $('#user_goal').on('change', function() {
    $('#edit-user-goal').submit()
  });

  $('#user-edit-introduction-area').on('input', function() {
    lineHeight = parseInt($(this).css('lineHeight'));
    lines = ($(this).val() + '\n').match(/\n/g).length;
    if(lines < 3) {
      lines = 3
    }
    $(this).height(lineHeight * lines);
  });
});
