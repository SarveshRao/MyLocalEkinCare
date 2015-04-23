$ ->
  $('.datepicker').datepicker
    changeMonth: true
    changeYear: true
    yearRange: '1900:2050'
    dateFormat: 'dd-mm-yy'

  $('.datepicker_1').datetimepicker({
    format:'d-m-Y',
    timepicker:false,
    formatTime: 'g:i a'
  })

  d = new Date
  $('.datetimepicker').datetimepicker({
    minDate: new Date(d.setDate(d.getDate() + 2)),
    format:'Y/m/d g:i a',
    formatTime: 'g:i a'
    })

  $('.xdsoft_timepicker').css 'width', '60px'
 