$ ->
  $('#new_online_customer').validate()
  $('#new_customer_registration').validate({
    errorPlacement: (error, element) ->
      error.appendTo(element.closest('div'))
  })
  $('#edit_online_customer').validate()
  $('#family_medical_histories').validate()
  $('#customer_add_basic_details_form').validate()
  $('#customer_family_history').validate()
  $('#customer_current_complaints').validate()
  $('#customer_med_basic_details_form').validate()
  $('#new_provider_form').validate()
  $('#edit_provider_form').validate()
  $('#edit_enterprise_details_form').validate()
  $('#new_enterprise_form').validate()

