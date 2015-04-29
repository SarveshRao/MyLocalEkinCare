$ ->
  $('#new_note').bind 'ajax:success', (event, data) ->
    $('#notes_panel .partial').html("#{data}")
    $('#notes_reset_btn').click()

  bindEditNote = (event) ->
    $(event.currentTarget).parents('.media').remove()
    notes_count_ele = $('#notes_panel header').find('.label')
    notes_count_ele.text(parseInt(notes_count_ele.text()) - 1)

  $('.edit_note').bind('click', bindEditNote)