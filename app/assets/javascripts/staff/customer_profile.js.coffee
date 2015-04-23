$('#allergies').click ->
  $('#allergies_info').removeClass('hide')
  for ele in ['#customer-details', '#family_history_info','#promo_code_history_info','#health_issues_info']
    $(ele).addClass('hide')

$('#family_history').click ->
  $('#family_history_info').removeClass('hide')
  for ele in ['#customer-details', '#allergies_info','#promo_code_history_info','#health_issues_info']
    $(ele).addClass('hide')

$('#promo_code_history').click ->
  $('#promo_code_history_info').removeClass('hide')
  for ele in ['#customer-details', '#allergies_info','#family_history_info','#health_issues_info']
    $(ele).addClass('hide')

$('#health_issues').click ->
  $('#health_issues_info').removeClass('hide')
  for ele in ['#customer-details', '#allergies_info','#family_history_info','#promo_code_history_info']
    $(ele).addClass('hide')

$('#profile').click ->
  $('#customer-details').removeClass('hide')
  $('#basic_details').removeClass('hide')
  for ele in ['#allergies_info', '#add_details', '#med_details', '#family_history_info','#promo_code_history_info','#health_issues_info']
    $(ele).addClass('hide')

$('#contact_information').click ->
  $('#customer-details').removeClass('hide')
  $('#med_details').removeClass('hide')
  for ele in ['#allergies_info', '#add_details', '#basic_details', '#family_history_info','#promo_code_history_info','#health_issues_info']
    $(ele).addClass('hide')

$('#life_style').click ->
  $('#customer-details').removeClass('hide')
  $('#add_details').removeClass('hide')
  for ele in ['#allergies_info', '#med_details', '#basic_details', '#family_history_info','#promo_code_history_info','#health_issues_info']
    $(ele).addClass('hide')

showBasicCustomers = ->
  $('#customer_basic_details_edit_btn').click ->
    $('#normal_customer_basic_details').fadeOut(500).toggleClass('hide')
    $('#edit_customer_basic_details_form').fadeIn(500).toggleClass('hide')

  $('.customer-details-cancel-btn ').click ->
    $('#edit_customer_basic_details_form').toggleClass('hide')
    $('#normal_customer_basic_details').fadeIn(500).toggleClass('hide')

  $('#customer_basic_details_form').bind 'ajax:success', (event,data) ->
    $('#basic_details').html($(data).find('#basic_details').html())
    showBasicCustomers()
    try
      $('#edit_customer_basic_details_form .datepicker').datepicker()
    catch e
      console.log e

showAddBasicCustomers = ->
  $('#customer_add_basic_details_edit_btn').click ->
    $('#normal_customer_add_basic_details').toggleClass('hide')
    $('#edit_customer_add_basic_details_form').fadeIn(500).toggleClass('hide')

  $('.customer-details-add-cancel-btn ').click ->
    $('#edit_customer_add_basic_details_form').toggleClass('hide')
    $('#normal_customer_add_basic_details').fadeIn(500).toggleClass('hide')

  $('#customer_add_basic_details_form').bind 'ajax:success', (event,data) ->
    $('#add_details').html($(data).find('#add_details').html())
    showAddBasicCustomers()


showMedBasicCustomers = ->
  $('#customer_med_basic_details_edit_btn').click ->
    $('#normal_customer_med_basic_details').toggleClass('hide')
    $('#edit_customer_med_basic_details_form').fadeIn(500).toggleClass('hide')

  $('.customer-details-med-cancel-btn ').click ->
    $('#edit_customer_med_basic_details_form').toggleClass('hide')
    $('#normal_customer_med_basic_details').fadeIn(500).toggleClass('hide')

  $('#customer_med_basic_details_form').bind 'ajax:success', (event,data) ->
    $('#med_details').html($(data).find('#med_details').html())
    showMedBasicCustomers()

