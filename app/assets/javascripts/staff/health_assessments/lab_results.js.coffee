# labtests
$ ->
  assessment_id = $('#new_lab_result').attr('assessment_id')

  $('#notes_tile').click ->
    $('#notes_panel').show()

  rangeNotifierColorRow = (row) ->
    result_value_element = row.children().eq(2)
    result_ele = row.children().eq(3)
    range_ele = row.children().eq(4)
#    val=result_ele.text().trim()
#    if /^[a-zA-Z ]+$/.test(val)
#      result_val=val
#    else
#      result_val = result_ele.text().replace(/[\µ\%a-zA-Z\(\)\(/)\u03bc]*/g, '')
#      result_val = result_val.replace('10³', '')
#      result_val = result_val.replace('10^', '')
#    range_eles = range_ele.find('a')
#    range_eles_status = []
#    if result_val.trim().length isnt 0
#      for current_range_ele in range_eles
#        current_range = $(current_range_ele).text()
#        compare_literals = current_range.replace(/[\µ\%0-9\+\/\.\(\)a-zA-Z\s\%\u03bc]*/g, '')
#        if /[0-9]+/g.test(current_range)
#          if /\-/.test compare_literals
#            compare_literal_nums = current_range.replace(/[\µ\%\>\<\+\=\/\(\)a-zA-Z\s\%\u03bc]*/g, '')
#            eval_values = compare_literal_nums.split(/[-]/).filter(Boolean).sort((a, b) -> return a - b)
#            min_val = parseFloat(eval_values[0])
#            max_val = parseFloat(eval_values[1])
#            status = eval(min_val < result_val < max_val)
#            if status is false
#              status = (min_val is parseFloat(result_val)) || (max_val is parseFloat(result_val))
#          else
#            compare_literal_nums = current_range.replace(/[\µ\%\-\+\=\/\(\)a-zA-Z\s\%\u03bc]*/g, '')
#            if /[\>\<]+/.test compare_literals
#              eval_values = compare_literal_nums.split(/[><]/).filter(Boolean).sort()
#              min_val = parseFloat(eval_values[0])
#              max_val = parseFloat(eval_values[1])
#              status = eval(min_val < parseFloat(result_val) < max_val)
#
#            if /[\>|\<]+/.test compare_literals
#              if /[<]+/.test compare_literals
#                status = eval("#{result_val} #{compare_literal_nums}")
#              if /[>]+/.test compare_literals
#                status = eval("#{result_val} #{compare_literal_nums}")
#
#            compare_literals = current_range.replace(/[\µ\%0-9\>\<\=\/\.\(\)a-zA-Z\s\%\u03bc]*/g, '')
#            if /[\-|\+]+/.test compare_literals
#              compare_literal_nums = current_range.replace(/[\µ\%\-\>\<\+\/\(\)a-zA-Z\s\%\u03bc]*/g, '')
#              if /\-/.test compare_literals
#                status = eval("#{result_val} < #{compare_literal_nums}")
#              if /\+/.test compare_literals
#                status = eval("#{result_val} > #{compare_literal_nums}")
#
#          compare_literals = current_range.replace(/[\µ\%\>\<\+\/\(\)a-zA-Z\s\%\u03bc]*/g, '')
#          if status is false && /\=/.test compare_literals
#            result_exp = new RegExp(result_val.trim(), 'g')
#            status = result_exp.test current_range
#        else
#          res_val=result_val.toString().trim()
#          res_val=res_val.replace('null','').trim()
#          status = current_range.trim().toLowerCase() is res_val.toLowerCase()
#        range_eles_status.push(status)
#        if status == true
#          break

#      for range_ele_status, index in range_eles_status
#        if range_ele_status
#          standard_range_ele_class = $(range_eles[index]).attr('class')
#          if standard_range_ele_class.search('success') isnt -1
#            color_class = 'text-success'
#          if standard_range_ele_class.search('warning') isnt -1
#            color_class = 'text-warning'
#          if standard_range_ele_class.search('danger') isnt -1
#            color_class = 'text-danger'
#          result_ele.attr('class', color_class)
#        else
#          color_class = 'text-danger'
#          result_ele.attr('class', color_class)

    result_ele.attr('class', 'text-danger')
    range_eles = range_ele.find('a')
    for current_range_ele in range_eles
