$(document).on('turbolinks:load', function() {
  $('.learning-search-submit').on('click', function() {
    if ($('.learning-search-field').val().trim() == '') {
      return false;
    }
    $('.learning-search-form').submit()
  })
});
