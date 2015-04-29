$ ->
  $('#customer_list,#customer_list1,#customer_list2').dataTable
    "sDom": "<'row'<'col-sm-6' l><'col-sm-6' f>r>t<'row'<'col-sm-6'i><'col-sm-6 padder' p>"
    "sPaginationType": "full_numbers"
    "bFilter": true
    "aaSorting": [[0, "desc"]]
    "oLanguage":
      "sSearch": ""

  $('#customer_list').show()

  $('#promo_code_list').dataTable
    "sDom": "<'row'<'col-sm-6' l><'col-sm-6' f>r>t<'row'<'col-sm-6'i><'col-sm-6 padder' p>"
    "sPaginationType": "full_numbers"
    "bFilter": true
    "bSort": false
    "oLanguage":
      "sSearch": ""

  $('#promo_code_list').show()
  get_scroll_hgt = ->
    len = $("#promo_code_list_length").find("select").val()
    win_hgt = $(window).height()
    header_hgt = $("header").height()
    scroll_hgt = (win_hgt - header_hgt) - 15
    if len > "10"
      $("#content").addClass("promo_code_list_scroll").height scroll_hgt
    else
      $("#content").removeClass()
    return
  $(window).resize ->
    get_scroll_hgt()
    return
  $("#promo_code_list_length").find("select").on "change", ->
    get_scroll_hgt()
    return



  $('#health_assessments_list').dataTable
    "sDom": "<'row'<'col-sm-6' l><'col-sm-6' f>r>t<'row'<'col-sm-6'i><'col-sm-6 padder' p>"
    "sPaginationType": "full_numbers"
    "bFilter": true
    "aaSorting": [[0, "desc"]]
    "oLanguage":
      "sSearch": ""

  $('#health_assessments_list').show()

  $('div.dataTables_filter input').attr('placeholder', 'Search...')
  $('div.dataTables_filter').addClass('data-table-search')

