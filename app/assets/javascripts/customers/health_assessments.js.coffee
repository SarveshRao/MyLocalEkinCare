$('#body_assessment_link, #dental_assessment_link, #vision_assessment_link').click ->
  window.location = $(@).attr('href')

$('.accordion-toggle').click (event) ->
  history_icon = $(event.currentTarget).find('i')
  details_ele = $(event.currentTarget).parents('tr').next()
  details_ele.toggleClass('hide')
  $(history_icon).toggleClass('fa-toggle-down fa-toggle-up')

drawChart = (id,dates,values,test_component_name) ->
  $(id).length and $.plot($(id), [ { data: values } ],
    series:
      lines:
        show: true
        lineWidth: 1
#        fill: true
#        fillColor: colors: [
#          { opacity: 0.3 }
#          { opacity: 0.3 }
#        ]
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
      borderWidth:
        top: 0,
        right: 0,
        bottom: 2,
        left: 2
      borderColor: '#777',
      color: '#f0f0f0'
    colors: [ '#1bb399' ]
    xaxis:
      mode: "time",
      color: "#000",
      timeformat: "%b %d"
#      timeformat: "%y/%m/%d"
#      tickSize: [4, 'hour']
#      labels: dates
      ticks: 3
      axisLabelPadding: 10
    yaxis:
      color: "#000",
      ticks: 2
    tooltip: true
    tooltipOpts:
      content: (label, xval, yval, flotItem) ->
#        yval=(yval).toFixed()
        xval=moment(xval).format('MMMM Do YYYY')
        yval = yval.toFixed(2)
        test_component_name+' <b>' + yval + '</b> <br> <span>' + xval + '</span>'
      defaultTheme: false
      shifts:
        x: 0
        y: 20)

win_hgt = $(window).height()
body_hgt = win_hgt - 110
$('#reportList').height body_hgt

#st = $('.assessment_list .scrollable.hover.w-f ul').scrollTop()
#$('.assessment_list .scrollable.hover.w-f ul').scrollTop st + $('.current_assessment').position().top

$('.showAssessmentFiles').click ->
  $('.physicalReports').toggleClass 'hide'
  $('#dentalWrapper').css 'margin-top', $('#dentalHeader').height() + 50
  return


arrangeValues = (id,result,test_component_name) ->
  count=0
  dates=[]
  values=[]
  count=0
  for date,val of result
    date1=new Date(date);
    dates.push(date1)
    values.push([date1,val])
    count+=1
#  console.log(dates)
#  console.log(values)

  dates1=[[0,'mar 10'],[1,'mar 11']]
  values1=[[0,8],[1,4]]
  drawChart(id,dates,values,test_component_name)

$ ->
  $('.moreInfo').click ->
    div_id=this.id
    info_sec_id='#info_sec'+this.id
    $(info_sec_id).toggleClass 'hide'
    test_component_name=$(this).closest('tr').attr('id')
    $html = $(this).html()
    $this = $(this)
    $.ajax
      url: "/customers/customer_information/lab_result_values"
      type: "GET"
      data:
        result_id: div_id
      success: (result) ->
        values=result.values
        arrangeValues('#f-line'+div_id,values,test_component_name)
        return
      error: ->
#    $(this).next('.info_sec').removeClass('hide').slideDown()

