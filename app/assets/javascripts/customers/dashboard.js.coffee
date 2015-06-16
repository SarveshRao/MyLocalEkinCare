
$ ->
  $('#score-graph').click ->
    $('#hypertension_history_chart').removeClass('hide')
  $('.easypiechart').easyPieChart {}
  $('.hypertension_chart').easyPieChart {}
  $('.diabetes_chart').easyPieChart {}

  if $("#customer_id").length>0
    $.ajax
      url: "/customers/customer_information/show"
      type: "GET"
      data:
        id: $("#customer_id").val()

      success: (result) ->
        customer_data = result
        if (customer_data.weight?)
          $("#weight_section").parent().removeClass "hide"

        if (customer_data.bmi!='-')
          $("#bmi_section").parent().removeClass "hide"

        if (customer_data.feet?) and (customer_data.inches?)
          $("#height_section").parent().removeClass "hide"

        if (customer_data.blood_group==false)
          $("#blood_group_section").parent().removeClass "hide"

        if(customer_data.blood_pressure)
          $("#blood_pressure_section").parent().removeClass "hide"

        if(customer_data.blood_sugar!='-')
          $("#blood_sugar_section").parent().removeClass "hide"

        if(customer_data.water_intake==1 &&customer_data.blood_sos==false)
          if($('#water_intake_chart').length>0)
            actual_water_intake=$('#glassFullReading').text().trim().split('ml')[0]
            water_intake_chart(consumed,actual_water_intake)
          $('#water_intake_chart').removeClass "hide"

        tiles = $(".dashboard_tiles > div:visible").length
        $(".dashboard_tiles > div:visible:eq(4)").css
          clear: "left"

      error: (xhr, status, error) ->

  if($('#is_customer').val() == "true")
    $('#weight_val').editable
      url: "/customers/customer_information/update_customer_vitals"
      title: "Weight"
      name:'weight'
      params: (params) ->
        params.customer_id = $('#customer_id').val()
        params
      success: (response, newValue) ->
        $('#bmi').html(response.bmi)
        $('#weight_date').html(response.date)
        $('#bmi_date').html(response.date)
        $("#bmi").css color:response.bmi_color
      validate: (value) ->
        "This field is required"  if $.trim(value) is ""
      emptytext: '-'

    $('#feet_val').editable
      url: "/customers/customer_information/update_customer_vitals"
      title: "Height"
      name:'feet'
      params: (params) ->
        params.customer_id = $('#customer_id').val()
        params
      success: (response, newValue) ->
        $('#bmi').html(response.bmi)
        $('#height_date').html(response.date)
        $('#bmi_date').html(response.date)
        $("#bmi").css color:response.bmi_color
      validate: (value) ->
        "This field is required"  if $.trim(value) is ""
      emptytext: '-'

    $('#inches_val').editable
      url: "/customers/customer_information/update_customer_vitals"
      title: "height"
      name:'inches'
      params: (params) ->
        params.customer_id = $('#customer_id').val()
        params
      success: (response, newValue) ->
        $('#bmi').html(response.bmi)
        $('#height_date').html(response.date)
        $('#bmi_date').html(response.date)
        $("#bmi").css color:response.bmi_color
      validate: (value) ->
        "This field is required"  if $.trim(value) is ""
      emptytext: '-'

    $('#Fasting_blood_sugar_id').editable
      url: "/customers/customer_lab_results/update_blood_sugar"
      title: "Fasting Blood sugar"
      name:'result'
      ajaxOptions:
        type: 'put'
      params: (params) ->
        params
      success: (response, newValue) ->
        $('#Fasting_blood_sugar_id').removeClass('text-danger')
        $('#Fasting_blood_sugar_id').removeClass('text-success')
        $('#Fasting_blood_sugar_id').removeClass('text-warning')
        $('#Fasting_blood_sugar_id').addClass(response.color)
        $('#blood_sugar_date').html(response.date)
      validate: (value) ->
        "This field is required"  if $.trim(value) is ""
      emptytext: '-'

    $('.editable').editable
      success: (response, newValue) ->
        parsed_data = JSON.stringify(response)
        data=JSON.parse(parsed_data)
        $('#blood_sugar_color > b').removeClass('text-danger').removeClass('text-success').removeClass('text-warning')
        $('#blood_sugar_color > b').addClass(data.color)
      validate: (value) ->
        "This field is required"  if $.trim(value) is ""
      emptytext: '-'


  $('#notifications_count').click ->
    $('#notifications_count').find('#count').remove()
    inbox_show()

  $('#general_comments').click ->
    doctor_comments_show()

  $('#appointments_count').click ->
    $('#appointments_count').find('#count').remove()
    appointments_show()
  $('#recommendations_count').click ->
    $('#recommendations_count').find('#count').remove()
    recommendations_show()

  $('#edit_profile_pic').click ->
    $('#profile_pic_input').click()

  $('#profile_pic_input').bind('change', uploadAvatar)

