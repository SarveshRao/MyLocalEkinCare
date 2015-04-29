$('#create_prescription').click ->
  $('#new_prescription_block').removeClass('hide')
  $('#edit_prescription_btn').addClass('hide')

$('#prescription_cancel_btn').click ->
  $('#new_prescription_block').addClass('hide')

$('#edit_prescription_btn').click ->
  $('#prescription_details_block').addClass('hide')
  $('#prescription_delete_btn').addClass('hide')
  $('#edit_prescription_block').removeClass('hide')

$('#edit_prescription_cancel_btn').click ->
  $('#edit_prescription_block').addClass('hide')
  $('#prescription_details_block').removeClass('hide')
  $('#prescription_delete_btn').removeClass('hide')
