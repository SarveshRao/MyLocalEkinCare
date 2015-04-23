#= require jquery
#= require jquery_ujs
#= require respond
#= require_tree ./kanzi
#= require analytics
#= require owl.carousel

$ ->
  $("#owl-demo").owlCarousel
    autoPlay : 3000
    items: 5
    lazyLoad: true
