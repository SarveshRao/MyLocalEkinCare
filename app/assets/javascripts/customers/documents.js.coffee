$ ->
  $('#customer_medical_record_form').bind 'ajax:success', (event, data) ->
    data = data.replace(/"/g, "")
    $('#customer_documents .partial').html("#{data}")
    $('#customer-records').find('input[type=reset]').click()

