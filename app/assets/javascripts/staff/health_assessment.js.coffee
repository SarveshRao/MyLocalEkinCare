
bindClickOnSelfAppointment = ->
  $('.customer-address').click (event)->
    if $(event.currentTarget).is(':checked')
      $(event.currentTarget).parents('tr').find('.select-provider').attr('disabled', true)
      $(event.currentTarget).parents('td').next().find('.address').hide()
      $(event.currentTarget).parents('td').next().find('.c-address').removeClass('hide')

    else if not $(event.currentTarget).is(':checked')
      $(event.currentTarget).parents('tr').find('.select-provider').removeAttr('disabled', true)
      $(event.currentTarget).parents('td').next().find('.c-address').addClass('hide')
      $(event.currentTarget).parents('td').next().find('.address').show()
    else
      console.log 'hi'

bindEventsOnNewAppointment = ->
  bindClickOnSelfAppointment()
  $('.select-provider').change (event)->
    provider_id = $(event.currentTarget).val()
    _event= event
    $.ajax
      type: 'GET'
      url: "/provider/#{provider_id}"
      data: ''
      success: ( data, status, xhr) ->
        console.log JSON.stringify(data.provider_address)
        $(_event.currentTarget).parents('td').next().find('.address').html("#{JSON.stringify(data.provider_address)}")


bindEventsOnNewAppointment()
bindClickOnSelfAppointment()


$('.health-assessment-row').click ->
  window.location = $(@).attr('url')
  return false

$('#dental_result_tile').click ->
  $('#dental_result_panel').show()
  $('#dental_result_panel').siblings().hide()

$('#vision_result_tile').click ->
  $('#vision_result_panel').show()
  $('#vision_result_panel').siblings().hide()


$('#lab_result_tile').click ->
  $('#lab_result_panel').show()
  $('#lab_result_panel').siblings().hide()

$('#medical_records_tile').click ->
  $('#medical_records_panel').show()
  $('#medical_records_panel').siblings().hide()

$('#recommendations_tile').click ->
  $('#recommendations_panel').show()
  $('#recommendations_panel').siblings().hide()

$('#notes_tile').click ->
  $('#notes_panel').show()
  $('#notes_panel').siblings().hide()

$('.edit-appointment-pencil').click (event)->
  event.preventDefault()
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").next().next().removeClass "hide"

#binding click event to newly created edit pencil
showEditRow = (event)->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').next().removeClass('hide')

hideEditRow = (event)->
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").prev().removeClass "hide"

updateRow = (event, data)->
  event.preventDefault()
  $(event.currentTarget).parents('tr').prev().html(data)
  $(event.currentTarget).parents('tr').prev().find('.edit-appointment-pencil').bind('click', showEditRow)
  $(event.currentTarget).parents('tr').prev().find('.edit-recommendation-pencil').bind('click', showEditRow)
  $(event.currentTarget).parents('tr').prev().find('.recommendation-delete-row').bind('click', deleteRcommendation)
  $(event.currentTarget).parents('tr').prev().find('.appointment-delete-row').bind('click', deleteAppointment)


showAppendedEditRow = (event)->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').next().next().removeClass('hide')

submitAppointmentForm = (event)->
  event.preventDefault()
  form = $(event.currentTarget).parents('tr').children().first()
  url =  form.attr('action')
  _event = event
  health_assessment_id = $(event.currentTarget).parents('tr').find('.appointment-ha-select').val()
  appointment_date = $(event.currentTarget).parents('tr').find('#appointment_appointment_date').val()
  time = $(event.currentTarget).parents('tr').find('#appointment_time').val()
  description = $(event.currentTarget).parents('tr').find('#appointment_description').val()
  provider_id = $(event.currentTarget).parents('tr').find('.select-provider').val()
  customer_address = $(event.currentTarget).parents('tr').find('.customer-address').is(':checked')
  $.ajax
    type: 'PATCH'
    url: url
    data:
      customer_address: customer_address
      appointment:
        health_assessment_id: health_assessment_id
        appointment_date: appointment_date
        time: time
        description: description
        appointment_provider:
          provider_id: provider_id
    success: ( data, status, xhr) ->
      hideEditRow(_event)
      updateRow(_event, data)
      bindEventsOnNewAppointment()

#*******************recommendation submit form*******
submitRecommendationForm = (event)->
  event.preventDefault()
  form = $(event.currentTarget).parents('tr').children().first()
  url =  form.attr('action')
  _event = event
  recommendation_title = $(event.currentTarget).parents('tr').find('#recommendation_title').val()
  recommendation_description = $(event.currentTarget).parents('tr').find('#recommendation_description').val()
  $.ajax
    type: 'PATCH'
    url: url
    data:
      recommendation:
        title: recommendation_title
        description: recommendation_description
    success: ( data, status, xhr) ->
      hideEditRow(_event)
      updateRow(_event, data)

#*****deleting appointment*******
deleteAppointment = (event)->
  appointment_row = $(event.currentTarget).parents('tr')
  appointment_url = if appointment_row.next().is('form') then appointment_row.next().attr('action') else appointment_row.next().children().first().attr('action')
  appointment_edit_row = if appointment_row.next().is('form') then appointment_row.next().next() else appointment_row.next()
  appointment_form= if appointment_row.next().is('form') then appointment_row.next() else 'no_form'
  confirmed = confirm('Are you sure')
  if confirmed
    $.ajax
      type: 'DELETE'
      url: appointment_url
      success: (data, status, xhr) ->
        appointment_row.remove()
        appointment_edit_row.remove()
        if appointment_form != 'no_form' then appointment_form.remove else return


