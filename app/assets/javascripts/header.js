$(document).on('turbolinks:load', function() {
  $('.learning-search-submit').on('click', function() {
    if ($('.learning-search-field').val().trim() == '') {
      return false;
    }
    $('.learning-search-form').submit()
  })

  $('.header-notice-number').on('click', function() {
    user_name = $('.user_name_for_js').val()
    $.ajax({
      url: '/users/' + user_name + '/activities/check',
      datatype: 'json',
      type: 'PATCH'
    }).done(function() {
      $('.header-notice-number').text('0')
    }).fail(function() {
    });
  })
});
