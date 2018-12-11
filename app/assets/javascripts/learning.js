$(document).on('turbolinks:load', function() {
  $("#review-slider").on("change", function() {
    $('#review-level').text($(this).val() + '%')
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
            document.getElementById('edit-learning-images-preview').insertBefore(img, null);
          }
        })(f);
      }
    };
  };
  function initializeFiles() {
    document.getElementById('edit-learning-images-preview').innerHTML = '';
  }
});
