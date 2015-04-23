showBioDetails = ->
  $('#customer_bio_edit_btn').click ->
    $('#normal_bio_details_view').fadeOut(500).toggleClass('hide')
    $('#edit_bio_form').fadeIn(500).toggleClass('hide')

  $('.customer-bio-cancel-btn').click ->
    $('#edit_bio_form').toggleClass('hide')
    $('#normal_bio_details_view').fadeIn(500).toggleClass('hide')

  $('#edit_customer_bio_form').bind 'ajax:success', (event,data) ->
    $('#normal_bio_details_div').html($(data).html())
    showBioDetails()

showLifeStyleDetails = ->
  $('#customer_life_style_edit_btn').click ->
    $('#normal_life_style_details_view').fadeOut(500).toggleClass('hide')
    $('#edit_life_style_form').fadeIn(500).toggleClass('hide')

  $('.customer-life-style-cancel-btn').click ->
    $('#edit_life_style_form').toggleClass('hide')
    $('#normal_life_style_details_view').fadeIn(500).toggleClass('hide')

  $('#edit_customer_life_style_form').bind 'ajax:success', (event,data) ->
    $('#normal_life_style_details_div').html($(data).html())
    showLifeStyleDetails()

showContactDetails = ->
  $('#contact_info_edit_btn').click ->
    $('#normal_contact_details_view').fadeOut(500).toggleClass('hide')
    $('#edit_contact_form').fadeIn(500).toggleClass('hide')

  $('.customer-contact-cancel-btn').click ->
    $('#edit_contact_form').toggleClass('hide')
    $('#normal_contact_details_view').fadeIn(500).toggleClass('hide')

  $('#customer_med_basic_details_form').bind 'ajax:success', (event,data) ->
    $('#normal_contact_details_div').html($(data).html())
    showContactDetails()

showComplaintsDetails = ->
  $('#customer_current_complaints_edit_btn').click ->
    $('#normal_current_complaints_details_view').fadeOut(500).toggleClass('hide')
    $('#edit_current_complaints_form').fadeIn(500).toggleClass('hide')

  $('.customer-current-complaints-cancel-btn').click ->
    $('#edit_current_complaints_form').toggleClass('hide')
    $('#normal_current_complaints_details_view').fadeIn(500).toggleClass('hide')

  $('#customer_current_complaints_form').bind 'ajax:success', (event,data) ->
    $('#normal_current_complaints_details_div').html($(data).html())
    showComplaintsDetails()

showBioDetails()
showLifeStyleDetails()
showContactDetails()
showComplaintsDetails()
