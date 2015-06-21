//var customer_data={}
//var modified_data=[]
//var current_data=[]
//var risk_factors_data={}
//$(function(){
//    if($('#customer_id').length>0) {
//        $.ajax({
//            url: "/customers/customer_information/get_message_prompts",
//            type: "GET",
//            success: function (result) {
//                risk_factors_data = result
//            }
//        });
//    }
//
//    function prepareMessagePrompt(text, image)
//    {
//        var prependElement = $('<p><span class="txt">'+text+'</span></p>');
//        return prependElement;
//    }
//
//    $(".numeric").keydown(function (e) {
//        // Allow: backspace, delete, tab, escape, enter and .
//        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
//                // Allow: Ctrl+A
//            (e.keyCode == 65 && e.ctrlKey === true) ||
//                // Allow: home, end, left, right, down, up
//            (e.keyCode >= 35 && e.keyCode <= 40)) {
//            // let it happen, don't do anything
//            return;
//        }
//        // Ensure that it is a number and stop the keypress
//        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
//            e.preventDefault();
//        }
//    });
//
//    $('#feet, #inches').keyup(function(){
//        if(Number($('#feet').val()) && (Number($('#inches').val()) || $('#inches').val() == "0"))
//        {
//            $('.next_btn').attr('disabled',false)
//        }
//        else
//        {
//            $('.next_btn').attr('disabled','disabled')
//        }
//    });
//
//    $('#weight').keyup(function(){
//        if(Number($('#weight').val()))
//        {
//            $('.next_btn').attr('disabled',false)
//        }
//        else
//        {
//            $('.next_btn').attr('disabled','disabled')
//        }
//    });
//
//    $('#waist').keyup(function(){
//        if(Number($('#waist').val()))
//        {
//            $('.next_btn').attr('disabled',false)
//        }
//        else
//        {
//            $('.next_btn').attr('disabled','disabled')
//        }
//    });
//
//    $('#blood_group_tab input[type=radio]').change(function(){
//        if($('#blood_group_tab input[type=radio]:checked').length > 0)
//        {
//            $('.next_btn').attr('disabled',false)
//        }
//    });
//
//    $('#smoke_tab input[type=radio]').change(function(){
//        if($('#smoke_tab input[type=radio]:checked').length > 0)
//        {
//            $('.next_btn').attr('disabled',false)
//        }
//    });
//
//    $('#alcohol_tab input[type=radio]').change(function(){
//        if($('#alcohol_tab input[type=radio]:checked').length > 0)
//        {
//            $('.next_btn').attr('disabled',false)
//        }
//    });
//
//    $('#exercise_tab input[type=radio]').change(function(){
//        if($('#exercise_tab input[type=radio]:checked').length > 0)
//        {
//            $('.next_btn').attr('disabled',false)
//        }
//    });
//
//    $( "input[name='chk-father_medicals']" ).on( "change", function() {
//        var text = $(this).siblings('span').text().trim();
//        if($(this).prop("checked") == true){
//            $('.next_btn').attr('disabled',false)
//            $('#initial_message').html('');
//            $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.parent[text.toLowerCase()+'_value'],
//                risk_factors_data.message.parent[text.toLowerCase()+'_image']));
//        }
//        else
//        {
//            if($( "input[name='chk-father_medicals']:checked").length == 0)
//            {
//                $('.next_btn').attr('disabled','disabled')
//            }
//        }
//    });
//
//    $( "input[name='chk-mother_medicals']" ).on( "change", function() {
//        var text = $(this).siblings('span').text().trim();
//        if($(this).prop("checked") == true){
//            $('.next_btn').attr('disabled',false)
//            $('#initial_message').html('');
//            $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.parent[text.toLowerCase()+'_value'],
//                risk_factors_data.message.parent[text.toLowerCase()+'_image']));
//        }
//        else
//        {
//            if($( "input[name='chk-mother_medicals']:checked").length == 0)
//            {
//                $('.next_btn').attr('disabled','disabled')
//            }
//        }
//    });
//
//    function updateMessagePrompt(value, type)
//    {
//        $('#initial_message').html('');
//        switch(type)
//        {
//            case 'height':
//                $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.height['normal_value'],
//                    risk_factors_data.message.height['normal_image']));
//                break;
//            case 'bmi':
//                var inches
//                if(current_data.length == 0)
//                {
//                    inches = (customer_data.feet * 12) + customer_data.inches
//                }
//                else
//                {
//                    inches = (current_data.feet * 12) + current_data.inches
//                }
//                height_in_meters = (inches * 0.0254)
//                weight = value
//                bmi = (weight / (height_in_meters * height_in_meters))*100
//                if(bmi < 15)
//                {
//                    $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.bmi['<15_value'],
//                        risk_factors_data.message.bmi['<15_image']));
//                }
//                else if(bmi >= 15 && bmi <= 16)
//                {
//                    $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.bmi['15-16_value'],
//                        risk_factors_data.message.bmi['15-16_image']));
//                }
//                else if(bmi > 16 && bmi <= 18.5)
//                {
//                    $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.bmi['16-18.5_value'],
//                        risk_factors_data.message.bmi['16-18.5_image']));
//                }
//                else if(bmi > 18.5 && bmi <= 25)
//                {
//                    $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.bmi['18.5-25_value'],
//                        risk_factors_data.message.bmi['16-18.5_image']));
//                }
//                else if(bmi > 25 && bmi <= 30)
//                {
//                    $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.bmi['25-30_value'],
//                        risk_factors_data.message.bmi['25-30_image']));
//                }
//                else if(bmi > 30 && bmi <= 35)
//                {
//                    $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.bmi['30-35_value'],
//                        risk_factors_data.message.bmi['30-35_image']));
//                }
//                else if(bmi > 35 && bmi <= 40)
//                {
//                    $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.bmi['35-40_value'],
//                        risk_factors_data.message.bmi['35-40_image']));
//                }
//                else if(bmi > 40)
//                {
//                    $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.bmi['>40_value'],
//                        risk_factors_data.message.bmi['>40_image']));
//                }
//                break;
//            case 'waist':
//                var waist_in_cms = Math.round(value * 2.54);
//                if(risk_factors_data.message.waist['<94_value'].length > 0) {
//                    if (waist_in_cms < 94) {
//                        $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.waist['<94_value'],
//                            risk_factors_data.message.waist['<94_image']));
//                    }
//                    else if (waist_in_cms >= 94 && waist_in_cms <= 102) {
//                        $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.waist['94-102_value'],
//                            risk_factors_data.message.waist['94-102_image']));
//                    }
//                    else if (waist_in_cms > 102) {
//                        $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.waist['>102_value'],
//                            risk_factors_data.message.waist['>102_image']));
//                    }
//                }
//                else
//                {
//                    if (waist_in_cms < 80) {
//                        $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.waist['<80_value'],
//                            risk_factors_data.message.waist['<80_image']));
//                    }
//                    else if (waist_in_cms >= 80 && waist_in_cms <= 88) {
//                        $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.waist['80-88_value'],
//                            risk_factors_data.message.waist['80-88_image']));
//                    }
//                    else if (waist_in_cms > 88) {
//                        $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.waist['>88_value'],
//                            risk_factors_data.message.waist['>88_image']));
//                    }
//                }
//                break;
//            case 'blood_group':
//                $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.blood_group[value.toLowerCase()+'_value'],
//                    risk_factors_data.message.blood_group[value.toLowerCase() +'_image']));
//                break;
//            case 'smoke':
//                $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.smoke[value.toLowerCase()+'_value'],
//                    risk_factors_data.message.smoke[value.toLowerCase() +'_image']));
//                break;
//            case 'alcohol':
//                $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.alcohol[value.toLowerCase()+'_value'],
//                    risk_factors_data.message.alcohol[value.toLowerCase() +'_image']));
//                break;
//            case 'exercise':
//                $('#message_content').html(prepareMessagePrompt(risk_factors_data.message.exercise[value.toLowerCase()+'_value'],
//                    risk_factors_data.message.exercise[value.toLowerCase() +'_image']));
//                break;
//        }
//    }
//
//    function insertData(url_path,type,data)
//    {
//        var response_data={}
//        $.ajax({
//            url:url_path,
//            type: type,
//            data:data,
//            success: function (result) {
//                getNextTab()
//                var response_data=result;
//                console.log(response_data)
//                if('bmi' in response_data)
//                {
//                    $('#bmi').html(response_data.bmi)
//                    $('#bmi').removeClass().addClass(response_data.bmi_color)
//                }
//                return true
//            },
//            error: function(xhr, status, error) {
//                return false
//            }
//        });
//        return true
//    }
//    function getNextTab(){
//        var next_wizard_tab='#thank_you_tab';
//        if((customer_data.feet==null) && (modified_data.indexOf('height')==-1)){
//            next_wizard_tab='#height_tab'
//            modified_data.push('height')
//        }
//        else if(((customer_data.inches==null) && (modified_data.indexOf('height')==-1))){
//            next_wizard_tab='#height_tab'
//            modified_data.push('height')
//        }
//        else if((customer_data.weight=='') && (modified_data.indexOf('weight')==-1)){
//            next_wizard_tab='#weight_tab'
//            modified_data.push('weight')
//        }
//        else if((customer_data.weight==null) && (modified_data.indexOf('weight')==-1)){
//            next_wizard_tab='#weight_tab'
//            modified_data.push('weight')
//        }
//        else if((customer_data.blood_group) && (modified_data.indexOf('blood_group')==-1)){
//            next_wizard_tab='#blood_group_tab'
//            modified_data.push('blood_group')
//        }
//        else if(((customer_data.waist==null) && (modified_data.indexOf('waist')==-1))){
//            next_wizard_tab='#waist_tab'
//            modified_data.push('waist')
//        }
//        else if(((customer_data.smoke==null) && (modified_data.indexOf('smoke')==-1))){
//            next_wizard_tab='#smoke_tab'
//            modified_data.push('smoke')
//        }
//        else if(((customer_data.alcohol==null) && (modified_data.indexOf('alcohol')==-1))){
//            next_wizard_tab='#alcohol_tab'
//            modified_data.push('alcohol')
//        }
//        else if(((customer_data.exercise==null) && (modified_data.indexOf('exercise')==-1))){
//            next_wizard_tab='#exercise_tab'
//            modified_data.push('exercise')
//        }
//        //else if(((customer_data.blood_pressure==false) && (modified_data.indexOf('blood_pressure')==-1))){
//        //    next_wizard_tab='#blood_pressure_tab'
//        //    modified_data.push('blood_pressure')
//        //}
//        //else if(((customer_data.blood_sugar=='-') && (modified_data.indexOf('blood_sugar')==-1))){
//        //    next_wizard_tab='#blood_sugar_tab'
//        //    modified_data.push('blood_sugar')
//        //}
//        else if((customer_data.father_health==false) && (modified_data.indexOf('father_health')==-1))
//        {
//            next_wizard_tab='#father_health_tab'
//            modified_data.push('father_health')
//        }
//        else if((customer_data.mother_health==false) && (modified_data.indexOf('mother_health')==-1))
//        {
//            next_wizard_tab='#mother_health_tab'
//            modified_data.push('mother_health')
//            //function hideWizard(){
//            //    var str = '<div class="alert alert-info"> <button type="button" class="close" data-dismiss="alert">×</button> <i class="fa fa-info-sign"></i><strong>Thank you</strong></div>';
//            //
//            //    $('#diabetes_score_chart').removeClass('hide')
//            //    $('#hypertension_score_chart').removeClass('hide')
//            //    $('.hypertension_chart').data('easyPieChart').update(40);
//            //    $('.diabetes_chart').data('easyPieChart').update(40);
//            //    $('#hypertension-score').html(20)
//            //    $('#diabetes-score').html(10)
//            //}
//            //setTimeout(hideWizard,1000)
//        }
//        if(next_wizard_tab=='#thank_you_tab'){
//            $('#question_wizard').hide()
//            $('#message_prompts_wizard').hide()
//            $('#diabetes_score_chart').removeClass('hide')
//            $('#hypertension_score_chart').removeClass('hide')
//
//            $.ajax({
//                url : '/customers/dashboard/show',
//                success : function(data){
//                    source = $('<div>'+data+'</div>');
//                    var diabetes_score = source.find('#diabetes-score').html();
//                    var hypertension_score = source.find('#hypertension-score').html();
//                    var diabetes_chart = source.find('.diabetes_chart').attr('data-percent')
//                    var hypertension_chart = source.find('.hypertension_chart').attr('data-percent')
//                    $('#diabetes-score').html(diabetes_score);
//                    $('#hypertension-score').html(hypertension_score);
//                    //$('.diabetes_chart').attr('data-percent',diabetes_chart);
//                    //$('.hypertension_chart').attr('data-percent',hypertension_chart);
//                    $('.hypertension_chart').data('easyPieChart').update(hypertension_chart);
//                    $('.diabetes_chart').data('easyPieChart').update(diabetes_chart);
//                    $('#diabetes_score_chart').removeClass('hide')
//                    $('#hypertension_score_chart').removeClass('hide')
//
//                },
//                error : function(){
//
//                }
//            })
//
//
//        }
//        $('.nav-tabs a[href="'+next_wizard_tab+'"]').tab('show')
//        $('#question_wizard').removeClass('hide')
//        $('#message_prompts_wizard').removeClass('hide')
//        //$('.next_btn').attr('disabled',true)
//    }
//    //$('.nav-tabs a[href="'+next_wizard_tab+'"]').tab('show')
//    $('#wizardform').bootstrapWizard({
//        'tabClass': 'nav nav-tabs',
//        'onNext': function (tab, navigation, index) {
//            var valid = false;
//            $('[data-required="true"]', $($(tab.html()).attr('href'))).each(function () {
//                return (valid = $(this).parsley('validate'));
//            });
//            if ($(this).parent('li').hasClass('disabled')) {
//                return false;
//            };
//            var blood_type={1:'A+',2:'A-',3:'B+',4:'B-',5:'AB+',6:'AB-',7:'O+',8:'O-'}
//            var date=moment().format("MMM DD,YYYY")
//            var tab_id=(($(tab.html()).attr('href')))
//            switch (tab_id) {
//                case '#height_tab':
//                    var feet=$('#feet').val()
//                    var inches=$('#inches').val()
//                    if(feet=='' || inches == ''){
//                        return false;
//                    }
//                    if(insertData("/customers/customer_information/update_customer_vitals","PUT",{ undefined:{feet:feet,inches:inches}})){
//                        $('#feet_val').html(feet)
//                        $('#inches_val').html(inches)
//                        $('#height_date').html(date)
//                        $('#height_section').parent().removeClass('hide')
//                        $('.next_btn').attr('disabled','disabled')
//                        current_data.feet = feet
//                        current_data.inches = inches
//                        updateMessagePrompt(feet, 'height')
//                    }
//                    break;
//                case '#weight_tab':
//                    var weight=$('#weight').val()
//                    if(weight == ''){
//                        return false;
//                    }
//                    if(insertData("/customers/customer_information/update_customer_vitals","PUT",{ undefined:{weight:weight}})){
//                        $('#weight_val').html(weight)
//                        $('#weight_section').parent().removeClass('hide')
//                        $('#weight_date').html(date)
//                        $('#bmi_date').html(date)
//                        $('#bmi_section').parent().removeClass('hide')
//                        $('.next_btn').attr('disabled','disabled')
//                        updateMessagePrompt(weight, 'bmi')
//                    }
//                    break;
//                case '#blood_group_tab':
//                    var blood_group=$('input[name=blood_group]:checked').val()
//                    if(blood_group == undefined){
//                        return false;
//                    }
//                    if(insertData("/customers/customer_information/update_customer_vitals","PUT",{ undefined:{blood_group_id:blood_group}})){
//                        $('#blood_group_val').html(blood_type[blood_group])
//                        $('#blood_group_date').html(date)
//                        $('#blood_group_section').parent().removeClass('hide')
//                        $('.next_btn').attr('disabled','disabled')
//                        updateMessagePrompt(blood_group, 'blood_group')
//                    }
//                    break;
//                case '#waist_tab':
//                    var waist=$('#waist').val()
//                    if(waist == ''){
//                        return false;
//                    }
//                    if(insertData("/customers/customer_information/update_customer_vitals","PUT",{ undefined:{waist:waist}})){
//                        $('.next_btn').attr('disabled','disabled')
//                        updateMessagePrompt(waist, 'waist')
//                    }
//                    break;
//                case '#smoke_tab':
//                    var smoke=$('input[name=smoke]:checked').val()
//                    if(smoke == undefined){
//                        return false;
//                    }
//                    if(insertData("/customers/customer_information/update","POST",{ customer:{smoke:smoke}})){
//                        $('.next_btn').attr('disabled','disabled')
//                        updateMessagePrompt(smoke.toLowerCase(), 'smoke')
//                    }
//                    break;
//                case '#exercise_tab':
//                    var exercise=$('input[name=exercise]:checked').val()
//                    if(exercise == undefined){
//                        return false;
//                    }
//                    if(insertData("/customers/customer_information/update","POST",{ customer:{'frequency_of_exercise':exercise}})){
//                        $('.next_btn').attr('disabled','disabled')
//                        updateMessagePrompt(exercise.toLocaleUpperCase(), 'exercise')
//                    }
//                    break;
//                case '#alcohol_tab':
//                    var alcohol=$('input[name=alcohol]:checked').val()
//                    if(alcohol == undefined){
//                        return false;
//                    }
//                    if(insertData("/customers/customer_information/update","POST",{ customer:{'alcohol':alcohol}})){
//                        $('.next_btn').attr('disabled','disabled')
//                        updateMessagePrompt(alcohol.toLocaleString(), 'alcohol')
//                    }
//                    break;
//                //case '#blood_pressure_tab':
//                //    var systolic=$('#systolic_value').val()
//                //    var diastolic=$('#diastolic_value').val()
//                //    if(insertData("/customers/customer_lab_results/edit","PUT",{ undefined:{blood_pressure: {systolic:systolic,diastolic:diastolic}}})){
//                //        $("#blood_pressure_section").parent().removeClass("hide")
//                //        $("#systolic_val").html(systolic)
//                //        $("#diastolic_val").html(diastolic)
//                //        $("#bp_date").html(date)
//                //        $("#recent_assessment_val").html('Body')
//                //        $("#recent_assessment_date").html(date)
//                //        $("#recent_body_assessment_section").parent().removeClass("hide")
//                //    }
//                //    break;
//                //case '#blood_sugar_tab':
//                //    var blood_sugar=$('#blood_sugar').val()
//                //    if(insertData("/customers/customer_lab_results/update_blood_sugar",'PUT',{ undefined: {result:blood_sugar}})){
//                //        $('#blood_sugar_color').html(blood_sugar)
//                //        $("#blood_sugar_date").html(date)
//                //        $("#recent_assessment_date").html(date)
//                //        $("#blood_sugar_section").parent().removeClass("hide")
//                //        $("#recent_body_assessment_section").parent().removeClass("hide")
//                //    }
//                //    break;
//                case '#father_health_tab':
//                    var checkedConditions = $('input[name="chk-father_medicals"]:checked').map(function() {
//                        return this.value;
//                    }).get();
//                    if(checkedConditions == undefined){
//                        return false;
//                    }
//                    if(checkedConditions.indexOf('None')!= -1) {
//                        checkedConditions = null
//                    }
//                    if(insertData("/customers/family_medical_histories","POST",{ family_medical_history:{relation:'Father'},'chk-family_medicals': checkedConditions})){
//                        $('.next_btn').attr('disabled','disabled')
//                    }
//                    break;
//                case '#mother_health_tab':
//                    var checkedConditions = $('input[name="chk-mother_medicals"]:checked').map(function() {
//                        return this.value;
//                    }).get();
//                    if(checkedConditions == undefined){
//                        return false;
//                    }
//                    if(checkedConditions.indexOf('None')!=-1) {
//                        checkedConditions = null
//                    }
//                    if(insertData("/customers/family_medical_histories","POST",{ family_medical_history:{relation:'Mother'},'chk-family_medicals': checkedConditions})){
//                        $('.next_btn').attr('disabled','disabled')
//                    }
//                    $('#diabetes_score_chart').removeClass('hide')
//                    $('#hypertension_score_chart').removeClass('hide')
//                    //$('.hypertension_chart').data('easyPieChart').update(40);
//                    //$('.diabetes_chart').data('easyPieChart').update(40);
//                    $.ajax({
//                        url : '/customers/dashboard/show',
//                        success : function(data){
//                            source = $('<div>'+data+'</div>');
//                            var diabetes_score = source.find('#diabetes-score').html();
//                            var hypertension_score = source.find('#hypertension-score').html();
//                            var diabetes_chart = source.find('.diabetes_chart').attr('data-percent')
//                            var hypertension_chart = source.find('.hypertension_chart').attr('data-percent')
//                            $('#diabetes-score').html(diabetes_score);
//                            $('#hypertension-score').html(hypertension_score);
//                            //$('.diabetes_chart').attr('data-percent',diabetes_chart);
//                            //$('.hypertension_chart').attr('data-percent',hypertension_chart);
//                            $('.hypertension_chart').data('easyPieChart').update(hypertension_chart);
//                            $('.diabetes_chart').data('easyPieChart').update(diabetes_chart);
//                        },
//                        error : function(){
//
//                        }
//                    })
//
//                    //$('#hypertension-score').html(20)
//                    //$('#diabetes-score').html(10)
//                    $('#question_wizard').hide()
//                    $('#message_prompts_wizard').hide()
//                    break;
//                //case '#thank_you_tab':
//                //    break;
//            }
//            return true;
//        },
//        onTabClick: function (tab, navigation, index) {
//            return false;
//        },
//        onTabShow: function (tab, navigation, index) {
//        },
//        onShow:function(tab,navigation,index){
//        },
//        onInit:function(tab,navigation,index){
//            $.ajax({
//                url:"/customers/customer_information/show",
//                type: 'GET' ,
//                data:{ },
//                success: function (result) {
//                    customer_data=result
//                    if(wizard_complete()==false) {
//                        getNextTab()
//                    }else{
//                        $('#diabetes_score_chart').removeClass('hide')
//                        $('#hypertension_score_chart').removeClass('hide')
//                        $('#question_wizard').hide()
//                        $('#message_prompts_wizard').hide()
//                    }
//                },
//                error: function(xhr, status, error) {
//                }
//            });
//        }
//    });
//    function wizard_complete(){
//
//        if(customer_data.feet==null || customer_data.inches==null || customer_data.weight==null || customer_data.blood_group || customer_data.waist==null || customer_data.smoke==null || customer_data.alcohol==null || customer_data.exercise==null || customer_data.father_health==false || customer_data.mother_health==false){
//            return false;
//        }else{
//            return true;
//        }
//    }
//    function initToolbarBootstrapBindings() {
//        var fonts = ['Serif', 'Sans', 'Arial Black', 'Arial',  'Courier',
//                'Courier New', 'Comic Sans MS', 'Helvetica', 'Impact', 'Lucida Grande', 'Lucida Sans', 'Tahoma', 'Times',
//                'Times New Roman', 'Verdana'],
//            fontTarget = $('[title=Font]').siblings('.dropdown-menu');
//        $.each(fonts, function (idx, fontName) {
//            fontTarget.append($('<li><a data-edit="fontName ' + fontName +'" style="font-family:\''+ fontName +'\'">'+fontName + '</a></li>'));
//        });
//        $('a[title]').tooltip({container:'body'});
//        $('.dropdown-menu input').click(function() {return false;})
//            .change(function () {$(this).parent('.dropdown-menu').siblings('.dropdown-toggle').dropdown('toggle');})
//            .keydown('esc', function () {this.value='';$(this).change();});
//        $('[data-role=magic-overlay]').each(function () {
//            var overlay = $(this), target = $(overlay.data('target'));
//            overlay.css('opacity', 0).css('position', 'absolute').offset(target.offset()).width(target.outerWidth()).height(target.outerHeight());
//        });
//        if ("onwebkitspeechchange" in document.createElement("input")) {
//            var editorOffset = $('#editor').offset();
//            // $('#voiceBtn').css('position','absolute').offset({top: editorOffset.top, left: editorOffset.left+$('#editor').innerWidth()-35});
//        } else {
//            $('#voiceBtn').hide();
//        }
//    };
//    function showErrorAlert (reason, detail) {
//        var msg='';
//        if (reason==='unsupported-file-type') { msg = "Unsupported format " +detail; }
//        else {
//            console.log("error uploading file", reason, detail);
//        }
//        $('<div class="alert"> <button type="button" class="close" data-dismiss="alert">&times;</button>'+
//            '<strong>File upload error</strong> '+msg+' </div>').prependTo('#alerts');
//    };
//    initToolbarBootstrapBindings();
//    $('#editor').wysiwyg({ fileUploadError: showErrorAlert} );
//    $('input[name="chk-father_medicals"],input[name="chk-mother_medicals"],input[name="blood_group"],input[name="smoke"],input[name="exercise"],input[name="alcohol"]').on('change',function(e){
//        enable_next(e);
//    });
//    $('#height_tab,#weight_tab,#waist_tab').find('input').on('change',function(e){
//        enable_next(e);
//    });
//    $('#next_btn').click(function(e){
//        enable_next(e);
//    })
//    var enable_next = function(e){
//        var father_medicals = $('input[name="chk-father_medicals"]:checked').length
//        mother_medicals = $('input[name="chk-mother_medicals"]:checked').length
//        feet = $('#height_tab').find('#feet').val()
//        inches = $('#height_tab').find('#inches').val()
//        weight = $('#weight_tab').find('#weight').val()
//        waist = $('#waist_tab').find('#waist').val()
//        blood_group = $('input[name="blood_group"]:checked').length
//        smoke = $('input[name="smoke"]:checked').length
//        exercise=$('input[name="exercise"]:checked').length
//        alcohol=$('input[name="alcohol"]:checked').length
//        if(father_medicals != 0 || mother_medicals !=0 || (feet != '' && inches != '') || weight != '' || blood_group != 0 || waist!='' || smoke!=0 || exercise !=0 || alcohol !=0)
//        {
//            $('.next_btn').removeAttr('disabled')
//        } else {
//            $('.next_btn').attr('disabled',true)
//            e.preventDefault();
//        }
//    }
//});