#      Write the updated logic here
#      Logic:
#        - try to identify if the standard_range contains any digits
#        - No => need to compare like a simple string
#        - Yes => need to consider
#          - removing white spaces
#          - ignore all characters other than (0-9.<>=+-)
#          - ignore all characters other than (0-9.-) if this contains - which means a range between
#          - check if starts with "<" or "<=" or ">" or ">="
#          - check if ends "+"
      current_range_value = current_range_ele.text.replace RegExp(' ', 'g'), ''
      isDigitPresent = /\d/.test(current_range_value)
      if isDigitPresent
#        write logic for range comparision
        result_value = result_value_element.text().replace /[^0-9.]/ig, ''
        current_range_value = current_range_value.replace /[^0-9.<>=+-]/ig, ''
#        Now try to compare range-wise
        if(/^<=/.test current_range_value)
          current_range_value = current_range_value.split("<=")[1]
          if(parseFloat(result_value) <= parseFloat(current_range_value))
            result_ele.attr('class', 'text-'+$(current_range_ele).attr('class').split(" ")[0].split("-")[1])
        else if(/^</.test current_range_value)
          current_range_value = current_range_value.split("<")[1]
          if(parseFloat(result_value) < parseFloat(current_range_value))
            result_ele.attr('class', 'text-'+$(current_range_ele).attr('class').split(" ")[0].split("-")[1])
        else if(/^>=/.test current_range_value)
          current_range_value = current_range_value.split(">=")[1]
          if(parseFloat(result_value) >= parseFloat(current_range_value))
            result_ele.attr('class', 'text-'+$(current_range_ele).attr('class').split(" ")[0].split("-")[1])
        else if(/^>/.test current_range_value)
          current_range_value = current_range_value.split(">")[1]
          if(parseFloat(result_value) > parseFloat(current_range_value))
            result_ele.attr('class', 'text-'+$(current_range_ele).attr('class').split(" ")[0].split("-")[1])
        else if(/\+$/.test current_range_value)
          current_range_value = current_range_value.split("+")[0]
          if(parseFloat(result_value) > parseFloat(current_range_value))
            result_ele.attr('class', 'text-'+$(current_range_ele).attr('class').split(" ")[0].split("-")[1])
        else if(/-/.test current_range_value)
          current_range_value_array = current_range_value.split("-")
          if(parseFloat(result_value) >= parseFloat(current_range_value_array[0]) && parseFloat(result_value) <= parseFloat(current_range_value_array[1]))
            result_ele.attr('class', 'text-'+$(current_range_ele).attr('class').split(" ")[0].split("-")[1])
        else
          if(parseFloat(result_value) == parseFloat(current_range_value))
            result_ele.attr('class', 'text-'+$(current_range_ele).attr('class').split(" ")[0].split("-")[1])
      else
