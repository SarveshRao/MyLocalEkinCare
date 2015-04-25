$('.customer-row').click ->
  window.location = $(@).attr('url')
  return false

$('#health_assessments_tile').click ->
  $('#health_assessments_panel').show()
  $('#health_assessments_panel').siblings().hide()

$('#customer_info_tile').click ->
  $('#customer_info_panel').show()
  $('#customer_info_panel').siblings().hide()

$('#immunizations_tile').click ->
  $('#immunizations_panel').show()
  $('#immunizations_panel').siblings().hide()

$('#medications_tile').click ->
  $('#medications_panel').show()
  $('#medications_panel').siblings().hide()

$('#appointments_tile').click ->
  $('#appointments_panel').show()
  $('#appointments_panel').siblings().hide()

$('#promo_codes_tile').click ->
  $('#promo_codes_panel').show()
  $('#promo_codes_panel').siblings().hide()


$('#past_medical_records_tile').click ->
  $('#medical_records_panel').show()
  $('#medical_records_panel').siblings().hide()

$('#enterprise_catalog_tile').click ->
  $('#enterprise_catalog_panel').show()
  $('#enterprise_catalog_panel').siblings().hide()

$('#enterprise_branches_title').click ->
  $('#enterprise_branches_panel').show()
  $('#enterprise_branches_panel').siblings().hide()

$('#enterprise_profile_title').click ->
  $('#enterprise_profile_panel').show()
  $('#enterprise_profile_panel').siblings().hide()


$('#enterprise_lab_tests_title').click ->
  window.showLabTestsContent()

$('#enterprise_branches_panel').show()
$('#enterprise_branches_panel').siblings().hide()

window.showLabTestsContent = ->
  $('.labTestContentDiv').removeClass('hide')
  window.initializeLabTestsContent()
  $('#enterprise_lab_tests_panel').show()
  $('.dataTables_scrollHeadInner,.dataTables_custom').removeAttr 'style'
  $('.dataTables_custom').css 'margin-bottom':1
  $('#enterprise_lab_tests_panel').siblings().hide()
  $('#test_component_content').hide()
  $('#lab_test_content').show()

$('#enterprise_branches_panel').show()
$('#enterprise_branches_panel').siblings().hide()

editRowOnLoad = (event) ->
  event.stopPropagation()
  $(event.currentTarget).parents("tr").addClass "hide"
  if $(event.currentTarget).parents('tr').next().is('form')
    $(event.currentTarget).parents("tr").next().next().removeClass "hide"
  else
    $(event.currentTarget).parents("tr").next().removeClass "hide"
  return

cancelRow = (event) ->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').prev().removeClass('hide')

