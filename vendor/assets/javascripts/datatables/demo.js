+function ($) {
  "use strict";

  $(function () {

    function setRowClass(nRow, aData, iDisplayIndex, iDisplayIndexFull){
      var url_val = aData['url']
      $(nRow).attr('url',url_val);
      $(nRow).addClass('customer-row');
    }

    function setClickable(){
      $('.customer-row').click(function(){
        window.location = $(this).attr('url');
        return false;
      });
    }

    // datatable
    $('[data-ride="datatables"]').each(function () {
      var oTable = $(this).dataTable({
        "bProcessing": true,
        "sDom": "<'row'<'col-sm-6' l><'col-sm-6' f>r>t<'row'<'col-sm-6'i><'col-sm-6 padder' p>",
        "sPaginationType": "full_numbers",
        "bFilter": true,
        "oLanguage": { "sSearch": "" },
        "serverSide": true,
        "processing": true,
        "aaSorting": [],
//        "ajax": '/health_assessments/all',
        "sAjaxDataProp": "aaData",
        "fnRowCallback": setRowClass,
        "fnDrawCallback": setClickable,
        "sAjaxSource": $('#health_assessments_data').data('source'),
        "aoColumns": [
//          { "mDataProp": "id", "sWidth": "5%"},
          { "mDataProp": "request_date", "sWidth": "20%" },
//          { "mDataProp": "customer_id", "sWidth": "10%" },
          { "mDataProp": "name", "sWidth": "20%" },
//          { "mDataProp": "type", "sWidth": "10%" },
          { "mDataProp": "assessment_type", "sWidth": "20%" },
//          { "mDataProp": "date", "sWidth": "10%" },
          { "mDataProp": "mobile_number", "sWidth": "20%" },
//          { "mDataProp": "paid", "sWidth": "10%" },
          { "mDataProp": "status_message", "sWidth": "20%" }
        ]
      });
      $('div.dataTables_filter input').attr('placeholder', 'Search...');
    });

//    $('#growthrate').length && $.ajax('js/datatables/growthrate.csv').done(function (re) {
//      var data = $.csv.toArrays(re);
//      $('#growthrate').html('<table cellpadding="0" cellspacing="0" border="0" class="table table-striped m-b-none" id="example"></table>');
//      $('#example').dataTable({
//        "aaData": data,
//        "bProcessing": true,
//        "sDom": "<'row'<'col-sm-6'l><'col-sm-6'f>r>t<'row'<'col-sm-6'i><'col-sm-6'p>>",
//        "iDisplayLength": 50,
//        "sPaginationType": "full_numbers",
//        "aoColumnDefs": [
//          { "bSearchable": false, "bVisible": false, "aTargets": [ 1 ] },
//          { "bVisible": false, "aTargets": [ 4 ] },
//          {
//            "mRender": function (data, type, row) {
//              return data + ' ' + '%';
//            },
//            "aTargets": [ 5 ]
//          },
//          {
//            "mRender": function (data, type, row) {
//
//              return '<i class="fa ' + (row[5] > 0 ? 'fa-sort-up text-success' : 'fa-sort-down text-danger') + '"></i>';
//            },
//            'bSortable': false,
//            "aTargets": [ 6 ]
//          },
//        ],
//        "aoColumns": [
//          { "sTitle": "Country or Area" },
//          { "sTitle": "Subgroup" },
//          { "sTitle": "Year" },
//          { "sTitle": "source", "sClass": "center" },
//          { "sTitle": "Unit", "sClass": "center" },
//          { "sTitle": "Value", "sClass": "center" },
//          { "sTitle": "", "sClass": "center" }
//        ]
//      });
//    });


  });
}(window.jQuery);