#        write logic for string comparision
        result_value = result_value_element.text().toLowerCase().replace /[^a-z]/ig, ''
        if(current_range_value.toLowerCase() == result_value)
          result_ele.attr('class', 'text-'+$(current_range_ele).attr('class').split(" ")[0].split("-")[1])


  rangeNotifierColor = ->
    $('.lab-result-view').each (index) ->
      rangeNotifierColorRow($(@))

  rangeNotifierColor()

  componentStandardRangePlacer = (component, gender, age, standard_range_ele) ->
    colors = ['btn-danger', 'btn-success', 'btn-warning', 'btn-danger', 'btn-danger']
    for standard_range in component.standard_ranges
      gender=gender.toUpperCase()
      if gender is standard_range.gender
        if standard_range.age_limit isnt null && eval("#{age}#{standard_range.age_limit.replace(/[years\s]/g, '')}")
          range_value = if gender is 'M' then standard_range.age_male_range_value else standard_range.age_female_range_value
          range_values = range_value.split(',')
        else if standard_range.age_limit isnt null
          range_values = selectDefaultRanges(component.standard_ranges, gender).split(',')
        else if standard_range.age_limit is null
          range_value = standard_range.range_value
          range_values = range_value.split(',')
        html_wrapper = ''
        for range, index in range_values
          html_wrapper += "<a class='#{colors[index]} label'>#{range}</a><br/>" if range.trim()
          if($('.edit_range_flag').val()=='true')
            $('.edit_standard_rangevalue'+index).val(range.trim())
          else
            $('.standard_rangevalue'+index).val(range.trim())
        standard_range_ele.html(html_wrapper)

  selectDefaultRanges = (standard_ranges, gender) ->
    for standard_range in standard_ranges
      if standard_range.gender is gender
        default_range = if gender is 'M' then standard_range.age_male_range_value else standard_range.age_female_range_value
        return default_range

  loadTestComponentFields = (selected_ele, component_response, gender, age) ->
    selected_row = selected_ele.parents('tr')
    colors = ['btn-danger', 'btn-success', 'btn-warning', 'btn-danger', 'btn-danger']
    selected_component_value = selected_ele.val()
    units_ele = selected_row.find('.test_component_units')
    standard_range_ele = selected_row.find('.component_standard_range')
    for component in component_response
      if parseInt(component.id) == parseInt(selected_component_value)
        units_ele.html(if component.units? then component.units else '&nbsp')
        componentStandardRangePlacer(component, gender, age, standard_range_ele)

  loadTestComponents = (ele, type) ->
    component_ele = ele.parents('tr').find('.select_component')
    selected_lab_test = ele.parents('tr').find('.select_lab_test').val()
    if($('.edit_lab_result_row').attr('health_assessment_id')!=undefined)
      health_assessment_id = $('.edit_lab_result_row').attr('health_assessment_id')
    else
      health_assessment_id = ele.parents('tbody').find('#new_lab_result').attr('health_assessment_id')
    if selected_lab_test
      $.ajax
        url: "/lab_tests/#{selected_lab_test}/test_components"
        data:
          health_assessment_id: health_assessment_id
        success: (response) ->
          component_response = response.test_components
          gender = response.gender
          age = response.age
          if type is 'same_ele'
            loadTestComponentFields(component_ele, component_response, gender, age)
          else
            component_ele.empty()
            $('.standard_rangevalue0').val('')
            $('.standard_rangevalue1').val('')
            $('.standard_rangevalue2').val('')
            $('.standard_rangevalue3').val('')
            $('.edit_standard_rangevalue0').val('')
            $('.edit_standard_rangevalue1').val('')
            $('.edit_standard_rangevalue2').val('')
            $('.edit_standard_rangevalue3').val('')
            $('.unit').text('')
            for component in component_response
              component_ele.append("<option value=#{component.id}>#{component.name}</option>")
            loadTestComponentFields(component_ele, component_response, gender, age)

          component_ele.change (event) ->
            loadTestComponentFields(component_ele, component_response, gender, age)

  loadSelectComponents = ->
    $('.select_component').change (event) ->
      loadTestComponents($(event.currentTarget), 'same_ele')

  loadSelectComponents()

  enterprise_name = $('.enterprise_id').val()
  $.ajax
    url: '/lab_tests'
    data:
      enterprise_id: enterprise_name
    success: (lab_test_response) ->
      $('.select_lab_test').html('')