#**********deleting recommendation***********
deleteRcommendation = (event)->
  recommendation_row = $(event.currentTarget).parents('tr')
  recommendation_url = if recommendation_row.next().is('form') then recommendation_row.next().attr('action') else recommendation_row.next().children().first().attr('action')
  recommendation_edit_row = if recommendation_row.next().is('form') then recommendation_row.next().next() else recommendation_row.next()
  recommendation_form= if recommendation_row.next().is('form') then recommendation_row.next() else 'no_form'
  confirmed = confirm('Are you sure')
  if confirmed
    $.ajax
      type: 'DELETE'
      url: recommendation_url
      success: (data, status, xhr) ->
        recommendation_row.remove()
        recommendation_edit_row.remove()
        if recommendation_form != 'no_form' then recommendation_form.remove else return


# creating new appointment

$('#create_appointment').click ->
  $('#appointment_new_form').removeClass('hide')
  $("#appointment_health_assessment_id").parsley().removeError()

$('#appointments_cancel_btn').click (event)->
  $(event.currentTarget).parents('#appointment_new_form').addClass('hide')
  $("#appointment_health_assessment_id").parsley().removeError()
  el = $('#appointment_health_assessment_id').parsley();
  el.manageErrorContainer();
  $(el.ulError).empty()

$('.appointments-cancel-btn').click (event)->
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").prev().prev().removeClass "hide"
  return
#**********************************on create ajax success****************************************
$('#new_appointment').bind 'ajax:success', (event, data) ->
  event.preventDefault()
  $('#appointment_new_form').addClass('hide')
  $('#appointments_table').find('tbody').children().find('#new_appointment')
  $('#appointments_table').find('tbody').children().eq(1).after("#{data}")

    #clearing form data which posted
  $('#reset_appointments_btn').click()


$("#new_appointment").bind "ajax:error", (xhr, status,error) ->
  $("#appointment_health_assessment_id").addClass('parsley-error')
  el = $('#appointment_health_assessment_id').parsley();
  el.manageErrorContainer();
  $(el.ulError).empty()
  el.addError({error: 'Invalid Health Assessment ID'});


  #binding click events to pencil icon and cancel button and save button
#  $('.appointment-ha-select').bind('change', appointmentSelect)
  $('.edit-appointment-pencil').bind('click', showEditRow)
  $('.appointments-cancel-btn').bind('click', hideEditRow)
  $('.save-edit-form').bind('click', submitAppointmentForm)
  $('.appointment-delete-row').unbind('click')
  $('.appointment-delete-row').bind('click', deleteAppointment)
  bindEventsOnNewAppointment()
#  selectProviderAddress($($(event.currentTarget).find('.customer-address')))
  $('.datepicker').datepicker()


#*************************on edit ajax success***********************************************
$('.edit_appointment').bind 'ajax:success', (event, data)->
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().html(data)
  $(event.currentTarget).prev().find('.edit-appointment-pencil').bind('click', showAppendedEditRow)
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  $('.appointment-delete-row').unbind('click')
  $('.appointment-delete-row').bind('click', deleteAppointment)
  bindEventsOnNewAppointment()
  $('.datepicker').datepicker()

#***deleting appontment****
$('.appointment-delete-row').click ->
  deleteAppointment(event)

#*************************************Recommendations*****************************

$('#create_recommendation').click ->
  $('#recommendation_new_form').removeClass('hide')

$('#recommendations_cancel_btn').click (event)->
  $(event.currentTarget).parents('#recommendation_new_form').addClass('hide')

$('.recommendations-cancel-btn').click (event)->
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").prev().prev().removeClass "hide"
  return

$('.edit-recommendation-pencil').click (event)->
  event.preventDefault()
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").next().next().removeClass "hide"

$('#new_recommendation').bind 'ajax:success', (event, data) ->
  event.preventDefault()
  $('#recommendation_new_form').addClass('hide')
  $('#recommendations_table').find('tbody').children().find('#new_recommendation')
  $('#recommendations_table').find('tbody').children().eq(1).after("#{data}")

  #clearing form data which posted
  $('#reset_recommendations_btn').click()

  #binding click events to pencil icon and cancel button and save button
  $('.edit-recommendation-pencil').bind('click', showEditRow)
  $('.recommendations-cancel-btn').bind('click', hideEditRow)
  $('.save-edit-recommendation-form').bind('click', submitRecommendationForm)
  $('.recommendation-delete-row').unbind('click')
  $('.recommendation-delete-row').bind('click', deleteRcommendation)
  $(".datepicker").datepicker()

$('.edit_recommendation').bind 'ajax:success', (event, data)->
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().html(data)
  $(event.currentTarget).prev().find('.edit-recommendation-pencil').bind('click', showAppendedEditRow)
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  $('.recommendation-delete-row').unbind('click')
  $('.recommendation-delete-row').bind('click', deleteRcommendation)

$('.recommendation-delete-row').click ->
  deleteRcommendation(event)
