$('#body_assessment_link, #dental_assessment_link, #vision_assessment_link').click ->
  window.location = $(@).attr('href')

$('.accordion-toggle').click (event) ->
  history_icon = $(event.currentTarget).find('i')
  details_ele = $(event.currentTarget).parents('tr').next()
  details_ele.toggleClass('hide')
  $(history_icon).toggleClass('fa-toggle-down fa-toggle-up')

drawChart = (id,values) ->
  console.log(values)
  dk=[]
  values=values.split(',')
  for key of values
    dk.push [
      key
      values[key]
    ]

  console.log(dk)

  $.plot($(id), [ { data: dk } ],
    series:
      lines:
        show: true
        lineWidth: 1
        fill: true
        fillColor: colors: [
          { opacity: 0.3 }
          { opacity: 0.3 }
        ]
      points:
        radius: 3
        show: true
      grow:
        active: true
        steps: 50
      shadowSize: 2
    grid:
      hoverable: true
      clickable: true
      tickColor: '#f0f0f0'
      borderWidth: 1
      color: '#f0f0f0'
    colors: [ '#1bb399' ]
    tooltip: true
    tooltipOpts:
      content: '%y.4'
      defaultTheme: false
      shifts:
        x: 0
        y: 20)

win_hgt = $(window).height()
body_hgt = win_hgt - 110
$('#reportList').height body_hgt

st = $('.assessment_list .scrollable.hover.w-f ul').scrollTop()
$('.assessment_list .scrollable.hover.w-f ul').scrollTop st + $('.current_assessment').position().top

$('.showAssessmentFiles').click ->
  $('.physicalReports').toggleClass 'hide'
  return
#$ ->
#  $('.moreInfo').click ->
##    $(this).closest('tr').siblings('tr').find('.info_sec').slideToggle()
#    test_component_name=$(this).closest('tr').attr('id')
#    $html = $(this).html()
#    $this = $(this)
#    $.ajax
#      url: "/customers/customer_information/lab_result_values"
#      type: "GET"
#      data:
#        test_component_name: test_component_name
#      success: (result) ->
#        values=result.values
#        id=test_component_name.replace(/[ ()!\/@%&"]/g, "").toString()
#        drawChart('#f-line'+id,values)
##        $this.removeClass()
#        $this.next('.info_sec').slideToggle()
#        return
#      error: ->
##    $(this).next('.info_sec').removeClass('hide').slideDown()
#
