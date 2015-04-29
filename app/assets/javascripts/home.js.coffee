#= require jquery
#= require jquery_ujs
#= require respond
#= require analytics
#= require owl.carousel
#= require beetle
#= require jquery-ui.min
#= require jquery.color
#= require jquery.youtubepopup.js
#= require owl.carousel.min
#= require plugins

$ ->

  $("#text-me").click ->
    $.ajax
      url: "/home/send_sms"
      type: "POST"
      data:
        mobile_number:$("#mobile_number").val()

      success: (result) ->
        $('#success').removeClass('hidden')


  $("#owl-demo").owlCarousel
    autoPlay : 3000
    items: 5
    lazyLoad: true


$(document).ready ->
  introHeight = $(window).height() - 84
  $('#intro-wrap').height introHeight
  fullHeight = introHeight + 30 - 100
  if $(window).width >= 800
    $('.section').css 'min-height', fullHeight + 'px'
  $('.section.not-full').css 'min-height', 0 + 'px'
  $('a.youtube').YouTubePopup autoplay: 0
  $('.testimonial').addClass 'hidden'
  $('.testimonial').eq(0).removeClass 'hidden'
  $('.userreview').click ->
    n = $('.userreview').index($(this))
    $('.testimonial').addClass 'hidden'
    $('.testimonial').eq(n).css opacity: 0
    $('.testimonial').eq(n).removeClass 'hidden'
    $('.testimonial').eq(n).animate { opacity: 1 }, 1000
    $('.dscreen').addClass 'hidden'
    $('.dscreen').eq(n).css opacity: 0
    $('.dscreen').eq(n).removeClass 'hidden'
    $('.dscreen').eq(n).animate { opacity: 1 }, 1000
    return
  return




