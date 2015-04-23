#toggleCreateButton = ->
#  $('#create_dental_result').toggleClass('hide')
#
#$('#create_dental_result').click ->
#  toggleCreateButton()
#
#$('.cancel-dental-result-form').click ->
#  toggleCreateButton()

dentitionBasedToothNumber = (ele)->
  dentition = $(ele)
  dentition_val = $(ele).val()
  tooth_ele = dentition.parents('tr').find('.tooth_number')
  tooth_ele.empty()
  if dentition_val == 'Permanent'
    tooths = [11..18].concat([21..28]).concat([31..38]).concat([41..48])
  else
    tooths = [51..55].concat([61..65]).concat([71..75]).concat([81..85])
  for tooth in tooths
    tooth_ele.append("<option value=#{tooth}>#{tooth}</option>")

bindEventsToDentalResults = ->
#  for dentition_ele in $('.dentition')
#    dentitionBasedToothNumber dentition_ele

  $('.dentition').change (event, data) ->
    dentitionBasedToothNumber $(event.currentTarget)

bindEventsToDentalResults()

for ele in $('.dentition')
  dentitionBasedToothNumber ele

showEditRow = (event)->
  $(event.currentTarget).parents("tr").addClass "hide"
  if $(event.currentTarget).parents('tr').next().is('form')
    $(event.currentTarget).parents("tr").next().next().removeClass "hide"
  else
    $(event.currentTarget).parents("tr").next().removeClass "hide"
  return

hideEditRow = (event)->
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").prev().prev().removeClass "hide"

updateRow = (event, data)->
  event.preventDefault()
  $(event.currentTarget).parents('tr').prev().html(data)
  $(event.currentTarget).parents('tr').prev().find('.edit-dental-result-pencil').bind('click', showEditRow)
  $(event.currentTarget).parents('tr').prev().find('.dental-result-delete-row').bind('click', deleteDentalResult)

updateDentalRow = (event, data) ->
  event.preventDefault()
  current_row = $(event.currentTarget).parents('tr')
  prev_row = current_row.prev()
  new_update_row = if prev_row.is('form') then prev_row.prev() else prev_row
  new_update_row.html(data)
  new_update_row.find('.edit-dental-result-pencil').bind('click', showEditRow)
  new_update_row.find('.dental-result-delete-row').bind('click', deleteDentalResult)


showAppendedEditRow = (event)->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').next().next().removeClass('hide')

#******************* dental result submit form *******
submitDentalResultForm = (event)->
  event.preventDefault()
  form = $(event.currentTarget).parents('tr').prev()
  url =  form.attr('action')
  _event = event
  dentition = $(event.currentTarget).parents('tr').find('.dentition').val()
  tooth_number = $(event.currentTarget).parents('tr').find('.tooth_number').val()
  diagnosis = $(event.currentTarget).parents('tr').find('.diagnosis').val()
  recommendation = $(event.currentTarget).parents('tr').find('.recommendation').val()
  $.ajax
    type: 'PATCH'
    url: url
    data:
      result:
        dentition: dentition
        tooth_number: tooth_number
        diagnosis: diagnosis
        recommendation: recommendation
    success: ( data, status, xhr) ->
      hideEditRow(_event)
      updateDentalRow(_event, data)
      bindEventsToDentalResults()

#**********deleting dental result***********
deleteDentalResult = (event)->
  dental_result_row = $(event.currentTarget).parents('tr')
  dental_result_url = if dental_result_row.next().is('form') then dental_result_row.next().attr('action') else dental_result_row.next().children().first().attr('action')
  dental_result_edit_row = if dental_result_row.next().is('form') then dental_result_row.next().next() else dental_result_row.next()
  dental_result_form= if dental_result_row.next().is('form') then dental_result_row.next() else 'no_form'
  confirmed = confirm('Are you sure')
  if confirmed
    $.ajax
      type: 'DELETE'
      url: dental_result_url
      success: (data, status, xhr) ->
        dental_result_row.remove()
        dental_result_edit_row.remove()
#        toggleCreateButton()
        if dental_result_form != 'no_form' then dental_result_form.remove else return


$('#create_dental_result').click ->
  $('#dental_result_new_form').removeClass('hide')

$('#dental_result_cancel_btn').click (event)->
  $(event.currentTarget).parents('#dental_result_new_form').addClass('hide')

$('.dental-result-cancel-btn').click (event)->
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").prev().prev().removeClass "hide"
  return

$('.edit-dental-result-pencil').click (event)->
  event.preventDefault()
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").next().next().removeClass "hide"

$('#new_result').bind 'ajax:success', (event, data) ->
  event.preventDefault()
  $('#dental_result_new_form').addClass('hide')
  $('#dental_result_table').find('tbody').children().find('#new_dental_result')
  $('#dental_result_table').find('tbody').children().eq(1).after("#{data}")

  #clearing form data which posted
  $('#reset_dental_result_btn').click()

  #binding click events to pencil icon and cancel button and save button
  $('.edit-dental-result-pencil').bind('click', showEditRow)
  $('.dental-result-cancel-btn').bind('click', hideEditRow)
  $('.save-edit-dental-result-form').bind('click', submitDentalResultForm)
  $('.dental-result-delete-row').bind('click', deleteDentalResult)
  bindEventsToDentalResults()

$('.edit_result').bind 'ajax:success', (event, data)->
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().html(data)
  $(event.currentTarget).prev().find('.edit-dental-result-pencil').bind('click', showAppendedEditRow)
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  $('.dental-result-delete-row').bind('click', deleteDentalResult)
  bindEventsToDentalResults()

$('.dental-result-delete-row').click ->
  deleteDentalResult(event)