EditEnterpriseDetails = ->
  $(document).on 'click', '#enterprise_details_edit_btn', ->
    $('#show_enterprise_details').fadeOut(500).toggleClass('hide')
    $('#edit_enterprise_details_form').fadeIn(500).toggleClass('hide')

  $('.edit-enterprise-details-cancel-btn').click ->
    $('#edit_enterprise_details_form').toggleClass('hide')
    $('#show_enterprise_details').fadeIn(500).toggleClass('hide')

  $('#edit_enterprise_details_form').bind 'ajax:success', (event,data) ->
    $('#edit_enterprise_details_form').toggleClass('hide')
    objectEvents =  $('#show_enterprise_details').children().detach()
    $('#show_enterprise_details').append(data)
    $('#show_enterprise_details').fadeIn(500).toggleClass('hide')

  $(document).on 'ajax:success', 'a#new_provider_btn', (event, data, status) ->
    window.providerListing = $('#enterprise_branches_panel').children().detach()
    $('#enterprise_branches_panel').append(data)

  $(document).on 'ajax:success', 'a#edit_provider_btn', (event, data, status) ->
    window.providerListing = $('#enterprise_branches_panel').children().detach()
    $('#enterprise_branches_panel').append(data)

  $(document).on 'ajax:beforeSend', 'form#new_provider_form', (event, data, status) ->
    $('#new_provider_form').parsley().validate()

  $(document).on 'ajax:beforeSend', 'form#edit_provider_form', (event, data, status) ->
    $('#edit_provider_form').parsley().validate()

  $(document).on 'ajax:success', 'form#edit_provider_form', (event,data) ->
    $('#enterprise_branches_panel').children().detach()
    $('#enterprise_branches_panel').append(data)

  $(document).on 'click', ".provider-cancel-btn", ->
    $('#enterprise_branches_panel').children().detach()
    $('#enterprise_branches_panel').append(window.providerListing)

  $(document).on 'ajax:success', "a#new_catalog_item", (event,data)->
    window.catalogListing = $('#enterprise_catalog_panel').children().detach()
    $('#enterprise_catalog_panel').append(data)

  $(document).on 'click', ".catalog-cancel-btn", ->
    $('#enterprise_catalog_panel').children().detach()
    $('#enterprise_catalog_panel').append(window.catalogListing)

  $(document).on 'ajax:success', 'form#new_provider_form', (event,data) ->
    $('#enterprise_branches_panel').children().detach()
    $('#enterprise_branches_panel').append(data)

  $(document).on 'ajax:success', 'form#new_catalog_item_form', (event,data) ->
    $('#enterprise_catalog_panel').children().detach()
    $('#enterprise_catalog_panel').append(data)

  $(document).on 'ajax:beforeSend', 'form#new_catalog_item_form', (event, data, status) ->
    $('#new_catalog_item_form').parsley().validate()

  $(document).on 'ajax:error', 'form#new_enterprise_form', (event, data, status)->
    if data.responseText == "DUPLICATE_ENTERPRISE_ID"
      $('#enterprise_enterprise_id').addClass('parsley-error')
      el = $('#enterprise_enterprise_id').parsley();
      el.manageErrorContainer();
      $(el.ulError).empty()
      el.addError({error: 'Duplicate Enterprise ID'});
    if data.responseText == "DUPLICATE_EMAIL"
      $('#enterprise_staff_attributes_email').addClass('parsley-error')
      $('#enterprise_staff_attributes_email').addClass('parsley-error')
      el = $('#enterprise_staff_attributes_email').parsley();
      el.manageErrorContainer();
      $(el.ulError).empty()
      el.addError({error: 'Duplicate Email Address'});

  $(document).on 'change', '.package_mrp', (event, data, status) ->
    $('.package_discount').val((($('.package_mrp').val() - $('.package_selling_price').val()) / $('.package_mrp').val()) * 100)

  $(document).on 'change', '.package_selling_price', (event, data, status) ->
    $('.package_discount').val((($('.package_mrp').val() - $('.package_selling_price').val()) / $('.package_mrp').val()) * 100)

showBasicCustomers()
showAddBasicCustomers()
showMedBasicCustomers()
EditEnterpriseDetails()
