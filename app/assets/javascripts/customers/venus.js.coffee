# learn more page end
$(".dental_provider").change ->
  $(".dental_Appointment input").addClass "hide"
  $(".dental_input").val ""
  $(this).parent().parent().siblings('.dental_Appointment').find('input').removeClass "hide"
  date = $(this).parent().parent().prev().find("input").attr("id")
  $("#" + date).removeClass "hide"
  return
$(".vision_provider").change ->
  $(".vision_Appointment input").addClass "hide"
  $(this).parent().parent().siblings('.vision_Appointment').find('input').removeClass "hide"
  date = $(this).parent().parent().prev().find("input").attr("id")
  $("#" + date).removeClass "hide"
  return

$('.checkDental').change ->
  $('.check_vision').addClass 'hide'
  $('.check_dental').removeClass 'hide'
  $('.checkVision input').removeAttr('checked')
  $('.vision_input,.dental_input').val('')
  $(".checkOutContinue").attr "disabled", true

$('.checkVision').change ->
  $('.check_dental').addClass 'hide'
  $('.check_vision').removeClass 'hide'
  $('.checkDental input').removeAttr('checked')
  $('.vision_input,.dental_input').val('')
  $(".checkOutContinue").attr "disabled", true

$(".dental_input").change ->
  val = $(this).val()
  time1 = val.split(" ")[1]
  time2 = val.split(" ")[2]
  time = time1+time2
  month = val.split("/")[1]
  year = val.split("/")[0]
  datefull = val.split(" ")[0]
  date = datefull.split("/")[2]
  address = $(this).parent().siblings()
  dental_p = address.find('.dental_provider').text()
  dental_add = address.find('.dental_provider_address').text()
  dental_id = $(this).attr('id').split('_')[2]
  $(".dental_time").html time
  $(".dental_date").html date
  $('.dental_month').html month
  $('.dental_year').html year
  $('.dental_input_val').val val
  $('.dental_provider_val').attr("id",dental_id).html dental_p
  $('.dental_provider_address_val').html dental_add
  $('.dental_input_val').parent().parent().removeClass('hide');
  monthName = getMonth(month)
  $('.dental_month').html monthName
  return
$(".vision_input").change ->
  val = $(this).val()
  time1 = val.split(" ")[1]
  time2 = val.split(" ")[2]
  time = time1+time2
  month = val.split("/")[1]
  year = val.split("/")[0]
  datefull = val.split(" ")[0]
  date = datefull.split("/")[2]
  address = $(this).parent().siblings()
  vision_p = address.find('.vision_provider').text()
  vision_add = address.find('.vision_provider_address').text()
  vision_id = $(this).attr('id').split('_')[2]
  $(".vision_time").html time
  $(".vision_date").html date
  $('.vision_year').html year
  $('.vision_input_val').val val
  $('.vision_provider_val').attr('id',vision_id).html vision_p
  $('.vision_provider_address_val').html vision_add
  $('.vision_input_val').parent().parent().removeClass('hide');
  monthName = getMonth(month)
  $('.vision_month').html monthName
  return
getMonth = (month) ->
  switch month
    when '01'
      month = "Jan"
    when '02'
      month = "Feb"
    when '03'
      month = "Mar"
    when '04'
      month = "Apr"
    when '05'
      month = "May"
    when '06'
      month = "Jun"
    when '07'
      month = "July"
    when '08'
      month = "Aug"
    when '09'
      month = "Sep"
    when '10'
      month = "Oct"
    when '11'
      month = "Nov"
    when '12'
      month = "Dec"
  return month
$(".body_input").change ->
  val = $(this).val()
  time1 = val.split(" ")[1]
  time2 = val.split(" ")[2]
  time = time1+time2
  month = val.split("/")[1]
  year = val.split("/")[0]
  datefull = val.split(" ")[0]
  date = datefull.split("/")[2]
  $(".body_time").html time
  $(".body_date").html date
  $('.body_year').html year
  $('.body_input_val').val val
  monthName = getMonth(month)
  $('.body_month').html monthName
  return
$(".dental_input,.body_input,.vision_input").change ->
  dental = $(".dental_input_val").val()
  vision = $(".vision_input_val").val()
  body = $(".body_input_val").val()
  parent = $(this).has '.global_dental_or_vision'
  $(".checkOutContinue").attr "disabled", false  if dental isnt "" and body isnt "" and vision isnt ""
$(".global_dental_or_vision").change ->
  $this = $(this).val()
  $(".checkOutContinue").attr "disabled", false  if $this isnt ""

$(".checkOutContinue").click (event) ->
  dental = $(".dental_input_val").val()
  vision = $(".vision_input_val").val()
  body = $(".body_input_val").val()
  dental_id = $(".dental_provider_val").attr('id')
  vision_id = $(".vision_provider_val").attr('id')
  txnid = $("#txnid").val()
  amount = $("#amount").val()
  customer_id = $("#customer_id").val()
  package_id = $("#package_id").val()
  city = $("#city").val()
  $.ajax
    type: "POST"
    url: "/customers/package_details"
    data:
      txnid: txnid
      amount: amount
      customer_id: customer_id
      package_id: package_id
      dental: dental
      vision: vision
      body: body
      dental_id: dental_id
      vision_id: vision_id
    success: (response) ->
      if amount >0
        document.forms['payment'].submit()
      else
        $.ajax
          type: "POST"
          url: "/customers/payment_success"
          data:
            txnid: txnid
            amount: amount
            customer_id: customer_id
            package_id: package_id
            dental: dental
            vision: vision
            body: body
            dental_id: dental_id
            vision_id: vision_id
            city: city
          success: (data) ->
            data = $(data).find('#content').html()
            $('#content').html data

  return

$(document).ready (e) ->
  $('#print').click (e) ->
    window.print()
    return
  return


$('.dental_provider:eq(0)').click()

$('.vision_provider:eq(0)').click()

$('#address_info_edit_btn').click ->
  $('#edit_address_form').fadeIn(500).removeClass('hide')

$('.customer-address-cancel-btn').click ->
  $('#edit_address_form').fadeOut(500).addClass('hide')

$('.upload-cancle').click ->
  $('#medical_record_medical_record,.upload-gap').val("")

$ ->

  $('#coupon_code').keypress (e) ->
    keycode = if e.keyCode then e.keyCode else e.which
    if keycode == 13
      $('#coupon_button').trigger('click')
      return false

$('#coupon_button').click ->
  coupon_code=$('#coupon_code').val()
  amount = $("#amount").val()
  service_provider = $("#service_provider").val()
  email = $("#email").val()
  firstname = $("#firstname").val()
  productinfo = $("#productinfo").val()
  txnid = $("#txnid").val()
  testpro = $("#testpro").val()
  key = $("#key").val()
  $.ajax
    type: "PATCH"
    url: "/customers/apply_coupon"
    data:
      code:coupon_code
      amount:amount
      service_provider:service_provider
      email:email
      firstname:firstname
      productinfo:productinfo
      txnid:txnid
      testpro:testpro
      key:key
    success: (response) ->
#      alert(response.net_amount)
      $("#price").html(response.net_amount1)
      $("#amount").val(response.net_amount)
      $("#hash").val(response.hash_value)
      $("#customer_coupon").val(response.coupon_code)
      $("#coupon_section").remove()
      $("#coupon_success").removeClass('hide')
      $("#city").val(response.coupon_id)
    error: ->
      $("#coupon_code").addClass('parsley-error')
      el = $('#coupon_code').parsley();
      el.manageErrorContainer();
      $(el.ulError).empty()
      el.addError({error: 'Invalid Coupon'});