#        $('.select_lab_test').append("<option value='0'>Select Test Type</option>")
      for lab_test in lab_test_response
        $('.select_lab_test').append("<option value=#{lab_test.id}>#{lab_test.name}</option>")
      loadTestComponents($('.select_lab_test'))

  loadTestComponentWrapper = (event) ->
    current_ele = $(event.currentTarget)
    loadTestComponents(current_ele, 'diff_ele')

  $('.select_lab_test').change (event) ->
    loadTestComponents($(event.currentTarget), 'diff_ele')

  bindChangeEventToLabResult = ->
    $('.select_lab_test').bind('change', loadTestComponentWrapper)

  $('#lab_result_tile').click ->
    $('#lab_result_panel').show()
    $('#lab_result_panel').siblings().hide()

  cancelRow = (event) ->    
    $('.edit_range_flag').val('false')
    $(event.currentTarget).parents('tr').addClass('hide')
    $(event.currentTarget).parents('tr').prev().removeClass('hide')

  editLabResultSuccess = (event, data) ->
    units = if data.test_component.units is null then '' else data.test_component.units
    $(event.currentTarget).parents('tr').addClass('hide')
    $(event.currentTarget).parents('tr').prev().removeClass('hide')
    $(event.currentTarget).parents('tr').prev().html("<td>#{data.lab_test.name}</td>
                                                                <td>#{data.test_component.name}</td>
                                                                <td class='hide'>#{data.lab_result.result}</td>
                                                                <td>#{data.lab_result.result} #{units}</td>
                                                                <td><div class='component_standard_range'>#{ data.standard_range}</div> </td>
                                                                <td><div style='width:40px;float: right;'><a class='pull-left dropdown-toggle edit-lab-result-pencil' data-toggle='dropdown' href=#'>
                                                                  <i class='fa fa-pencil'></i></a>
                                                                <a class='pull-right dropdown-toggle lab-result-delete-row' data-toggle='dropdown' href=#'><i class='i i-trashcan'></a></div></td>
                                                              ")
    $(event.currentTarget).parents('tr').prev().find('a.lab-result-delete-row').bind('click', deleteLabResultRow)
    bindClickEventToPencil()
    bindChangeEventToLabResult()
    rangeNotifierColor()
    loadSelectComponents()
    $('.select_lab_test').change (event) ->
      loadTestComponentWrapper(event)


  submitEditLabResultForm = (event) ->
    lab_result_row = $(event.currentTarget).parents('tr')
    health_assessment_id = lab_result_row.attr('health_assessment_id')
    lab_result_id = lab_result_row.attr('lab_result_id')
    lab_test_id = lab_result_row.find('.select_lab_test').val()
    component_id = lab_result_row.find('.select_component').val()
    result = lab_result_row.find('.test_result').val()
    below_severe = lab_result_row.find('.edit_standard_rangevalue0').val()
    normal = lab_result_row.find('.edit_standard_rangevalue1').val()
    border = lab_result_row.find('.edit_standard_rangevalue2').val()
    severe = lab_result_row.find('.edit_standard_rangevalue3').val()
    $.ajax
      type: "PATCH"
      url: "/health_assessments/#{health_assessment_id}/lab_results/#{lab_result_id}"
      data:
        test_type_id: lab_test_id
        test_component_id: component_id
        test_result: result
        normal: normal
        border: border
        severe: severe
        below_severe: below_severe
      success: (data, status, xhr) ->
        $('.edit_range_flag').val('false')
        editLabResultSuccess(event, data)

  editRowOnLoad = (event) ->
    event.stopPropagation()
    current_row = $(event.currentTarget).parents('tr')
    current_row_edit = if current_row.next().is('form') then current_row.next().next() else current_row.next()
    lab_test_ele = current_row_edit.find('.select_lab_test')
    component_ele = current_row_edit.find('.select_component')
    units_ele = current_row_edit.find('.test_component_units')
    standard_range_ele = current_row_edit.find('.component_standard_range')
    lab_result_id = current_row_edit.attr('lab_result_id')
    health_assessment_id = current_row_edit.attr('health_assessment_id')
    $.ajax
      url: "/health_assessments/#{health_assessment_id}/lab_results/#{lab_result_id}"
      success: (response) ->
        lab_test_ele.empty()
        component_ele.empty()
        @lab_tests_ele = ''
        @lab_tests_cmp_ele = ''

        for lab_test in response.lab_tests
          @lab_tests_ele += if lab_test.id is response.lab_test.id then "<option selected value=#{lab_test.id}>#{lab_test.name}</option>" else "<option value=#{lab_test.id}>#{lab_test.name}</option>"
        for lab_test_component in response.lab_test_components
          @lab_tests_cmp_ele += if lab_test_component.id is response.test_component.id then "<option selected value=#{lab_test_component.id}>#{lab_test_component.name}</option>" else "<option value=#{lab_test_component.id}>#{lab_test_component.name}</option>"
        lab_test_ele.append @lab_tests_ele
        component_ele.append @lab_tests_cmp_ele
        units_ele.val(response.test_component.units)
#        console.log(response)
#        standard_range_ele.val(response.test_component.standard_range)
        range_val =  response.range.range_value.split(',')
        for standard, index in range_val
          $('.edit_standard_rangevalue'+index).val(standard.trim())
        current_row.addClass('hide')
        current_row_edit.removeClass("hide")
        component_ele.trigger('change')
#        $('.select_lab_test').change (event) ->
#          loadTestComponentWrapper(event)

  $('.edit-lab-result-pencil').click (event) ->
    $('.edit_range_flag').val('true')
    editRowOnLoad event

  bindClickEventToPencil = ->
    $('.edit_range_flag').val('true')
    $('.edit-lab-result-pencil').bind('click', editRowOnLoad)
    $('textarea').autosize()

#  bindClickEventToPencil()

  bindEventToLabResultCancelButton = ->
    $('.lab-result-cancel-row-btn').bind('click', cancelRow)

  bindEventOnSaveBtnLabResult = ->
    $(".lab-result-save-row-btn").bind('click', submitEditLabResultForm)

  $("#create_lab_result").click ->
    $("#lab_result_new_form").removeClass('hide')
    $('#test_result').val('')

  $("#new_lab_result").bind "ajax:success", (event, data, status, xhr) ->
#    $("#lab_result_new_form").addClass('hide')
    units = if data.test_component.units is null then '' else data.test_component.units
    range_val =  data.range.range_value.split(',')
    lab_result_row = "<tr class='lab-result-view'><td> #{data.lab_test.name} </td>
                                  <td> #{data.test_component.name} </td>
                                  <td class='hide'>#{data.lab_result.result}</td>
                                  <td> #{data.lab_result.result} #{units}</td>
                                  <td><div class='component_standard_range'>#{ data.standard_range}</div> </td>
                                  <td><div style='width:40px;float: right;'><a class='pull-left dropdown-toggle edit-lab-result-pencil' data-toggle='dropdown' href=#'>
                                    <i class='fa fa-pencil'></i></a>
                                  <a class='pull-right dropdown-toggle lab-result-delete-row' data-toggle='dropdown' href=#'><i class='i i-trashcan'></a></td></div>
                                  </tr>
                                <tr class='edit_lab_result_row hide' lab_result_id='#{data.lab_result.id}' health_assessment_id=#{data.lab_result.body_assessment_id}>
                                  <td><select class='form-control select_lab_test m-t17'>
                                      #{for lab_test in data.lab_tests
      if lab_test.name is data.lab_test.name then "<option selected value=#{lab_test.id}>#{lab_test.name}</option>" else "<option value=#{lab_test.id}>#{lab_test.name}</option>"
    }
                                    </select>
                                  </td>
                                  <td>
                                    <select class='form-control select_component m-t17'>
                                      #{for test_component in data.lab_test_components
      if test_component.name is data.test_component.name then "<option selected value=#{test_component.id}>#{test_component.name}</option>" else "<option value=#{test_component.id}>#{test_component.name}</option>"
    }
                                    </select>
                                  </td>
                                  <td>
                                  <div class='input-group m-t17'>
                                    <input class='form-control test_result' value=#{data.lab_result.result} >
                                    <span class='input-group-btn'>
                                      <button class='btn btn-default unit test_component_units' type='button'>#{units}</button>
                                    </span>
                                  </div>
                                  </td>
                                  <td>
      <div class='col-md-3 no_padding'>
    <label class='pull-left ln_hgt18' for='lab_result_standard_below_Normal' style='margin-right: 5px;'>Severe</label>
                                                                  <input  class='form-control parsley-validated edit_standard_rangevalue0' multiple='multiple1' type='text' value='#{range_val[1]}'/>
                                                                </div>
        <div class='col-md-3 no_padding'>
    <label class='pull-left ln_hgt18' for='lab_result_standard_Normal' style='margin-right: 5px;'>Normal</label>
                                                                  <input  class='form-control parsley-validated edit_standard_rangevalue1' multiple='multiple1' type='text' value='#{range_val[2]}'/>
                                                                </div>
    <div class='col-md-3 no_padding'>
    <label class='pull-left ln_hgt18' for='lab_result_standard_Border' style='margin-right: 5px;'>Border</label>
                                                                  <input class='form-control parsley-validated edit_standard_rangevalue2' multiple='multiple1' type='text' value='#{range_val[3]}'/>
                                                                </div>
    <div class='col-md-3 no_padding'>
    <label class='pull-left ln_hgt18' for='lab_result_standard_Severe' style='margin-right: 5px;'>Severe</label>
                                                                  <input class='form-control parsley-validated edit_standard_rangevalue3' multiple='multiple' type='text' value='#{range_val[4]}'/>
                                                                </div>

                                  </td>
                                  <td><div style='width:125px;float:left;padding-top:17px'>
                                    <input class='btn btn-sm small-btn btn-primary lab-result-save-row-btn save-edit-lab-result' name='commit' type='button' value='save'>
                                    <a class='btn btn-sm small-btn btn-danger lab-result-cancel-row-btn'>cancel</a>
                                    <input class='hide' type='reset'></div></div>
                                  </td>
                                </tr>"
    if $('#lab_result_table1 tbody tr').length>0
      $('#lab_result_table1 tbody tr').eq(0).before(lab_result_row)
    else
      $('#lab_result_table1 tbody').html(lab_result_row)

    $('#select_lab_test').val('0')
    $('#select_component').val('0')
    $('#test_result').val('')
    $('.unit').text('')
    $('#lab_result_standard_range_value').val('')
    $('.standard_rangevalue0').val('')
    $('.standard_rangevalue1').val('')
    $('.standard_rangevalue2').val('')
    $('.standard_rangevalue3').val('')
    $('#lab_result_table1 tbody tr').eq(0).find('a.lab-result-delete-row').bind('click', deleteLabResultRow)
    bindClickEventToPencil()
    bindEventToLabResultCancelButton()
    bindEventOnSaveBtnLabResult()
    bindChangeEventToLabResult()
    rangeNotifierColor()
    loadSelectComponents()
    $('.select_lab_test').change (event) ->
      loadTestComponentWrapper(event)
    $('.edit_range_flag').val('false')


  $('#lab_result_cancel_btn').click ->
    $("#lab_result_new_form").addClass('hide')

  $('#reset_lab_result_btn').click  ->
    $('#select_lab_test').val('0')
    $('#select_component').text('')
    $('#test_result').val('')
    $('.unit').text('')
    $('#lab_result_standard_range_value').val('')
    $('.standard_rangevalue0').val('')
    $('.standard_rangevalue1').val('')
    $('.standard_rangevalue2').val('')
    $('.standard_rangevalue3').val('')

  $('.lab-result-cancel-row-btn').click (event) ->
    $('.edit_range_flag').val('false')
    $(event.currentTarget).parents('tr').addClass('hide')
    $(event.currentTarget).parents('tr').prev().prev().removeClass('hide')

  $(".edit_lab_result").bind "ajax:success", (event, data, status, xhr) ->
    $(event.currentTarget).next().addClass('hide')
    $(event.currentTarget).prev().removeClass('hide')
    units = if data.test_component.units is null then '' else data.test_component.units
    $(event.currentTarget).prev().html("<td> #{data.lab_test.name} </td>
                                                  <td> #{data.test_component.name} </td>
                                                  <td class='hide'>#{data.lab_result.result}</td>
                                                  <td> #{data.lab_result.result} #{units}</td>
                                                  <td><div class='component_standard_range'>#{ data.standard_range}</div> </td>
                                                  <td><div style='width:40px;float: right;'><a class='pull-left dropdown-toggle edit-lab-result-pencil' data-toggle='dropdown' href=#'>
                                                                  <i class='fa fa-pencil'></i></a>
                                                                <a class='pull-right dropdown-toggle lab-result-delete-row' data-toggle='dropdown' href=#'><i class='i i-trashcan'></a></div></td>
                                                          ")
    $(event.currentTarget).prev().find('a.lab-result-delete-row').bind('click', deleteLabResultRow)
    bindClickEventToPencil()
    bindChangeEventToLabResult()
    rangeNotifierColor()
    loadSelectComponents()
    $('.select_lab_test').change (event) ->
      loadTestComponentWrapper(event)


  deleteLabResultRow = (event) ->
    event.stopPropagation()
    confirmed = confirm('Are you sure')
    if confirmed
      lab_result_row = $(event.currentTarget).parents('tr')
      edit_form = if lab_result_row.next().is('form') then lab_result_row.next().next() else $(event.currentTarget).parents("tr").next()
      assessment_id = edit_form.attr('health_assessment_id')
      lab_result_id = edit_form.attr('lab_result_id')
      $.ajax
        type: 'DELETE'
        url: "/health_assessments/#{assessment_id}/lab_results/#{lab_result_id}"

        success: (data, status, xhr) ->
          lab_result_row.remove()
          edit_form.remove()

  $('.lab-result-delete-row').click (event) ->
    deleteLabResultRow(event)
