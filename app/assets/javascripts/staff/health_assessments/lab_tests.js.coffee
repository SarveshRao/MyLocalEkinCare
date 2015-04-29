# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$("#edit_health_assessment").bind "ajax:success", (event, data, status,xhr) ->
  $("#Doctor_Name").text(data.health_assessment.doctor_name)
  $("#SAVE_DOCTOR").addClass('hide')
  $('#testing').removeClass('hide');
  $('#message').removeClass('hide');
  $('#Doctor_Name').removeClass('hide');


show_message = (msg) ->
  $('#message').show().fadeIn(2222,
    -> $("#Doctor_Name").addClass('hide')
  )
$ ->
$('#message').click ->
  show_message "you"
  $("#SAVE_DOCTOR").removeClass('hide')
  $("#message").addClass('hide')


#LabTests/TestComponents grid and CRUD operations starts here
window.deleteStandardRange = (standard_range_id) ->
  if confirm("Are you sure to delete standard range?")
    $.ajax
      type: 'DELETE'
      url: '/api/v1/enterprise/lab_test/test_component/standard_range/delete?id='+standard_range_id
      success: (data, status, xhr) ->
        $('#enterprise_test_components_table').dataTable().fnDestroy()
        showTestComponents($("#lab_test_id").val())
        applyMakeEditableToTestComponent()

applyMakeEditableToTestComponent = ->
  $( "#btnAddTestComponentOk").unbind( "click" )
  $('#enterprise_test_components_table').dataTable().makeEditable
    sHeaderTitle: "Add New Test Component"
    sAddNewRowButtonId: "btnAddTestComponent"
    sAddNewRowFormId: "testComponentFormId"
    sAddNewRowOkButtonId: "btnAddTestComponentOk",
    sAddNewRowCancelButtonId: "btnAddTestComponentCancel"
    sUpdateURL: '/api/v1/enterprise/lab_test/test_component/standard_range/update'
    sAddURL: '/api/v1/enterprise/lab_test/test_component/add'
    ajaxoptions: type: 'POST'
    'aoColumns': [
      {}
      {}
      null
      {}
      {}
      {}
      {}
    ]

showTestComponents = (lab_test_id) ->
  $('#testComponentFormId').find('#lab_test_id').val(lab_test_id)
  $('#testComponentFormId').find('#test_component_enterprise_id').val($("#enterprise_id").val())
  getTestComponentsUrl = '/api/v1/enterprise/lab_test/test_components'
  if lab_test_id != ''
    getTestComponentsUrl = getTestComponentsUrl + '?lab_test_id=' + lab_test_id
  window.testComponentsGrid = $('#enterprise_test_components_table').dataTable
    'bProcessing': true
    'bServerSide': true
    'sAjaxSource': getTestComponentsUrl
    "sPaginationType": "full_numbers"
    "sScrollY": "370px"
    "bSort": false
    'bDestroy': true
    "oLanguage": {
      "sSearch": ""
    }
    "bStateSave": true
    "bLengthChange": true
    "bAutoWidth": false
    'aoColumns': [
      {
        'mData': 'test_component_name',
        'sTitle': 'Test Component',
#        "sWidth": "10%"
      }
      {
        'mData': 'test_component_info',
        'sTitle': 'Info',
#        "sWidth": "37%"
      }
      {
        'mData': 'gender',
        'sTitle': 'Sex',
#        "sWidth": "1%"
      }
      {
        'mData': 'range_value1',
        'sTitle': 'Severe',
#        "sWidth": "13%"
      }
      {
        'mData': 'range_value2',
        'sTitle': 'Normal',
#        "sWidth": "13%"
      }
      {
        'mData': 'range_value3',
        'sTitle': 'Border',
#        "sWidth": "13%"
      }
      {
        'mData': 'range_value4',
        'sTitle': 'Severe',
#        "sWidth": "13%"
      }
      {
        'mData': 'id',
#        "sWidth": "1%",
        'mRender': (data, type, row) ->
          return '<a href="javascript:void(0);" onclick="window.deleteStandardRange('+data+')"><span class="i i-trashcan"></span></a>'
      }
    ]
    'fnCreatedRow': (nRow, aData, iDataIndex) ->
      $(nRow).attr 'id', aData.id
  $('#enterprise_lab_tests_panel').find('div.dataTables_filter input').attr('placeholder', 'Search for test components')
  $('#enterprise_lab_tests_panel').find('div.dataTables_filter').addClass('data-table-search')

