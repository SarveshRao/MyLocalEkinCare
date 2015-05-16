$ ->
  expand_masked_layer_height = ->
    if $('#masked_layer')
      $('#masked_layer').height($(document).height() + 100)

  removeDocMedicalRecord = (event) ->
    $(event.currentTarget).parents('.doc_container').remove()

  $('#upload_records').click ->
    val = $('.document_upload_input').val()
    $('#ajax_error_container').html("")
    if val != ""
      $('#ajax_loader_container').removeClass('hide')

  $('.doc_container').find('a.edit_medical_record').click (event)->
    removeDocMedicalRecord(event)

  $('#new_medical_record').bind 'ajax:success', (event, data) ->
    $('#ajax_loader_container').addClass('hide')
    data = data.replace(/"/g, "")
    $('#uploaded_documents').html("#{data}")
    $('.doc_container').find('a.edit_medical_record').bind('click', removeDocMedicalRecord)
    $('#record_submission').find('input[type=reset]').click()

  $('#new_medical_record').bind 'ajax:error', (xhr, status, error) ->
    if status.status == "200"
      $('#ajax_loader_container').addClass('hide')
      data = status.responseText.replace(/"/g,"")
      $('#uploaded_documents').empty()
      $('#uploaded_documents').html("#{data}")
      $('.doc_container').find('a.edit_medical_record').bind('click', removeDocMedicalRecord)
      $('#record_submission').find('input[type=reset]').click()
    else
      $('#ajax_loader_container').addClass('hide')
      $('#record_submission').find('input[type=reset]').click()
      $('#ajax_error_container').html('<span class="text-danger bg-white p-a">Invalid file format</span>')

  $('#add_family_record').click (event) ->
    $.ajax
      url: '/customers/new_family_medical_history'
      success: (data, status, xhr) ->
        new_record = $(data).find('.list-group')
        $('#family_history_wizard').prepend(new_record)
        expand_masked_layer_height()

  expand_masked_layer_height()