editAllergySuccess = (event, data) ->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').prev().removeClass('hide')
  $(event.currentTarget).parents('tr').prev().html("<td>#{data.allergy.name}</td>
                                                      <td>#{data.allergy.reaction}</td><td>#{data.customer_allergy.severity}</td>
                                                        <td><a class='pull-right dropdown-toggle edit-pencil' data-toggle='dropdown' href='#'>
                                                              <i class='fa fa-pencil'></i></a>
                                                        </td><td><a class='pull-right dropdown-toggle allergy-delete-row' data-toggle='dropdown' href=#'>
                                                                <i class='i i-trashcan'></a></div></div></td>")
  $(event.currentTarget).parents('tr').prev().find('a.allergy-delete-row').bind('click', deleteAllergyRow)
  bindClickEventToPencil()

editImmunizationSuccess = (event, data) ->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').prev().removeClass('hide')
  $(event.currentTarget).parents('tr').prev().html("<td>#{data.immunization.name}</td>
                                                            <td>#{data.immunization.immunization_type}</td><td>#{data.date}</td>
                                                            <td>#{data.customer_immunization.dosage}</td><td>#{data.customer_immunization.instructions}</td>
                                                            <td><a class='pull-right dropdown-toggle edit-pencil' data-toggle='dropdown' href='#'>
                                                                    <i class='fa fa-pencil'></i></a>
                                                            </td><td><a class='pull-right dropdown-toggle immunization-delete-row' data-toggle='dropdown' href=#'>
                                                            <i class='i i-trashcan'></a></div></div></td>")
  $(event.currentTarget).parents('tr').prev().find('a.immunization-delete-row').bind('click', deleteImmunizationRow)
  bindClickEventToPencil()

editAssessmentSuccess = (event, data) ->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').prev().removeClass('hide')
  $(event.currentTarget).parents('tr').prev().addClass('assessment-row-ck')
  $(event.currentTarget).parents('tr').prev().attr('url', "/customers/#{data.customer_id}/health_assessments/#{data.health_assessment.id}")
  $(event.currentTarget).parents('tr').prev().html("<td>#{data.health_assessment.health_assessment_id}</td><td>#{data.request_date}</td>
                                                                <td>#{data.health_assessment.assessment_type}</td>
                                                                <td>#{data.enterprise_name}</td>
                                                                <td>#{data.status_message}</td>
                                                                <td><a class='pull-right dropdown-toggle edit-pencil' data-toggle='dropdown' href='#'>
                                                                      <i class='fa fa-pencil'></i></a>
                        </td><td><a class='pull-right dropdown-toggle assessment-delete-row' data-toggle='dropdown' href=#><i class='i i-trashcan'></a></div></div></td>
                        ")
  $(event.currentTarget).parents('tr').prev().find('a.assessment-delete-row').bind('click', deleteAssessmentRow)
  bindClickEventToPencil()
  bindClickEventToAssessmentRow()

editMedicationSuccess = (event, data) ->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').prev().removeClass('hide')
  medication_active_html_classes = addMedicationActiveLogo data
  $(event.currentTarget).parents('tr').prev().html("<td>
                                    #{data.medication.name}
                                  </td>
                                  <td>
                                    #{data.medication.medication_type}
                                  </td>
                                  <td>
                                    #{data.parsed_date}
                                  </td>
                                  <td>
                                    #{data.medication.dose_quantity}
                                  </td>
                                  <td>
                                    #{data.medication.rate_quantity}
                                  </td>
                                  <td>
                                    #{data.medication.prescriber_name}
                                  </td>
                                   <td><a class=active> <i class='#{medication_active_html_classes}'></i> </a></td>
                                    <td>
                                    <a class='pull-right dropdown-toggle edit-pencil' data-toggle='dropdown' href='#'>
                                      <i class='fa fa-pencil'></i>
                                    </a>
                                  </td><td>
                                    <a class='pull-right dropdown-toggle medication-delete-row' data-toggle='dropdown' href='#'>
                                      <i class='i i-trashcan'></i>
                                    </a></div></div>
                                  </td>")
  $(event.currentTarget).parents('tr').prev().find('a.medication-delete-row').bind('click', deleteMedicationRow)
  bindClickEventToPencil()

editFamilyMedicalHistorySuccess = (event, data) ->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').prev().removeClass('hide')
  fmh_age = data.family_medical_history.age
  age = if fmh_age is null then '-' else fmh_age
  $(event.currentTarget).parents('tr').prev().html("
            <td>
              #{data.family_medical_history.name}
            </td>
            <td>
              #{data.family_medical_history.relation}
            </td>
            <td>
              #{age}
            </td>
            <td>
              #{data.family_medical_history.status}
            </td>
            <td>
              #{data.family_medical_history.medical_condition_1}              
            </td>
            <td>
              <a class='pull-right dropdown-toggle edit-pencil' data-toggle='dropdown' href='#'>
                <i class='fa fa-pencil'></i>
              </a>
            </td><td>
              <a class='pull-right dropdown-toggle family-medical-history-delete-row' data-toggle='dropdown' href='#'>
                <i class='i i-trashcan'></i>
              </a></div></div>
            </td>
            ")
  $(event.currentTarget).parents('tr').prev().find('a.family-medical-history-delete-row').bind('click',
    deleteFamilyMedicalHistoryRow)
  bindClickEventToPencil()

submitEditAllergyForm = (event) ->
  allery_row = $(event.currentTarget).parents('tr')
  customer_id = allery_row.attr('customer_id')
  customer_allergy_id = allery_row.attr('customer_allergy_id')
  name = allery_row.find('.allergy_name').val()
  reaction = allery_row.find('.allergy_reaction').val()
  severity = allery_row.find('.allergy_customer_allergies_severity').val()
  $.ajax
    type: "PATCH"
    url: "/customers/#{customer_id}/customers_allergies/#{customer_allergy_id}"
    data:
      allergy:
        name: name
        reaction: reaction
        customer_allergies:
          severity: severity

    success: (data, status, xhr) ->
      editAllergySuccess(event, data)

submitEditImmunizationForm = (event) ->
  immunization_row = $(event.currentTarget).parents('tr')
  customer_id = immunization_row.attr('customer_id')
  immunization_id = immunization_row.attr('immunization_id')
  name = immunization_row.find('.immunization_name').val()
  type = immunization_row.find('.immunization_immunization_type').val()
  date = immunization_row.find('.immunization_customer_immunizations_date').val()
  dosage = immunization_row.find('.immunization_customer_immunizations_dosage').val()
  instructions = immunization_row.find('.immunization_customer_immunizations_instructions').val()
  $.ajax
    type: "PATCH"
    url: "/customers/#{customer_id}/customers_immunizations/#{immunization_id}"
    data:
      immunization:
        name: name
        immunization_type: type
        customer_immunizations:
          date: date
          dosage: dosage
          instructions: instructions

    success: (data, status, xhr) ->
      editImmunizationSuccess(event, data)

submitEditAssessmentForm = (event) ->
  assessment_row = $(event.currentTarget).parents('tr')
  customer_id = assessment_row.attr('customer_id')
  assessment_id = assessment_row.attr('health_assessment_id')
  request_date = assessment_row.find('.health_assessment_request_date').val()
  package_type = assessment_row.find('.health_assessment_package_type').val()
  assessment_type = assessment_row.find('.health_assessment_assessment_type').val()
  status = assessment_row.find('.health_assessment_status').val()
  enterprise_id = assessment_row.find('.health_assessment_enterprise_id').val()
  $.ajax
    type: "PATCH"
    url: "/customers/#{customer_id}/health_assessments/#{assessment_id}"
    data:
      health_assessment:
        request_date: request_date
        assessment_type: assessment_type
        package_type: package_type
        status: status
        enterprise_id: enterprise_id

    success: (data, status, xhr) ->
      editAssessmentSuccess(event, data)

submitEditMedicationForm = (event) ->
  medication_row = $(event.currentTarget).parents('tr')
  customer_id = medication_row.attr('customer_id')
  medication_id = medication_row.attr('medication_id')
  medication_name = medication_row.find('.medication_name').val()
  medication_type = medication_row.find('.medication_medication_type').val()
  medication_date = medication_row.find('.medication_date').val()
#  medication_instructions = medication_row.find('.medication_instructions').val()
  medication_dose_quantity = medication_row.find('.medication_dose_quantity').val()
  medication_rate_quantity = medication_row.find('.medication_rate_quantity').val()
  medication_active = medication_row.find('.medication-active-state').val()
  prescriber_name = medication_row.find('.prescriber_name').val()
  $.ajax
    type: "PATCH"
    url: "/customers/#{customer_id}/customers_medications/#{medication_id}"
    data:
      medication:
        name: medication_name
        medication_type: medication_type
        date: medication_date
        dose_quantity: medication_dose_quantity
        rate_quantity: medication_rate_quantity
        active: medication_active
        prescriber_name: prescriber_name

    success: (data, status, xhr) ->
      editMedicationSuccess(event, data)

submitEditFamilyMedicalHistoryForm = (event) ->
  family_medical_history_row = $(event.currentTarget).parents('tr')
  customer_id = family_medical_history_row.attr('customer_id')
  family_medical_history_id = family_medical_history_row.attr('family_medical_history_id')
  relation = family_medical_history_row.find('.family_medical_history_relation').val()
  name = family_medical_history_row.find('.family_medical_history_name').val()
  age = family_medical_history_row.find('.family_medical_history_age').val()
  status = family_medical_history_row.find('.family_medical_history_status').val()
  medical_condition_1 = family_medical_history_row.find('.family_medical_history_medical_condition_1').val()
  medical_condition_2 = family_medical_history_row.find('.family_medical_history_medical_condition_2').val()
  medical_condition_3 = family_medical_history_row.find('.family_medical_history_medical_condition_3').val()
  $.ajax
    type: "PATCH"
    url: "/customers/#{customer_id}/customers_family_medical_histories/#{family_medical_history_id}"
    data:
      family_medical_history:
        name: name
        relation: relation
        age: age
        status: status
        medical_condition_1: medical_condition_1
        medical_condition_2: medical_condition_2
        medical_condition_3: medical_condition_3

    success: (data, status, xhr) ->
      editFamilyMedicalHistorySuccess(event, data)

submitEditPromoCodeHistoryForm = (event) ->
  promo_code_history_row = $(event.currentTarget).parents('tr')
  customer_id = promo_code_history_row.attr('customer_id')
  code = promo_code_history_row.attr('code')
  health_id = promo_code_history_row.attr('health_assessment_id')
  $.ajax
    type: "PATCH"
    url: "/customers/#{customer_id}"
    data:
      promo_code_history:
        code: code
        health_assessment_id: health_id
    success: (data, status, xhr) ->
      editPromoCodeHistorySuccess(event, data)

allergySelect = ->
  $('.allergy-select').change (event) ->
    $.ajax
      type: 'GET'
      url: "/customers_allergies/#{$(@).val()}"
      success: (data, status, xhr) ->
        $(event.currentTarget).parents('tr').find('.allergy_reaction').val(data.allergy.reaction)

allergySelect()

assessmentRowClick = (event) ->
  window.location = $(event.currentTarget).attr('url')
  return false

$('.assessment-row-ck').click (event) ->
  assessmentRowClick(event)

bindClickEventToAssessmentRow = ->
  $('.assessment-row-ck').bind('click', assessmentRowClick)

$('.edit-pencil').click (event) ->
  event.stopPropagation()
  editRowOnLoad event

bindClickEventToPencil = ->
  $('.edit-pencil').bind('click', editRowOnLoad)
  $('textarea').autosize()

bindEventToAllergyCancelButton = ->
  $('.allergy-cancel-row-btn').bind('click', cancelRow)

bindEventOnSaveBtnAllergy = ->
  $(".save-edit-allergy").bind('click', submitEditAllergyForm)

bindEventToImmunizationCancelButton = ->
  $('.immunization-cancel-row-btn').bind('click', cancelRow)

bindEventOnSaveBtnImmunization = ->
  $(".save-edit-immunization").bind('click', submitEditImmunizationForm)


bindEventToAssessmentCancelButton = ->
  $('.assessment-cancel-row-btn').bind('click', cancelRow)

bindEventOnSaveBtnAssessment = ->
  $(".assessment-save-row-btn").bind('click', submitEditAssessmentForm)

bindEventToMedicationCancelButton = ->
  $('.medication-cancel-row-btn').bind('click', cancelRow)

bindEventOnSaveBtnMedication = ->
  $(".medication-save-row-btn").bind('click', submitEditMedicationForm)

bindEventToFamilyMedicalHistoryCancelButton = ->
  $('.family-medical-history-cancel-row-btn').bind('click', cancelRow)

bindEventToPromoCodeHistoryCancelButton = ->
  $('.promo-code-history-cancel-row-btn').bind('click', cancelRow)

bindEventOnSaveBtnFamilyMedicalHistory = ->
  $(".family-medical-history-save-row-btn").bind('click', submitEditFamilyMedicalHistoryForm)

bindEventOnSaveBtnPromoCodeHistory = ->
  $(".promo-code-history-save-row-btn").bind('click', submitEditPromoCodeHistoryForm)

bindChangeEventOnSelectAllergies = ->
  $('.allergy-select').bind('change', allergySelect)

addMedicationActiveLogo = (data) ->
  if data.medication.active
    "fa fa-check text-success text-active"
  else
    "fa fa-times text-active text-danger"

#creating family medical history form
$("#create_family_medical_history").click ->
  $("#reset_family_medical_history_btn").click()
  $("#family_medical_history_new_form").removeClass('hide')

#creating promocode health assessment history form
$("#create_promo_code_history").click ->
  $("#reset-promo_code-health_assessment-history-row-btn").click()
  $("#health_assessment_promo_code_history_new_form").removeClass('hide')
  $("#health_assessment_promo_code_code").removeClass('parsley-error')
  $("#health_assessment_promo_code_code").parsley().removeError()
  $("#health_assessment_promo_code_health_assessment_id").removeClass('parsley-error')
  $("#health_assessment_promo_code_health_assessment_id").parsley().removeError()


$("#new_family_medical_history").bind "ajax:success", (event, data, status, xhr) ->
  $("#family_medical_history_new_form").addClass('hide')
  relations = ['Father', 'Mother', 'Brother', 'Sister', 'Son', 'Daughter', 'Grandfather', 'Grandmother']
  status_fields = ['yes', 'no']
  window.location.hash = "fh_redirect"
  window.location.reload()
  $(document).ready ->
    is_fh_redirect = if window.location.hash.indexOf('fh_redirect') then true else false
    if is_fh_redirect
      setTimeout (->
        $('#customer_info_tile').click()
        $('#family_history').click()
        return
      ), 5000
    return

$('#family_medical_history_cancel_btn').click ->
  $("#family_medical_history_new_form").addClass('hide')

$('#promo_code_history_cancel_btn').click ->
  $("#health_assessment_promo_code_history_new_form").addClass('hide')
  $("#health_assessment_promo_code_code").removeClass('parsley-error')
  el = $('#health_assessment_promo_code_code').parsley();
  el.manageErrorContainer();
  $(el.ulError).empty()
  $("#health_assessment_promo_code_health_assessment_id").removeClass('parsley-error')
  $("#health_assessment_promo_code_health_assessment_id").parsley().removeError()
  el = $('#health_assessment_promo_code_health_assessment_id').parsley();
  el.manageErrorContainer();
  $(el.ulError).empty()

#creating Medication form wrappers
$("#create_medication").click ->
  $("#reset_medication_btn").click()
  $("#medication_new_form").removeClass('hide')

$("#new_medication").bind "ajax:success", (event, data, status, xhr) ->
  $("#medication_new_form").addClass('hide')
  medication_date = if (data.date is 'None') then '' else data.date
  medication_active_html_classes = addMedicationActiveLogo data
  medication_types = ['Liquid', 'Tablet']
  medication_row = "
                              <tr>
                                <td>
                                  #{data.medication.name}
                                </td>
                                <td>
                                  #{data.medication.medication_type}
                                </td>
                                <td>
                                  #{data.parsed_date}
                                </td>
                                <td>
                                  #{data.medication.dose_quantity}
                                </td>
                                <td>
                                  #{data.medication.rate_quantity}
                                </td>
                                <td>
                                  #{data.medication.prescriber_name}
                                </td>
                                <td><a class=active> <i class='#{medication_active_html_classes}'></i> </a></td>
                                  <td>
                                  <a class='pull-right dropdown-toggle edit-pencil' data-toggle='dropdown' href='#'>
                                    <i class='fa fa-pencil'></i>
                                  </a></td><td>
                                  <a class='pull-right dropdown-toggle medication-delete-row' data-toggle='dropdown' href='#'>
                                    <i class='i i-trashcan'></i>
                                  </a>
                                  </div></div>
                                  </td>
                              </tr>

                              <tr class='edit_medication_row hide' medication_id=#{data.medication.id} customer_id=#{data.customer_id}>
                              <td>
                              <input class='form-control medication_name' placeholder='Medication Name'  name = 'medication[name]' type='text' value=#{data.medication.name}>
                              </td>
                              <td>
                              <select class='form-control medication_medication_type' placeholder='Type'>
                #{for type in medication_types
    if type is data.medication.medication_type then "<option selected=selected value=#{type}>#{type}</option>" else "<option value=#{type}>#{type}</option>"
  }
                              </td>
                              <td>
                              <input class='form-control datepicker medication_date' data-date-format='dd-mm-yyyy' placeholder='dd-mm-yyyy' type='text' value=#{medication_date} >
                              </td>
                              <td>
                              <input class='form-control medication_dose_quantity' placeholder='Dose quantity' type='text' value=#{data.medication.dose_quantity}>
                              </td>
                              <td>
                              <input class='form-control medication_rate_quantity' placeholder='Rate quantity' type='text' value=#{data.medication.rate_quantity}>
                              </td>
                              <td>
                              <input class='form-control prescriber_name' placeholder='prescriber name' type='text' value=#{data.medication.prescriber_name}>
                              </td>
                              <td>
                                <select class='medication-active-state form-control'>
                                  <option value='true' #{'selected = selected' if data.medication.active == true}>yes</option>
                                  <option value='false' #{'selected = selected' if data.medication.active == false}>no</option>
                                </select>
                              </td>
                              <td >
                              <input class='btn btn-sm small-btn btn-primary medication-save-row-btn save-edit-medication' type='submit' value='save'>
                              </td>
                              <td>
                              <a class='btn btn-sm small-btn btn-danger medication-cancel-row-btn' >cancel</a>
                              <input class='hide reset-medication-row-btn' type='reset'>
                              </td>
                            </tr>"
  $('#medications_table tbody tr').eq(0).after(medication_row)
  $('#medications_table tbody tr').eq(0).next().find('a.medication-delete-row').bind('click', deleteMedicationRow)
  bindClickEventToPencil()
  bindEventToMedicationCancelButton()
  bindEventOnSaveBtnMedication()
  $(".datepicker").datepicker()

$('#medication_cancel_btn').click ->
  $("#medication_new_form").addClass('hide')

#Creating Allergies form wrappers
$("#create_allergy").click ->
  $("#reset_allergy_btn").click()
  $("#allergy_new_form").removeClass('hide')

$("#new_allergy").bind "ajax:success", (event, data, status, xhr) ->
  $("#allergy_new_form").addClass('hide')
  allergy_reaction = data.allergy.reaction
  allergy_row = "<tr><td> #{data.allergy.name} </td>
                                                              <td> #{data.allergy.reaction} </td>
                                                              <td> #{data.customer_allergy.severity} </td><td><a class='pull-right dropdown-toggle edit-pencil' data-toggle='dropdown' href=#'>
                                                              <i class='fa fa-pencil'></i></a>
                                                              </td><td><a class='pull-right dropdown-toggle allergy-delete-row' data-toggle='dropdown' href=#'>
                                                              <i class='i i-trashcan'></a></div></div></td></tr>

                                                 <tr class='edit_allergy_row hide' customer_allergy_id=#{data.customer_allergy.id} customer_id=#{data.customer_allergy.customer_id}>
                                                  <td>
                                                    <input class='form-control allergy_name' name='allergy[name]' type='text' value=\'#{data.allergy.name}\'>
                                                    </td>
                                                   <td>
                                                    <input class='form-control allergy_reaction' name='allergy[reaction]' type='text' value=\'#{allergy_reaction}\'>
                                                  </td>
                                                  <td>
                                                    <input class='form-control allergy_customer_allergies_severity' name='allergy[customer_allergies][severity]' type='text' value=#{data.customer_allergy.severity}>
                                                  </td>
                                                  <td >
                                                    <input class='btn btn-sm small-btn btn-primary allergy-save-row-btn save-edit-allergy' name='commit' type='button' value='save'>
                                                  </td><td>
                                                    <a class='btn btn-sm small-btn btn-danger allergy-cancel-row-btn'>cancel</a>
                                                    <input class='hide reset-allergy-row-btn' type='reset'>
                                                  </td>
                                                 </tr>
                                                  "
  $('#allergies_table tbody tr').eq(0).after(allergy_row)
  $('#allergies_table tbody tr').eq(0).next().find('a.allergy-delete-row').bind('click', deleteAllergyRow)
  bindClickEventToPencil()
  bindEventToAllergyCancelButton()
  bindEventOnSaveBtnAllergy()
  bindChangeEventOnSelectAllergies()

$('#allergy_cancel_btn').click ->
  $("#allergy_new_form").addClass('hide')

#Creating Immunizations form wrappers
$("#create_immunization").click ->
  $("#reset_immunization_btn").click()
  $("#immunization_new_form").removeClass('hide')


$("#new_immunization").bind "ajax:success", (event, data, status, xhr) ->
  $("#immunization_new_form").addClass('hide')
  immunization_date = if (data.parsed_date is 'None') then '' else data.parsed_date
  immunization_row = "<tr><td> #{data.immunization.name} </td>
                                                                <td> #{data.immunization.immunization_type} </td>
                                                                <td> #{data.date} </td>
                                                                <td> #{data.customer_immunization.dosage} </td>
                                                                <td> #{data.customer_immunization.instructions} </td>
                                                                <td><a class='pull-right dropdown-toggle edit-pencil' data-toggle='dropdown' href=#'>
                                                                <i class='fa fa-pencil'></i></a>
                                                                </td><td><a class='pull-right dropdown-toggle immunization-delete-row' data-toggle='dropdown' href=#'>
                                                                <i class='i i-trashcan'></a></div></div></td></tr>

                                            <tr class='edit_immunization_row hide' immunization_id=#{data.immunization.id} customer_id=#{data.customer_immunization.customer_id}>
                                            <td>
                                            <textarea class='form-control immunization_name' name='immunization[name]' type='text' >#{data.immunization.name}</textarea>
                                            </td>
                                            <td>
                                            <textarea class='form-control immunization_immunization_type' name='immunization[immunization_type]' type='text' >#{data.immunization.immunization_type}</textarea>
                                            </td>
                                            <td>
                                            <input class='form-control immunization_customer_immunizations_date datepicker-input datepicker' data-date-format='dd-mm-yyyy' placeholder='dd-mm-yyyy' name='immunization[customer_immunizations][date]' type='text' value=#{immunization_date}>
                                            </td>
                                            <td>
                                              <input class='form-control immunization_customer_immunizations_dosage' name='immunization[customer_immunizations][dosage]' type='text' value=#{data.customer_immunization.dosage}>
                                              </td>
                                            <td>
                                              <textarea class='form-control immunization_customer_immunizations_instructions' name='immunization[customer_immunizations][instructions]' type='text'>#{data.customer_immunization.instructions}</textarea>
                                              </td>
                                            <td >
                                            <input class='btn btn-sm small-btn btn-primary immunization-save-row-btn save-edit-immunization' name='commit' type='button' value='save'>
                                            </td><td>
                                            <a class='btn btn-sm small-btn btn-danger immunization-cancel-row-btn'>cancel</a>
                                            <input class='hide reset-immunization-row-btn' type='reset'>
                                            </td>
                                            </tr>
                                          "
  $('#immunizations_table tbody tr').eq(0).after(immunization_row)
  $('#immunizations_table tbody tr').eq(0).next().find('a.immunization-delete-row').bind('click', deleteImmunizationRow)
  bindClickEventToPencil()
  bindEventToImmunizationCancelButton()
  bindEventOnSaveBtnImmunization()
  $(".datepicker").datepicker()

$('#immunization_cancel_btn').click ->
  $("#immunization_new_form").addClass('hide')


#Creating HealthAssessments form wrappers
$("#create_assessment").click ->
  $("#reset_assessment_btn").click()
  $("#assessment_new_form").removeClass('hide')

$("#new_health_assessment_promo_code").bind "ajax:success", (event, data, status, xhr) ->
  $("#health_assessment_promo_code_history_new_form").addClass('hide')
  $('#promo_codes_histories_table tbody tr').eq(0).after(data)
  $('#promo_codes_histories_table tbody tr').eq(0).next().find('a.assessment-delete-row').bind('click', deleteAssessmentRow)
  bindClickEventToPencil()
  bindEventToAssessmentCancelButton()
  bindEventOnSaveBtnAssessment()
  bindClickEventToAssessmentRow()
  $(".datepicker").datepicker()



$("#new_health_assessment_promo_code").bind "ajax:error", (xhr, status,error) ->

  if(JSON.parse(status.responseText).msg)=='Invalid Promo Code'
    $("#health_assessment_promo_code_code").addClass('parsley-error')
    el = $('#health_assessment_promo_code_code').parsley();
    el.manageErrorContainer();
    $(el.ulError).empty()
    el.addError({error: 'Invalid PromoCode'});
  else
    $("#health_assessment_promo_code_health_assessment_id").addClass('parsley-error')
    el = $('#health_assessment_promo_code_health_assessment_id').parsley();
    el.manageErrorContainer();
    $(el.ulError).empty()
    el.addError({error: 'Invalid HealthAssessmentID'});

$("#new_health_assessment").bind "ajax:success", (event, data, status, xhr) ->
  $("#assessment_new_form").addClass('hide')
  assessment_date = if (data.parsed_date is 'None') then '' else data.parsed_date
  assessment_status = ['requested', 'sample_collection', 'test_phase', 'test_results', 'update_emr', 'second_review',
                       'done']
  assessment_row = "<tr class='assessment-row-ck' url=/customers/#{data.customer_id}/health_assessments/#{data.health_assessment.id}>
                                                                  <td>#{data.health_assessment.health_assessment_id}</td>
                                                                  <td> #{data.request_date} </td>
                                                                  <td> #{data.health_assessment.assessment_type} </td>
                                                                  <td> #{data.enterprise_name} </td>
                                                                  <td> #{data.status_message} </td>
                                                                  <td><a class='pull-right dropdown-toggle edit-pencil' data-toggle='dropdown' href=#'>
                                                                  <i class='fa fa-pencil'></i></a>
                                                                  </td><td><a class='pull-right dropdown-toggle assessment-delete-row' data-toggle='dropdown' href=#'>
                                                                  <i class='i i-trashcan'></a></div></div></td>
                                                                                              </tr>
                                    <tr class='edit_health_assessment_row hide' health_assessment_id=#{data.health_assessment.id} customer_id=#{data.customer_id}>
                                  <td>#{data.health_assessment.health_assessment_id}</td>
                                  <td>
                                   <input class='form-control datepicker-input datepicker health_assessment_request_date' data-date-format='dd-mm-yyyy' placeholder='dd-mm-yyyy' type='text' value=#{assessment_date}>
                                  </td>
                                    <td>
                                  <select class='form-control health_assessment_assessment_type'>
                                      <option value='Body' #{'selected = selected' if data.health_assessment.assessment_type == 'Body'}>Body</option>
                                      <option value='Dental' #{'selected = selected' if data.health_assessment.assessment_type == 'Dental'}>Dental</option>
                                      <option value='Vision' #{'selected = selected' if data.health_assessment.assessment_type == 'Vision'}>Vision</option></select>
                                  </td>
                                  <td><select  class='form-control health_assessment_enterprise_id'>
                                  #{for enterprise in data.enterprise
      if enterprise  is data.enterprise_name then "<option selected=selected value=#{enterprise.id}>#{enterprise.name}</option>" else "<option value=#{enterprise.id}>#{enterprise.name}</option>"
    }
                                  </select>
                                  </td>
                                  <td>
                                  <select class='form-control health_assessment_status'>
                                  #{for status in assessment_status
    if status is data.health_assessment.status then "<option selected=selected value=#{status}>#{status}</option>" else "<option value=#{status}>#{status}</option>"
  }
                                  </select>
                                  </td>
                                  <td >
                                  <input class='btn btn-sm small-btn btn-primary assessment-save-row-btn'  name='commit' type='submit' value='save'>
                                  </td><td>
                                  <a class='btn btn-sm small-btn btn-danger assessment-cancel-row-btn'>cancel</a>
                                  <input class='hide reset-assessment-row-btn' type='reset'>
                                  </td>
                                  </tr>
                                    "
  $('#assessments_table tbody tr').eq(0).after(assessment_row)
  $('#assessments_table tbody tr').eq(0).next().find('a.assessment-delete-row').bind('click', deleteAssessmentRow)
  bindClickEventToPencil()
  bindEventToAssessmentCancelButton()
  bindEventOnSaveBtnAssessment()
  bindClickEventToAssessmentRow()
  $(".datepicker").datepicker()

$('#assessment_cancel_btn').click ->
  $("#assessment_new_form").addClass('hide')

#Update Individual fields
$('.allergy-cancel-row-btn').click (event) ->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').prev().prev().removeClass('hide')

$(".edit_allergy").bind "ajax:success", (event, data, status, xhr) ->
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  $(event.currentTarget).prev().html("<td>#{data.allergy.name}</td>
                                                        <td>#{data.allergy.reaction}</td><td>#{data.customer_allergy.severity}</td>
                                                          <td><a class='pull-right dropdown-toggle edit-pencil' data-toggle='dropdown' href='#'>
                                                                <i class='fa fa-pencil'></i></a>
                                                          </td><td><a class='pull-right dropdown-toggle allergy-delete-row' data-toggle='dropdown' href=#>
                                                          <i class='i i-trashcan'></a></div></div></td> ")
  $(event.currentTarget).prev().find('a.allergy-delete-row').bind('click', deleteAllergyRow)
  bindClickEventToPencil()

$('.immunization-cancel-row-btn').click (event) ->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').prev().prev().removeClass('hide')

$(".edit_immunization").bind "ajax:success", (event, data, status, xhr) ->
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  $(event.currentTarget).prev().html("<td>#{data.immunization.name}</td>
                                                          <td>#{data.immunization.immunization_type}</td><td>#{data.date}</td>
                                                          <td>#{data.customer_immunization.dosage}</td><td>#{data.customer_immunization.instructions}</td>
                                                          <td><a class='pull-right dropdown-toggle edit-pencil' data-toggle='dropdown' href='#'>
                                                                  <i class='fa fa-pencil'></i></a>
                                                          </td><td><a class='pull-right dropdown-toggle immunization-delete-row' data-toggle='dropdown' href=#'>
                                                                    <i class='i i-trashcan'></a></div></div></td>")
  $(event.currentTarget).prev().find('a.immunization-delete-row').bind('click', deleteImmunizationRow)
  bindClickEventToPencil()

$('.assessment-cancel-row-btn').click (event) ->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').prev().prev().removeClass('hide')

$(".edit_health_assessment").bind "ajax:success", (event, data, status, xhr) ->
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  $(event.currentTarget).prev().attr('url', "/customers/#{data.customer_id}/health_assessments/#{data.health_assessment.id}")
  $(event.currentTarget).prev().addClass('assessment-row-ck')
  $(event.currentTarget).prev().html("<td>#{data.health_assessment.health_assessment_id}</td><td> #{data.request_date} </td>
                                                                    <td> #{data.health_assessment.assessment_type} </td>
                                                                    <td> #{data.enterprise_name} </td>
                                                                    <td> #{data.status_message} </td>
                                                                    <td><a class='pull-right dropdown-toggle edit-pencil' data-toggle='dropdown' href=#'>
                                                                    <i class='fa fa-pencil'></i></a>
                                                                    </td><td><a class='pull-right dropdown-toggle assessment-delete-row' data-toggle='dropdown' href=#'>
                                                                    <i class='i i-trashcan'></a></div></div></td>
                                                                    ")
  $(event.currentTarget).prev().find('a.assessment-delete-row').bind('click', deleteAssessmentRow)
  bindClickEventToPencil()
  bindClickEventToAssessmentRow()

$('.medication-cancel-row-btn').click (event) ->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').prev().prev().removeClass('hide')

$(".edit_medication").bind "ajax:success", (event, data, status, xhr) ->
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  medication_active_html_classes = addMedicationActiveLogo data
  $(event.currentTarget).prev().html("
          <td>
            #{data.drug_name}
          </td>
          <td>
            #{data.medication.medication_type}
          </td>
          <td>
            #{data.parsed_date}
          </td>
          <td>
            #{data.medication.dose_quantity}
          </td>
          <td>
            #{data.medication.rate_quantity}
          </td>
          <td>
            #{data.medication.prescriber_name}
          </td>
           <td><a class=active> <i class='#{medication_active_html_classes}'></i> </a></td>
           <td>
            <a class='pull-right dropdown-toggle edit-pencil' data-toggle='dropdown' href='#'>
              <i class='fa fa-pencil'></i>
            </a>
          </td><td>
            <a class='pull-right dropdown-toggle medication-delete-row' data-toggle='dropdown' href='#'>
              <i class='i i-trashcan'></i>
            </a></div></div>
          </td>
          ")
  $(event.currentTarget).prev().find('a.medication-delete-row').bind('click', deleteMedicationRow)
  bindClickEventToPencil()

$('.family-medical-history-cancel-row-btn').click (event) ->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').prev().prev().removeClass('hide')

$('.promo-code-history-cancel-row-btn').click (event) ->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').prev().prev().removeClass('hide')

$(".edit_health_assessment_promo_code").bind "ajax:success", (event, data, status, xhr) ->
  $(event.currentTarget).next().addClass('hide')
  $('#promo_codes_histories_table tbody tr').eq(0).after(data)
  $('#promo_codes_histories_table tbody tr').eq(0).next().find('a.assessment-delete-row').bind('click', deleteAssessmentRow)
  bindClickEventToPencil()
  bindEventToAssessmentCancelButton()
  bindEventOnSaveBtnAssessment()
  bindClickEventToAssessmentRow()

$(".edit_family_medical_history").bind "ajax:success", (event, data, status, xhr) ->
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  fmh_age = data.family_medical_history.age
  age = if fmh_age is null then '-' else fmh_age
  $(event.currentTarget).prev().html("
            <td>
              #{data.family_medical_history.name}
            </td>
            <td>
              #{data.family_medical_history.relation}
            </td>
            <td>
              #{age}
            </td>
            <td>
              #{data.family_medical_history.status}
            </td>
            <td>
              #{data.checked_values}
            </td>
            <td>
              <a class='pull-right dropdown-toggle edit-pencil' data-toggle='dropdown' href='#'>
                <i class='fa fa-pencil'></i>
              </a>
            </td><td>
              <a class='pull-right dropdown-toggle family-medical-history-delete-row' data-toggle='dropdown' href='#'>
                <i class='i i-trashcan'></i>
              </a></div></div>
            </td>
            ")
  $(event.currentTarget).prev().find('a.family-medical-history-delete-row').bind('click', deleteFamilyMedicalHistoryRow)
  bindClickEventToPencil()

deleteAssessmentRow = (event) ->
  event.stopPropagation()
  confirmed = confirm('Are you sure')
  if confirmed
    assessment_row = $(event.currentTarget).parents('tr')
    edit_form = if assessment_row.next().is('form') then assessment_row.next().next() else $(event.currentTarget).parents("tr").next()
    customer_id = edit_form.attr('customer_id')
    assessment_id = edit_form.attr('health_assessment_id')
    $.ajax
      type: 'DELETE'
      url: "/customers/#{customer_id}/health_assessments/#{assessment_id}"

      success: (data, status, xhr) ->
        assessment_row.remove()
        edit_form.remove()

$('.assessment-delete-row').click (event) ->
  deleteAssessmentRow(event)

deleteAllergyRow = (event) ->
  confirmed = confirm('Are you sure')
  if confirmed
    allergy_row = $(event.currentTarget).parents('tr')
    edit_form = if allergy_row.next().is('form') then allergy_row.next().next() else $(event.currentTarget).parents("tr").next()
    customer_id = edit_form.attr('customer_id')
    customer_allergy_id = edit_form.attr('customer_allergy_id')
    $.ajax
      type: 'DELETE'
      url: "/customers/#{customer_id}/customers_allergies/#{customer_allergy_id}"
      success: (data, status, xhr) ->
        allergy_row.remove()
        edit_form.remove()

$('.allergy-delete-row').click (event) ->
  deleteAllergyRow(event)

deleteImmunizationRow = (event) ->
  confirmed = confirm('Are you sure')
  if confirmed
    immunization_row = $(event.currentTarget).parents('tr')
    edit_form = if immunization_row.next().is('form') then immunization_row.next().next() else $(event.currentTarget).parents("tr").next()
    customer_id = edit_form.attr('customer_id')
    immunization_id = edit_form.attr('immunization_id')
    $.ajax
      type: 'DELETE'
      url: "/customers/#{customer_id}/customers_immunizations/#{immunization_id}"
      success: (data, status, xhr) ->
        immunization_row.remove()
        edit_form.remove()

$('.immunization-delete-row').click (event) ->
  deleteImmunizationRow(event)

deleteMedicationRow = (event) ->
  confirmed = confirm('Are you sure')
  if confirmed
    medication_row = $(event.currentTarget).parents('tr')
    edit_form = if medication_row.next().is('form') then medication_row.next().next() else $(event.currentTarget).parents("tr").next()
    customer_id = edit_form.attr('customer_id')
    medication_id = edit_form.attr('medication_id')
    $.ajax
      type: 'DELETE'
      url: "/customers/#{customer_id}/customers_medications/#{medication_id}"
      success: (data, status, xhr) ->
        medication_row.remove()
        edit_form.remove()

$('.medication-delete-row').click (event) ->
  deleteMedicationRow(event)


deleteFamilyMedicalHistoryRow = (event) ->
  confirmed = confirm('Are you sure')
  if confirmed
    family_medical_history_row = $(event.currentTarget).parents('tr')
    edit_form = if family_medical_history_row.next().is('form') then family_medical_history_row.next().next() else $(event.currentTarget).parents("tr").next()
    customer_id = edit_form.attr('customer_id')
    family_medical_history_id = edit_form.attr('family_medical_history_id')
    $.ajax
      type: 'DELETE'
      url: "/customers/#{customer_id}/customers_family_medical_histories/#{family_medical_history_id}"
      success: (data, status, xhr) ->
        family_medical_history_row.remove()
        edit_form.remove()

$('.family-medical-history-delete-row').click (event) ->
  deleteFamilyMedicalHistoryRow(event)



showAppendedEditBranchRow = (event)->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').next().next().removeClass('hide')


showAppendedEditRow = (event)->
  $(event.currentTarget).parents('tr').addClass('hide')
  $(event.currentTarget).parents('tr').next().next().removeClass('hide')

$('.edit_provider_test').bind 'ajax:success', (event, data)->
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().html(data)
  $(event.currentTarget).prev().find('.edit-pencil').bind('click', showAppendedEditRow)
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  $('.providertest-delete-row').bind('click', deleteProvidertestRow)


$('.edit_provider').bind 'ajax:success', (event, data)->
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().html(data)
  $(event.currentTarget).prev().find('.edit-pencil').bind('click', showAppendedEditBranchRow)
  $(event.currentTarget).next().addClass('hide')
  $(event.currentTarget).prev().removeClass('hide')
  $('.providerbranch-delete-row').bind('click', deleteProviderRow)


$(document).on 'click', '.providertest-delete-row', (event) ->
  deleteProvidertestRow(event)

deleteProvidertestRow = (event) ->
  event.stopPropagation()
  confirmed = confirm('Are you sure')
  if confirmed
    provider_row = $(event.currentTarget).parents('tr')
    edit_form = if provider_row.next().is('form') then provider_row.next().next() else $(event.currentTarget).parents("tr").next()
    provider_id = edit_form.attr('provider_id')
    providertest_id = edit_form.attr('provider_test_id')
    $.ajax
      type: 'DELETE'
      url: "/staff/provider_tests/#{providertest_id}"
      success: (data, status, xhr) ->
        provider_row.remove()
        edit_form.remove()

$('.providerbranch-delete-row').click (event) ->
  deleteProviderRow(event)

deleteProviderRow = (event) ->
  event.stopPropagation()
  confirmed = confirm('Are you sure')
  if confirmed
    provider_row = $(event.currentTarget).parents('tr')
    edit_form = if provider_row.next().is('form') then provider_row.next().next() else $(event.currentTarget).parents("tr").next()
    provider_id = edit_form.attr('provider_id')
    $.ajax
      type: 'DELETE'
      url: "/staff/providers/#{provider_id}"
      success: (data, status, xhr) ->
        provider_row.remove()
        edit_form.remove()

$(document).ready ->
  window.customerGrid = $('#customer_grid').dataTable
    'bProcessing': true
    'bServerSide': true
    'sAjaxSource': '/api/v1/customerzz'
    "sPaginationType": "full_numbers"
    "sScrollY": "370px"
    "bSort": false
    "oLanguage": {
      "sSearch": ""
    }
    "bStateSave": true
    "bLengthChange": true
    "bAutoWidth": false
#    "bScrollCollapse": true
#    "pagingType": "full_numbers"
#    "scrollY": 300,
#    "scrollX": true
    'aoColumns': [
      { 'mData': 'id'}
      {
        'mData': 'created_at'
        mRender: ( data, type, row ) -> return new Date(row.created_at).toLocaleDateString()
      }
      { 'mData': 'customer_id' }
      {
        'mData': 'first_name'
        mRender: ( data, type, row ) -> return row.first_name+' '+row.last_name
      }
      { 'mData': 'mobile_number' }
      { 'mData': 'email' }
      { 'mData': 'date_of_birth' }
      { 'mData': 'is_hypertensive' }
      { 'mData': 'is_diabetic' }
      { 'mData': 'is_obesity' }
      { 'mData': 'is_overweight' }
    ]
  return

$(document).ready ->
  $('#customer_grid tbody').on 'click', 'tr', ->
    window.location = '/customers/'+window.customerGrid._(this)[0].id
  return