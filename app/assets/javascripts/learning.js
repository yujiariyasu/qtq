$(document).on('turbolinks:load', function() {
  $("#review-slider").on("change", function() {
    $('#review-level').text($(this).val() + '%')
  });

  $("#learning-slider").on("change", function() {
    $('#study-time').text($(this).val() + '%')
  });

  $("#edit-learning-slider").on("change", function() {
    $('#edit-study-time').text($(this).val() + '%')
  });

  $(".learning-image-button").on("click", function() {
    $("#learning-image-files").click();
  });

  $(".edit-learning-image-button").on("click", function() {
    $("#edit-learning-image-files").click();
  });
  if(document.getElementById("learning-image-files") != null) {
    document.getElementById('learning-image-files').onchange = function(event){
      initializeFiles();

      var files = event.target.files;

      for (var i = 0, f; f = files[i]; i++) {
        var reader = new FileReader;
        reader.readAsDataURL(f);

        reader.onload = (function(theFile) {
          return function (e) {
            var img = document.createElement('img');
            img.className = 'learning-image';
            img.src = e.target.result;
            document.getElementById('learning-images-preview').insertBefore(img, null);
            $('.learning-trash-image').show()
          }
        })(f);
      }
    };
  };

  function initializeFiles() {
    document.getElementById('learning-images-preview').innerHTML = '';
  }
  if(document.getElementById("edit-learning-image-files") != null) {
    document.getElementById('edit-learning-image-files').onchange = function(event){
      initializeEditFiles();

      var files = event.target.files;

      for (var i = 0, f; f = files[i]; i++) {
        var reader = new FileReader;
        reader.readAsDataURL(f);

        reader.onload = (function(theFile) {
          return function (e) {
            var img = document.createElement('img');
            img.className = 'learning-image';
            img.src = e.target.result;
            document.getElementById('edit-learning-images-preview').insertBefore(img, null);
            $('.edit-learning-trash-image').show()
            $('#image_delete_flag').val(false)
          }
        })(f);
      }
    };
  };
  function initializeFiles() {
    document.getElementById('learning-images-preview').innerHTML = '';
  }
  function initializeEditFiles() {
    document.getElementById('edit-learning-images-preview').innerHTML = '';
  }

  $('.post-comment-submit').on('click', function() {
    if ($('.post-comment-body').val().trim() == '') {
      return false;
    }
  })

  $('.edit-comment-submit').on('click', function() {
    if ($('.edit-comment-body').val().trim() == '') {
      return false;
    }
  })

  $('.post-learning-submit').on('click', function() {
    if ($('.learning-title-for-js').val().trim() == '') {
      return false;
    }
  })

  $('.learning-modal-text-area').on('input', function() {
    height = parseInt($(this).css('lineHeight'));
    lines = ($(this).val() + '\n').match(/\n/g).length;
    if(lines < 8) {
      lines = 8
    }
    $(this).height(height * lines);
  });

  $('.post-comment-body').on('input', function() {
    height = parseInt($(this).css('lineHeight'));
    lines = ($(this).val() + '\n').match(/\n/g).length;
    $(this).height(height * lines);
  });

  $('.post-comment-body').on('keydown', function(e) {
    if(e.keyCode == 13 && e.metaKey) {
      $('.new_comment').submit()
    }
  });

  $('.edit-comment-body').on('keydown', function(e) {
    if(e.keyCode == 13 && e.metaKey) {
      $('.edit_comment').submit()
    }
  });

  if($('.edit-learning-modal-text-area').length) {
    area = $('.edit-learning-modal-text-area')
    height = parseInt(area.css('lineHeight'));
    lines = (area.val() + '\n').match(/\n/g).length;
    if(lines < 8) {
      lines = 8
    }
    area.height(height * lines);

    if($('.edit-learning-image').length) {
      $('.edit-learning-trash-image').show()
    }
  }

  $('.learning-trash-image').on('click', function() {
    $('#learning-image-files').val('')
    $('#learning-images-preview').html('')
    $('.learning-trash-image').hide()
  })

  $('.edit-learning-trash-image').on('click', function() {
    $('#edit-learning-image-files').val('')
    $('#edit-learning-images-preview').html('')
    $('.edit-learning-trash-image').hide()
    $('#image_delete_flag').val('true')
  })

  $('.create-learning-modal-text-area').on('keydown', function(e) {
    if(e.keyCode == 73 && e.metaKey) {
      $(this).val($(this).val() + "\n\n```ruby\n\n```")
      height = parseInt($(this).css('lineHeight'));
      lines = ($(this).val() + '\n').match(/\n/g).length;
      if(lines < 8) {
        lines = 8
      }
      $(this).height(height * lines);
    }
    if(e.keyCode == 13 && e.metaKey) {
      $('#new_learning').submit()
    }
  });

  $('.edit-learning-modal-text-area').on('keydown', function(e) {
    if(e.keyCode == 73 && e.metaKey) {
      $(this).val($(this).val() + "\n\n```ruby\n\n```")
      height = parseInt($(this).css('lineHeight'));
      lines = ($(this).val() + '\n').match(/\n/g).length;
      if(lines < 8) {
        lines = 8
      }
      $(this).height(height * lines);
    }
    if(e.keyCode == 13 && e.metaKey) {
      $('.edit_learning').submit()
    }
  });

  $('.learning-title-for-js').on('keydown', function(e) {
    if(e.keyCode == 13 && e.metaKey) {
      $('.new_learning').submit()
    }
  });

  $('.edit-learning-title-field').on('keydown', function(e) {
    if(e.keyCode == 13 && e.metaKey) {
      $('.edit_learning').submit()
    }
  });
});
