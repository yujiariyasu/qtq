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
            ele = $('.create-learning-modal-text-area')
            id = $('#s3_learning_id').val()
            createImageTag(theFile.name, ele, id)
          }
        })(f);
      }
    };
  };

  function createImageTag(fileName, ele, id) {
    text = ele.val()
    console.log(fileName)
    fileName = fileName.replace('(', '_')
    fileName = fileName.replace(')', '_')
    fileName = fileName.replace(' ', '_')
    fileName.replace(/\s+/g, "")
    ele.val(text + "\n![" + fileName + '](https://quantity-teaches-quality.s3-ap-northeast-1.amazonaws.com/uploads/learning/images/' + id + '/' + fileName + ")\n")
  }

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
            id = $('#edit_s3_learning_id').val()
            ele = $('.edit-learning-modal-text-area')
            createImageTag(theFile.name, ele, id)
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
    if(lines < 12) {
      lines = 12
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
    if(lines < 12) {
      lines = 12
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

  function enter_tab(e) {
    if (e.keyCode === 9) {
      if (e.preventDefault) {
        e.preventDefault();
      }
      elem = e.target;
      start = elem.selectionStart;
      end = elem.selectionEnd;
      value = elem.value;
      elem.value = "" + (value.substring(0, start)) + "\t" + (value.substring(end));
      elem.selectionStart = elem.selectionEnd = start + 1;
      return false;
    }
  }

  function enter_back_quotations(e, ele) {
    if(e.keyCode == 73 && e.metaKey) {
      text = ele.val()
      if (text != '') {
        text += "\n\n"
      }
      ele.val(text + "```\n\n```")
      height = parseInt(ele.css('lineHeight'));
      lines = (ele.val() + '\n').match(/\n/g).length;
      if(lines < 12) {
        lines = 12
      }
      ele.height(height * lines);
    }
  }

  function active_command_enter(e, selector) {
    if(e.keyCode == 13 && e.metaKey) {
      $(selector).submit()
    }
  }

  function learning_description_enter(e, selector, ele) {
    enter_tab(e)
    enter_back_quotations(e, ele)
    active_command_enter(e, selector)
  }

  $('.create-learning-modal-text-area').on('keydown', function(e) {
    learning_description_enter(e, '#new_learning', $(this))
  });

  $('.edit-learning-modal-text-area').on('keydown', function(e) {
    learning_description_enter(e, '.edit_learning', $(this))
  });

  $('.learning-title-for-js').on('keydown', function(e) {
    active_command_enter(e, '.new_learning')
  });

  $('.edit-learning-title-field').on('keydown', function(e) {
    active_command_enter(e, '.edit_learning')
  });
});
