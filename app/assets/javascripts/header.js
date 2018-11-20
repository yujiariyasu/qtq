$(document).on('turbolinks:load', function() {
  if ($('#header-right-dropdown').length){
    if (window.outerWidth > 1360) {
      var width = window.outerWidth - 1360  + 'px!important'
console.log(width)
      $('.header-inner-box .is-visible').css('right', width)
    }
    // if (window.outerWidth < 1336) {
    //   $('#header-right-dropdown').addClass('mdl-menu--bottom-right')
    // }
    $(window).resize(function() {
        if (window.outerWidth > 1360) {
      var width = window.outerWidth - 1360  + 'px!important'
          $('.header-inner-box .is-visible').css('right', width)
        }
        if (window.outerWidth < 1336) {
          $('.header-inner-box .is-visible').css('right', width)
        }
    });
  }
});