uploadAvatar =  ->
  $('#avatar_submit_btn').click()
  $('#avatar_loader').removeClass('hide')

$('#edit_avatar').bind 'ajax:success', (event, data) ->
  data = data.replace(/"/g, "")
  $('#customer_avatar_container').html("#{data}")
  $('#avatar_loader').addClass('hide')
  avatar_url = $('#customer_avatar_container').find('img').prop('src')

  $('#customer_avatar').attr('src',avatar_url)
  $('#avatar_reset_btn').click()
  $('#profile_pic_input').bind('change', uploadAvatar)
  $('#avatar_error_msg').html('')


$('#edit_avatar').bind 'ajax:error', (xhr, status, error) ->
  $('#avatar_error_msg').html('invalid file format')
  $('#avatar_loader').addClass('hide')
  $('#profile_pic_input').bind('change', uploadAvatar)

$('.customer-allergy-delete-row').click ->
  deleteAllergy(event)

inbox_show  = (event)->
  $.ajax
    url: '/customers/inbox'
    success: (data) ->
      $('#dashboard_notifications').html(data).slimScroll({height: '315px'}).removeClass('hide')

doctor_comments_show  = (event)->
  $.ajax
    url: '/customers/general_comments'
    success: (data) ->
      $('#general_comments_content').html(data).slimScroll({height: '315px'}).removeClass('hide')

appointments_show  = (event)->
  $.ajax
    url: '/customers/appointments'
    success: (data) ->
      $('#dashboard_appointments').html(data).slimScroll({height: '315px'}).removeClass('hide')

recommendations_show  = (event)->
  $.ajax
    url: '/customers/recommendations'
    success: (data) ->
      $('#dashboard_recommendations').html(data).slimScroll({height: '315px'}).removeClass('hide')

#-----------------------------------------loading  customer allergies---------------------------------------------------
allergySelect = ->
#  $('.customer-allergy-select').change (event) ->
#    $.ajax
#      type: 'GET'
#      url: "/customers/allergies/#{$(@).val()}"
#      success: (data, status, xhr) ->
#        $(event.currentTarget).parents('tr').find('.customer_allergy_reaction').val(data.allergy.reaction)
#
#allergySelect()
#$('#edit_customer_allergy').on('change','select', allergySelect)

#*************************Allergy functionality ***********************************8
showEditRow = (event)->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').next().removeClass('hide')

hideEditRow = (event)->
  $(event.currentTarget).parents("tr").addClass("hide")
  $(event.currentTarget).parents("tr").prev().removeClass("hide")

updateRow = (event, data)->
  event.preventDefault()
  $(event.currentTarget).parents('tr').prev().html(data)
  $(event.currentTarget).parents('tr').prev().find('.customer-allergy-edit-pencil').bind('click', showEditRow)
  $(event.currentTarget).parents('tr').prev().find('.customer-allergy-delete-row').bind('click', deleteAllergy)
  $(event.currentTarget).parents('tr').prev().find('.customer-immunization-edit-pencil').bind('click', showEditRow)
  $(event.currentTarget).parents('tr').prev().find('.customer-immunization-delete-row').bind('click', deleteImmunization)
  $(event.currentTarget).parents('tr').prev().find('.customer-medication-edit-pencil').bind('click', showEditRow)
  $(event.currentTarget).parents('tr').prev().find('.customer-medication-delete-row').bind('click', deleteMedication)
  $(event.currentTarget).parents('tr').prev().find('.customer-family-medical-history-edit-pencil').bind('click', showEditRow)
  $(event.currentTarget).parents('tr').prev().find('.customer-family-medical-history-delete-row').bind('click', deleteFmh)

showAppendedEditRow = (event)->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').next().next().removeClass('hide')

submitCustomerAllegyForm = (event)->
  event.preventDefault()
  form = $(event.currentTarget).parents('tr').children().first()
  url =  form.attr('action')
  _event = event

  name = $(event.currentTarget).parents('tr').find('#allergy_name').val()
  reaction = $(event.currentTarget).parents('tr').find('#allergy_reaction').val()
  severity = $(event.currentTarget).parents('tr').find('#allergy_customer_allergies_severity').val()

  $.ajax
    type: 'PATCH'
    url: url
    data:
      allergy:
        name: name
        reaction: reaction
        customer_allergies:
          severity: severity

    success: ( data, status, xhr) ->
      hideEditRow(_event)
      updateRow(_event, data)

#*****deleting allergy*******
deleteAllergy = (event)->
  allergy_row = $(event.currentTarget).parents('tr')
  allergy_url = if allergy_row.next().is('form') then allergy_row.next().attr('action') else allergy_row.next().children().first().attr('action')
  allergy_edit_row = if allergy_row.next().is('form') then allergy_row.next().next() else allergy_row.next()
  allergy_form= if allergy_row.next().is('form') then allergy_row.next() else 'no_form'
  confirmed = confirm('Are you sure')
  if confirmed
    $.ajax
      type: 'DELETE'
      url: allergy_url
      success: (data, status, xhr) ->
        allergy_row.remove()
        allergy_edit_row.remove()
        if $('#allergies_table').find('.allergy-row').length == 0
          $('#allergies_table').find('#allergy_table_header').addClass('hide')
          $('#allergies_table').find('#no_allergies_row').removeClass('hide').removeClass('hide')
        if allergy_form != 'no_form' then allergy_form.remove else return

$('#create_customer_allergy').click ->
  $('#allergies_table').find('#customer_allergy_new_form').removeClass('hide')
  $('#allergies_table').find('#allergy_table_header').removeClass('hide')

$('#customer_allergy_cancel_btn').click (event)->
  $(event.currentTarget).parents('#customer_allergy_new_form').addClass('hide')
  if $('#allergies_table').find('.allergy-row').length == 0
    $('#allergies_table').find('#allergy_table_header').addClass('hide')

$('.customer-allergy-cancel-btn').click (event)->
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").prev().prev().removeClass "hide"
  return

$('.customer-allergy-edit-pencil').click (event)->
  event.preventDefault()
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").next().next().removeClass "hide"

$('#new_customer_allergy').bind 'ajax:success', (event, data) ->
  event.preventDefault()
#  $('#customer_allergy_new_form').addClass('hide')
  $('#allergies_table').find('#customer_allergy_new_form').addClass('hide')
  $('#allergies_table').find('tbody').children().eq(1).after("#{data}")
  $('#reset_allergy_btn').click()
  if $('#allergies_table').find('.allergy-row').length > 0
    $('#allergies_table').find('#no_allergies_row').addClass('hide')

  #binding click events to pencil icon and cancel button and save button
  $('.customer-allergy-edit-pencil').bind('click', showEditRow)
  $('.customer-allergy-cancel-btn').bind('click', hideEditRow)
  $('.customer-allergy-select').bind('change', allergySelect)
  $('.customer-allergy-save-btn').bind('click', submitCustomerAllegyForm)
  $('.customer-allergy-delete-row').bind('click', deleteAllergy)

$('.edit-customer-allergy').bind 'ajax:success', (event, data) ->
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().html(data)
  $(event.currentTarget).prev().find('.customer-allergy-edit-pencil').bind('click', showAppendedEditRow)
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  $('.customer-allergy-delete-row').bind('click', deleteAllergy)


#-----------------------------------------loading  customer immunizations-----------------------------------------------

submitCustomerImmunizationForm = (event)->
  event.preventDefault()
  form = $(event.currentTarget).parents('tr').children().first()
  url =  form.attr('action')
  _event = event

  immunization_name = $(event.currentTarget).parents('tr').find('#immunization_name').val()
  immunization_type = $(event.currentTarget).parents('tr').find('#immunization_immunization_type').val()
  immunization_date = $(event.currentTarget).parents('tr').find('#immunization_customer_immunizations_date').val()
  immunization_dosage = $(event.currentTarget).parents('tr').find('#immunization_customer_immunizations_dosage').val()
  immunization_instructions = $(event.currentTarget).parents('tr').find('#immunization_customer_immunizations_instructions').val()

  $.ajax
    type: 'PATCH'
    url: url
    data:
      immunization:
        name: immunization_name
        immunization_type: immunization_type
        customer_immunizations:
          date: immunization_date
          dosage: immunization_dosage
          instructions: immunization_instructions

    success: ( data, status, xhr) ->
      hideEditRow(_event)
      updateRow(_event, data)

deleteImmunization = ->
  immunization_row = $(event.currentTarget).parents('tr')
  immunization_url = if immunization_row.next().is('form') then immunization_row.next().attr('action') else immunization_row.next().children().first().attr('action')
  immunization_edit_row = if immunization_row.next().is('form') then immunization_row.next().next() else immunization_row.next()
  immunization_form= if immunization_row.next().is('form') then immunization_row.next() else 'no_form'
  confirmed = confirm('Are you sure')
  if confirmed
    $.ajax
      type: 'DELETE'
      url: immunization_url
      success: (data, status, xhr) ->
        immunization_row.remove()
        immunization_edit_row.remove()
        if $('#immunization_table').find('.immunization-row').length == 0
          $('#immunization_table').find('#immunization_table_header').addClass('hide')
          $('#immunization_table').find('#no_immunizations_row').removeClass('hide')
        if immunization_form != 'no_form' then immunization_form.remove else return


$('#create_customer_immunization').click ->
  $('#immunization_table').find('#customer_immunization_new_form').removeClass('hide')
  $('#immunization_table').find('#immunization_table_header').removeClass('hide')

$('#customer_immunization_cancel_btn').click (event)->
  $(event.currentTarget).parents('#customer_immunization_new_form').addClass('hide')
  if $('#immunization_table').find('.immunization-row').length == 0
    $('#immunization_table').find('#immunization_table_header').addClass('hide')


$('.customer-immunization-cancel-btn').click (event)->
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").prev().prev().removeClass "hide"
  return

$('.customer-immunization-edit-pencil').click (event)->
  event.preventDefault()
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").next().next().removeClass "hide"

$('.customer-immunization-delete-row').click (event)->
  deleteImmunization()

$('#new_customer_immunization').bind 'ajax:success', (event, data) ->
  event.preventDefault()
#  $('#customer_immunization_new_form').addClass('hide')
  $('#immunization_table').find('#customer_immunization_new_form').addClass('hide')
  $('#immunization_table').find('tbody').children().eq(1).after("#{data}")
  $('#reset_immunization_btn').click()
  if $('#immunization_table').find('.immunization-row').length > 0
    $('#immunization_table').find('#no_immunizations_row').addClass('hide')

  #binding click events to pencil icon and cancel button and save button
  $('.customer-immunization-edit-pencil').bind('click', showEditRow)
  $('.customer-immunization-cancel-btn').bind('click', hideEditRow)
  $('.customer-immunization-save-btn').bind('click', submitCustomerImmunizationForm)
  $('.datepicker').datepicker()
  $('.customer-immunization-delete-row').bind('click', deleteImmunization)

$('.edit-customer-immunization').bind 'ajax:success', (event, data) ->
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().html(data)
  $(event.currentTarget).prev().find('.customer-immunization-edit-pencil').bind('click', showAppendedEditRow)
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  $('.customer-immunization-delete-row').bind('click', deleteImmunization)


#-----------------------------------------loading  customer medications-----------------------------------------------
submitCustomerMedicationForm = (event)->
  event.preventDefault()
  form = $(event.currentTarget).parents('tr').children().first()
  url =  form.attr('action')
  _event = event

  name = $(event.currentTarget).parents('tr').find('#medication_name').val()
  medication_type = $(event.currentTarget).parents('tr').find('#medication_medication_type').val()
  medication_date = $(event.currentTarget).parents('tr').find('#medication_date').val()
  dosage_qty = $(event.currentTarget).parents('tr').find('#medication_dose_quantity').val()
  rate_qty = $(event.currentTarget).parents('tr').find('#medication_rate_quantity').val()
  prescriber_name = $(event.currentTarget).parents('tr').find('#medication_prescriber_name').val()
  medication_active = $(event.currentTarget).parents('tr').find('#medication_active').val()

  $.ajax
    type: 'PATCH'
    url: url
    data:
      medication:
        name: name
        dose_quantity: dosage_qty
        medication_type: medication_type
        date: medication_date
        rate_quantity: rate_qty
        prescriber_name: prescriber_name
        active: medication_active

    success: ( data, status, xhr) ->
      hideEditRow(_event)
      updateRow(_event, data)

deleteMedication = ->
  medication_row = $(event.currentTarget).parents('tr')
  medication_url = if medication_row.next().is('form') then medication_row.next().attr('action') else medication_row.next().children().first().attr('action')
  medication_edit_row = if medication_row.next().is('form') then medication_row.next().next() else medication_row.next()
  medication_form= if medication_row.next().is('form') then medication_row.next() else 'no_form'
  confirmed = confirm('Are you sure')
  if confirmed
    $.ajax
      type: 'DELETE'
      url: medication_url
      success: (data, status, xhr) ->
        medication_row.remove()
        medication_edit_row.remove()
        if $('#medications_table').find('.medication-row').length == 0
          $('#medications_table').find('#medication_table_header').addClass('hide')
          $('#medications_table').find('#no_medications_row').removeClass('hide')
        if medication_form != 'no_form' then medication_form.remove else return

$('#create_customer_medication').click ->
  $('#medications_table').find('#customer_medication_new_form').removeClass('hide')
  $('#medications_table').find('#medication_table_header').removeClass('hide')

$('#customer_medication_cancel_btn').click (event)->
  $(event.currentTarget).parents('#customer_medication_new_form').addClass('hide')
  if $('#medications_table').find('.medication-row').length == 0
    $('#medications_table').find('#medication_table_header').addClass('hide')

$('.customer-medication-cancel-btn').click (event)->
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").prev().prev().removeClass "hide"
  return

$('.customer-medication-edit-pencil').click (event)->
  event.preventDefault()
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").next().next().removeClass "hide"

$('.customer-medication-delete-row').click (event)->
  deleteMedication()

$('#new_customer_medication').bind 'ajax:success', (event, data) ->
  event.preventDefault()
#  $('#customer_medication_new_form').addClass('hide')
  $('#medications_table').find('#customer_medication_new_form').addClass('hide')
  $('#medications_table').find('tbody').children().eq(1).after("#{data}")
  $('#reset_customer_medication_btn').click()
  if $('#medications_table').find('.medication-row').length > 0
    $('#medications_table').find('#no_medications_row').addClass('hide')

  #binding click events to pencil icon and cancel button and save button
  $('.customer-medication-edit-pencil').bind('click', showEditRow)
  $('.customer-medication-cancel-btn').bind('click', hideEditRow)
  $('.customer-medication-save-btn').bind('click', submitCustomerMedicationForm)
  $('.datepicker').datepicker()
  $('.customer-medication-delete-row').bind('click', deleteMedication)

$('.edit-customer-medication').bind 'ajax:success', (event, data) ->
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().html(data)
  $(event.currentTarget).prev().find('.customer-medication-edit-pencil').bind('click', showAppendedEditRow)
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  $('.customer-medication-delete-row').bind('click', deleteMedication)


#-----------------------------------------loading  customer medications-------------------------------------------------

submitCustomerFmh = (event)->
  event.preventDefault()
  form = $(event.currentTarget).parents('tr').children().first()
  url =  form.attr('action')
  _event = event

  name = $(event.currentTarget).parents('tr').find('#family_medical_history_name').val()
  relation = $(event.currentTarget).parents('tr').find('#family_medical_history_relation').val()
  age = $(event.currentTarget).parents('tr').find('#family_medical_history_age').val()
  status = $(event.currentTarget).parents('tr').find('#family_medical_history_status').val()
  condition1 = $(event.currentTarget).parents('tr').find('#family_medical_history_medical_condition_1').val()
  condition2 = $(event.currentTarget).parents('tr').find('#family_medical_history_medical_condition_2').val()
  condition3 = $(event.currentTarget).parents('tr').find('#family_medical_history_medical_condition_3').val()

  $.ajax
    type: 'PATCH'
    url: url
    data:
      family_medical_history:
        name: name
        relation: relation
        age: age
        status: status
        medical_condition_1: condition1
        medical_condition_2: condition2
        medical_condition_3: condition3

    success: ( data, status, xhr) ->
      hideEditRow(_event)
      updateRow(_event, data)


deleteFmh = (event)->
  family_medical_history_row = $(event.currentTarget).parents('tr')
  family_medical_history_url = if family_medical_history_row.next().is('form') then family_medical_history_row.next().attr('action') else family_medical_history_row.next().children().first().attr('action')
  family_medical_history_edit_row = if family_medical_history_row.next().is('form') then family_medical_history_row.next().next() else family_medical_history_row.next()
  family_medical_history_form= if family_medical_history_row.next().is('form') then family_medical_history_row.next() else 'no_form'
  confirmed = confirm('Are you sure')
  if confirmed
    $.ajax
      type: 'DELETE'
      url: family_medical_history_url
      success: (data, status, xhr) ->
        family_medical_history_row.remove()
        family_medical_history_edit_row.remove()
        if family_medical_history_form != 'no_form' then family_medical_history_form.remove else return



$('#create_customer_family_medical_history').click ->
  $('#family_medical_histories_table').find('#customer_family_medical_history_new_form').removeClass('hide')

$('#customer_family_medical_history_cancel_btn').click (event)->
  $(event.currentTarget).parents('#customer_family_medical_history_new_form').addClass('hide')

$('.customer-family-medical-history-cancel-btn').click (event)->
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").prev().prev().removeClass "hide"
  return

$('.customer-family-medical-history-edit-pencil').click (event)->
  event.preventDefault()
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").next().next().removeClass "hide"

$('.customer-family-medical-history-delete-row').click (event)->
  deleteFmh(event)

$('#new_customer_family_medical_history').bind 'ajax:success', (event, data) ->
  event.preventDefault()
#  $('#customer_family_medical_history_new_form').addClass('hide')
  $('#family_medical_histories_table').find('#customer_family_medical_history_new_form').addClass('hide')
  $('#family_medical_histories_table').find('tbody').children().eq(1).after("#{data}")
  $('#reset_customer_family_medical_history_btn').click()

  #binding click events to pencil icon and cancel button and save button
  $('.customer-family-medical-history-edit-pencil').bind('click', showEditRow)
  $('.customer-family-medical-history-cancel-btn').bind('click', hideEditRow)
  $('.customer-family-medical-history-save-btn').bind('click', submitCustomerFmh)
  $('.cutomer-family-medical-history-delete-row').bind('click', deleteFmh)

$('.edit-customer-family-medical-history').bind 'ajax:success', (event, data) ->
  $(event.currentTarget).next().addClass('hide')
#  $(event.currentTarget).prev().html(data)
  $(event.currentTarget).prev().find('.customer-family-medical-history-edit-pencil').bind('click', showAppendedEditRow)
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  $('.customer-family-medical-history-delete-row').bind('click', deleteFmh)


# learn more page start
$ ->
  $(".entry-content .tabs li a").click ->
    id = @id.split("_")[0]
    $lnk = $(".entry-content .tabs li a")
    $lnk.removeClass "active"
    $(this).addClass "active"
    $(".tab_sec").hide()
    $("#" + id).show()
    return

  return

# learn more page end
hyper_prediction = ->
  $.ajax
    url: "/customers/customer_information/hypertension_prediction_values"
    type: "GET"
    data:
      id: $("#customer_id").val()
    success: (result) ->
      hypertension_scores=[]
      for key of result['hypertension']
        hypertension_scores.push [
          key,
          result['hypertension'][key]
        ]
      data1 = [
        {
          label: 'HyperTension'
          data: hypertension_scores
          bars:
            show: true
            fill: true
            lineWidth: 1
            barWidth: 0.3
            order: 5
            align:'center'
            fillColor: colors: [
              { opacity: 0.5 }
              { opacity: 0.9 }
            ]
          color: '#8dd168'
        }
      ]
      $('#flot-bar').length and $.plot($('#flot-bar'), data1,
        xaxis:
          axisLabel: 'year',
          ticks:[[1,'1st year'],[2,'2nd year'],[3,'3rd year'],[4,'4th year']],
          tickDecimals: 0
        yaxis:
          axisLabel: '%',
          tickFormatter: (v, axis) ->
            return v + "%"
          tickDecimals: 0
        grid:
          hoverable: true
          clickable: false
          borderWidth: 0
        legend:
          labelBoxBorderColor: 'none'
          position: 'left'
        series: shadowSize: 1)

$("#hypertension_score_chart").find("#score-graph").on "click", ->
  hyper_prediction()
  $("#hypertension_history_chart").css
    left: 0
    position: "static"

  $("#hypertension_score_chart").hide()

$("#hypertension_history_graph").on "click", ->
  $("#hypertension_score_chart").show()
  $("#hypertension_history_chart").css
    left: -9999
    position: "absolute"
  $("#hypertension_history_chart").find('.panel-body').css({
    height: "347px"
  })

$('#blood_glucose li:not(:first-child)').removeClass 'active'
$('#blood_glucose li').click (e) ->
  $(this).siblings().removeClass 'active'
  heading=$(this).text()
#  $('#heading').html(heading)
  return

$('.water_buttons').on "click", ->
  water_intake_value=this.value
  $.ajax
    url: "/customers/customer_information/update_water_intake_value"
    type: "POST"
    data:
      value: water_intake_value
    success: (result) ->
      $('#glassActualReading').text(result.water_consumed+'ml')
      actual_water_intake=$('#glassFullReading').text().trim().split('ml')[0]
      water_intake_chart(result.water_consumed,actual_water_intake)
    error: (xhr, status, error) ->

water_intake_chart = (consumed,actual_water_intake) ->
  glassHeight = 150
  glassFullWidth = 150
  edgeWidth = 30
  glassLeft = 0
  glassTop = 0
  ratio = 0
  if($('#water_intake_chart').length>0)
    if(consumed!=0 && actual_water_intake!=0)
      ratio=consumed/actual_water_intake
    if(ratio>1)
      ratio=1
  width = glassFullWidth - (edgeWidth * 2) + edgeWidth * 2 * ratio
  borderTopWidth = glassHeight * ratio
  marginTop = -1 * glassHeight * ratio
  borderSide = edgeWidth * ratio
  left = glassLeft + edgeWidth - (edgeWidth * ratio)
  actualReadingTop = 140 - (glassHeight * ratio)
  if(actualReadingTop<=4)
    actualReadingTop = 4
  $('#glassActualReading').css 'top', actualReadingTop
  $('#glassFull').animate {
    'left': left
    'marginTop': marginTop
    'borderTopWidth': borderTopWidth
    'borderLeftWidth': borderSide
    'borderRightWidth': borderSide
    'width': width
  }, 200
  return


$('.mother-health-none').click ->
  $('.mother-health-not-none').removeClass('selected')
  $('.mother-health-not-none').removeClass('btn-success')

$('.mother-health-not-none').click ->
  $('.mother-health-none').removeClass('selected')
  $('.mother-health-none').removeClass('btn-success')

$('.father-health-none').click ->
  $('.father-health-not-none').removeClass('selected')
  $('.father-health-not-none').removeClass('btn-success')

$('.father-health-not-none').click ->
  $('.father-health-none').removeClass('selected')
  $('.father-health-none').removeClass('btn-success')

$('.waterIntakeButton').click ->
  water_intake_history()
  return

water_intake_history = () ->
  $('.waterIntakePanel').toggleClass 'hide'
  actual_consumptions=[]
  water_consumed_data=[]
  dates=[]
  $.ajax
    url: "/customers/customer_information/water_intake_history"
    type: "GET"
    success: (result) ->
      i=0
      for value in result.water_consumption_history
        actual_consumptions.push [i,value.actual_consumption]
        water_consumed_data.push [i,value.water_consumed]
        dt=moment(value.consumed_date).format('MMMM Do')
        dates.push  [i,dt]
        i+=1

      $('#water-intake-chart').length and $.plot($('#water-intake-chart'), [
          {
            data: actual_consumptions
            label: 'Optimum Intake'            
          }
          {
            data: water_consumed_data
            label: 'Actual Intake'
          }
        ],
        series:
          lines:
            show: true
            lineWidth: 1
            fill: true
            fillColor: colors: [
              { opacity: 0.3 }
              { opacity: 0.3 }
            ]
          points: show: true
          shadowSize: 2
        grid:
          hoverable: true
          clickable: true
          tickColor: '#f0f0f0'
          borderWidth: 0

        legend:
          labelBoxBorderColor: 'none'
          position: 'left'
          noColumns: 0
        colors: [
          '#1bb399'
          '#177bbb'
        ]
        xaxis:
#          ticks: 15
          tickDecimals: 0
          ticks: dates
        yaxis:
          ticks: 5
          tickDecimals: 0
        tooltip: true
        tooltipOpts:
          content: (label, xval, yval, flotItem) ->
#            xval=moment(xval).format('MMMM Do YYYY, h:mm:ss a')
            label+' value:'+' <b>' + yval + '</b> <span> on ' + dates[xval][1] + '</span>'
          defaultTheme: false
          shifts:
            x: 0
            y: 20)

    error: (xhr, status, error) ->
