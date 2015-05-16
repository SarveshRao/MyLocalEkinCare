# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

updatePromoCodeRow = (event, data) ->
  event.preventDefault()
  current_row = $(event.currentTarget).parents('tr')
  prev_row = current_row.prev()
  new_update_row = if prev_row.is('form') then prev_row.prev() else prev_row
  new_update_row.html(data)
  new_update_row.find('.edit-promo-code-result-pencil').bind('click', showEditRow)


showEditRow = (event)->
  $(event.currentTarget).parents("tr").addClass "hide"
  if $(event.currentTarget).parents('tr').next().is('form')
    $(event.currentTarget).parents("tr").next().next().removeClass "hide"
  else
    $(event.currentTarget).parents("tr").next().removeClass "hide"
  return

submitDentalResultForm = (event)->
  promo_code_row = $(event.currentTarget).parents('tr')
  event.preventDefault()
  form = $(event.currentTarget).parents('tr').prev()
  _event = event
  promo_code_id=promo_code_row.attr('promo_code_id')
  partner_id = $(event.currentTarget).parents('tr').find('.partner').val()
  status = $(event.currentTarget).parents('tr').find('.status').val()
  $.ajax
    type: 'PATCH'
    url: "/staff/promo_codes/#{promo_code_id}"
    data:
      promo_code:
        partner_id: partner_id
        status: status

    success: ( data, status, xhr) ->
      hideEditRow(event)
      updatePromoCodeRow(event, data)




hideEditRow = (event)->
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").prev().removeClass "hide"

showAppendedEditRow = (event)->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').next().next().removeClass('hide')

$('.edit_promo_code').bind 'ajax:success', (event, data)->
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().html(data)
  $(event.currentTarget).prev().find('.edit-dental-result-pencil').bind('click', showAppendedEditRow)
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  $('.promo-code-delete-row').bind('click', deleteDentalResult)


$('#promo_code_cancel_btn').click (event)->
  $(event.currentTarget).parents('#promo_result_new_form').addClass('hide')

$('.promo-code-cancel-btn').click (event)->
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").prev().removeClass "hide"
  return

$('.edit-promo-code-result-pencil').click (event)->
  event.preventDefault()
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  $(event.currentTarget).parents("tr").next().next().removeClass "hide"


$('.edit-promo-code-result-pencil').bind('click', showEditRow)
$('.save-edit-promo-code-result-form').bind('click', submitDentalResultForm)

