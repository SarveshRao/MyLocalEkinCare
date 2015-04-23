$ ->
  removeMedicalRecord = (event) ->
    $(event.currentTarget).parents('.media').remove()
    medical_records_count_ele = $('#medical_records_panel header').find('.label')
    medical_records_count_ele.text(parseInt(medical_records_count_ele.text()) - 1)

  $('.edit_medical_record').bind('click', removeMedicalRecord)

  $('#new_medical_record').bind 'ajax:success', (event, data) ->
    data = data.replace(/"/g, "")
    $('#medical_records_panel .partial').html("#{data}")
    $('.edit_medical_record').bind('click', removeMedicalRecord)
    $('#medical_records_panel').find('input[type=reset]').click()