$(document).on('turbolinks:load', function() {
  $(".animate-footer-span").on({"click":function(){
    $(this).addClass("animated flip");
  },"webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend":function(){
    $(this).removeClass("animated flip");
  }});
});