window.initializeTestComponentsContent = (lab_test_id) ->
  $('#lab_test_content').hide()
  $('#test_component_content').show()
  showTestComponents(lab_test_id)
  applyMakeEditableToTestComponent()



window.viewTestComponents = (lab_test_id) ->
  $('#enterprise_lab_tests_table').dataTable().fnDestroy()
  window.initializeTestComponentsContent(lab_test_id)

window.deleteLabTest = (lab_test_id) ->
  if confirm("Are you sure to delete lab test?")
    $.ajax
      type: 'DELETE'
      url: '/api/v1/enterprise/lab_test/delete?id='+lab_test_id
      success: (data, status, xhr) ->
        $('#enterprise_lab_tests_table').dataTable().fnDestroy()
        showLabTests($("#enterprise_id").val())
        applyMakeEditable()

applyMakeEditable = ->
  $( "#btnAddLabTestOk").unbind( "click" )
  $('#enterprise_lab_tests_table').dataTable().makeEditable
    sHeaderTitle: "Add New Lab Test"
    sAddNewRowButtonId: "btnAddLabTest"
    sAddNewRowFormId: "labTestFormId"
    sAddNewRowOkButtonId: "btnAddLabTestOk",
    sAddNewRowCancelButtonId: "btnAddLabTestCancel"
    sUpdateURL: '/api/v1/enterprise/lab_test/update'
    sAddURL: '/api/v1/enterprise/lab_test/add'
    ajaxoptions: type: 'POST'
    'aoColumns': [
      {}
      {}
    ]

showLabTests = (enterprise_id) ->
  getLabTestsUrl = '/api/v1/enterprise/lab_tests?enterprise_id=' + enterprise_id
  window.labTestsGrid = $('#enterprise_lab_tests_table').dataTable
    'bProcessing': true
    'bServerSide': true
    'sAjaxSource': getLabTestsUrl
    "sPaginationType": "full_numbers"
    "sScrollY": "370px"
    "bSort": false
    'bDestroy': true
    "oLanguage": {
      "sSearch": ""
    }
    "bStateSave": true
    "bLengthChange": true
    "bAutoWidth": false
    'aoColumns': [
      {
        'mData': 'name',
        'sTitle': 'Name',
        "sWidth": "20%"
      }
      {
        'mData': 'info',
        'sTitle': 'Info',
        "sWidth": "60%"
      }
      {
        'mData': 'id'
        "sWidth": "10%"
        'mRender': (data, type, row) ->
          return '<a href="javascript:void(0);" onclick="window.deleteLabTest('+data+')"><span class="i i-trashcan"></span></a>'
      }
      {
        'mData': 'id'
        "sWidth": "10%"
        'mRender': (data, type, row) ->
          return '<a href="javascript:void(0);" onclick="window.viewTestComponents('+data+')">View Test Components</a>'
      }
    ]
    'fnCreatedRow': (nRow, aData, iDataIndex) ->
      $(nRow).attr 'id', aData.id
  $('#enterprise_lab_tests_panel').find('div.dataTables_filter input').attr('placeholder', 'Search for lab tests')
  $('#enterprise_lab_tests_panel').find('div.dataTables_filter').addClass('data-table-search')

window.initializeLabTestsContent = ->
  showLabTests($('#enterprise_id').val())
  applyMakeEditable()

$('#backToLabTest').click (event) ->
  window.showLabTestsContent()