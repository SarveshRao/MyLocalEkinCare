$ ->
  $('.datepicker').datepicker
    changeMonth: true
    changeYear: true
    yearRange: '1900:2050'
    dateFormat: 'dd-mm-yy'

  $('.datepicker_1').datetimepicker({
    format:'d-m-Y',
    timepicker:false,
    formatTime: 'g:i a',
    maxDate: new Date(),
    yearStart: "1900"
    yearEnd: "2200",
    closeOnDateSelect: true
  })

  d = new Date
  $('.datetimepicker1').datetimepicker({
    minDate: new Date(d.setDate(d.getDate() + 2)),
    format:'Y/m/d g:i a',
    formatTime: 'g:i a',
    closeOnDateSelect: true
    })
  d = new Date
  $('.datetimepicker2').datetimepicker({
    minDate: new Date(d.setDate(d.getDate() + 2)),
    format:'Y/m/d g:i a',
    formatTime: 'g:i a',
    closeOnDateSelect: true
  })
  d = new Date
  $('.datetimepicker3').datetimepicker({
    minDate: new Date(d.setDate(d.getDate() + 2)),
    format:'Y/m/d g:i a',
    formatTime: 'g:i a',
    closeOnDateSelect: true
  })

  $('.xdsoft_timepicker').css 'width', '60px'