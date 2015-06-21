
$(".ekin-choice").click(function(){
    $(this).siblings(".ekin-choice").removeClass("btn-success");
    $(this).addClass("btn-success");
    $(this).siblings(".ekin-choice").removeClass("selected");
    $(this).addClass("selected");
})

$(".ekin-multi-choice").click(function(){
    $(this).toggleClass("btn-success");
    $(this).toggleClass("selected");
})

if($('#customer-info-wizard').length>0){
    var getCustomerInfo=function(){
        var customerInfo=null;
        $.ajax({
            url:"/customers/customer_information/show",
            type: 'GET' ,
            data:{ },
            async: false,
            success: function (result) {
                customerInfo=result;
            },
            error: function(xhr, status, error) {
            }
        });
        return customerInfo;
    }

    var risk_factors_data={};
    var getMessagePrompts=function(current_tab){
        $.ajax({
            url: "/customers/customer_information/get_message_prompts",
            type: "GET",
            success: function (result) {
                risk_factors_data = result;
            }
        });
        return risk_factors_data;
    }

    var insert_data=function(url_path,type,data){
        var status=false
        $.ajax({
            url:url_path,
            type: type,
            dataType: 'json',
            data:data,
            success: function (result) {
                if('bmi' in result)
                {
                    $('#bmi').html(result.bmi)
                    $('#bmi').removeClass().addClass(result.bmi_color)
                }
                if('hypertension_score' in result){
                    $('#hypertension-score').html(result.hypertension_score);
                }
                if('diabetic_score' in result){
                    $('#diabetes-score').html(result.diabetic_score);
                }
                if('systolic_color' in result){
                    $('#systolic_val').removeClass().addClass(result.systolic_color);
                }
                if('diastolic_color' in result){
                    $('#diastolic_val').removeClass().addClass(result.diastolic_color);
                }
                if('bp_units' in result){
                    $('#blood_pressure_units').text(result.bp_units);
                }
                if('blood_sugar_id' in result){
                    $('div .tab-content .tab-pane').each(function(){
                            if(this.id==result.blood_sugar_id+'_sugar_tab'){
                                $("#"+this.id).addClass('active');
                                $("#"+this.id).removeClass('fade')
                                $('#Fasting_blood_sugar_id').removeClass('editable-empty');
                                $('#Fasting_blood_sugar_id').addClass(result.color);
                                if(result.units)
                                    $('#fasting-blood-sugar-units').text(result.units);
                                $(this).siblings().removeClass('active');
                            }
                        }
                    )
                }
                return true
            },
            error: function(xhr, status, error) {
                return false
            }
        });
        return true
    }

    var addParsleyError=function(id,message){
        $(id).addClass('parsley-error')
        el = $(id).parsley();
        el.manageErrorContainer();
        $(el.ulError).empty()
        el.addError({error: message});
    }

    customer_data=getCustomerInfo();
    getMessagePrompts();
    modified_data=[]
    hydrocare_status=false


    var isAvailableInCustomerInfo=function(attr) {
        var status = false;
        switch (attr) {
            case "height_weight":
                if (customer_data.weight
                    && (customer_data.inches && customer_data.feet))
                    status = true;
                break;
            case "waist_bloodgroup":
                if ((customer_data.waist) && (!customer_data.blood_group))
                    status = true;
                break;
            case "activities":
                if ((customer_data.alcohol && customer_data.smoke)&&customer_data.exercise)
                    status = true;
                break;
            case "family_medical_history":
                if (customer_data.father_health && customer_data.mother_health)
                    status = true;
                break;
            case "water_intake":
                if ((customer_data.water_intake!=null) && (!customer_data.blood_sos))
                    status = true;
                break;
            case "health_information":
                if (customer_data.blood_pressure && (customer_data.blood_sugar)){
                    status = true;
                }
                break;
        }
        return status;
    }

    var isAvailableInModifiedData=function(attr){
        return (modified_data.indexOf(attr)!=-1)
    }

    var is_available=function(attr){
        var status=false;
        switch(attr){
            case "height_weight":
                if(isAvailableInCustomerInfo('height_weight')||isAvailableInModifiedData('height_weight')){
                    status=true;
                }
                break;
            case "waist_bloodgroup":
                if(isAvailableInCustomerInfo('waist_bloodgroup')||isAvailableInModifiedData('waist_bloodgroup')) {
                    status = true;
                }
                break;
            case "activities":
                if(isAvailableInCustomerInfo('activities')||isAvailableInModifiedData('activities')) {
                    status = true;
                }
                break;
            case "family_medical_history":
                if(isAvailableInCustomerInfo('family_medical_history')||isAvailableInModifiedData('family_medical_history')) {
                    status = true;
                }
                break;
            case "water_intake":
                if(isAvailableInCustomerInfo('water_intake')||isAvailableInModifiedData('water_intake')) {
                    status = true;
                }
                break;
            case "health_information":
                if(isAvailableInCustomerInfo('health_information')||isAvailableInModifiedData('health_information')) {
                    status = true;
                }
                break;
        }
        return status;
    }


    var getNextTab=function(){
        //alert(is_available('height_weight'));
    }

    var nextTab=function(currentTab){
        var next_tab="default"
        switch(currentTab) {
            case "#wizard":
                if(is_available('height_weight')){
                    nextTab("#height_weight");
                }
                else{
                    $("#height_weight").removeClass('hide');
                    $("#height_weight").siblings().addClass('hide');
                }
                break;
            case "#height_weight":
                if(is_available('waist_bloodgroup')){
                    nextTab("#waist_bloodgroup");
                }
                else{
                    $("#waist_bloodgroup").removeClass('hide');
                    $("#waist_bloodgroup").siblings().addClass('hide');
                }
                break;
            case "#waist_bloodgroup":
                if(is_available('activities')){
                    nextTab("#activities");
                }
                else{
                    $("#activities").removeClass('hide');
                    $("#activities").siblings().addClass('hide');
                }
                break;
            case "#activities":
                if(is_available('family_medical_history')){
                    nextTab("#family_medical_history");
                }
                else{
                    $("#family_medical_history").removeClass('hide');
                    $("#family_medical_history").siblings().addClass('hide');
                }
                break;
            case "#family_medical_history":
                if(is_available('water_intake')){
                    nextTab("#water_intake");
                }
                else{
                    $('#water_intake').removeClass('hide');
                    $("#water_intake").siblings().addClass('hide');
                }
                break;

            case '#water_intake':
                if(is_available('health_information')){
                    nextTab("#health_information");
                }
                else{
                    $('#health_information').removeClass('hide');
                    $("#health_information").siblings().addClass('hide');
                }
                break;
            case '#health_information_skip':
                $('#hypertension_score_chart').addClass('hide');
                $('#diabetes_score_chart').addClass('hide');
                $('#hypertension_text').removeClass('hide');
                $('#diabetes_text').removeClass('hide');
                if(hydrocare_status){
                    $('#water_intake_chart').removeClass('hide');
                }
                break;
            case "#health_information":
                $("#customer-info-wizard").addClass('hide');
                $("#diabetes_score_chart").removeClass('hide');
                $("#hypertension_score_chart").removeClass('hide');
                if(hydrocare_status){
                    $('#water_intake_chart').removeClass('hide');
                }
                break;
            default:{
                $("#customer-info-wizard").addClass('hide');
                $("#hypertension_score_chart").removeClass('hide');
                $('#diabetes_score_chart').removeClass('hide');
                break;
            }
        }
    }

    function wizard_complete(){
        if(customer_data.feet==null || customer_data.inches==null || customer_data.weight==null || customer_data.blood_group || customer_data.waist==null || customer_data.smoke==null || customer_data.alcohol==null || customer_data.exercise==null || customer_data.father_health==false || customer_data.mother_health==false||customer_data.water_intake==null||customer_data.blood_sos){
            return false;
        }else{
            return true;
        }
    }

    if(!wizard_complete()){
        $("#height_weight").removeClass('hide');
        nextTab('#wizard');
    }
    else{
        $("#customer-info-wizard").addClass('hide');
        $("#hypertension_score_chart").removeClass('hide');
        $('#diabetes_score_chart').removeClass('hide');
        if(customer_data.blood_pressure==false){
            $('#hypertension_score_chart').addClass('hide');
            $('#hypertension_text').removeClass('hide');
        }
        if(customer_data.blood_sugar=='-'){
            $('#diabetes_score_chart').addClass('hide');
            $('#diabetes_text').removeClass('hide');
        }
    }

    $('#bp_values').click(function(){
        $('#hypertension_text').addClass('hide');
        $('#diabetes_text').addClass('hide');
        $('#diabetes_score_chart').addClass('hide');
        $('#customer-info-wizard').removeClass('hide');
        $('#health_information').removeClass('hide');
    })

    $('#sugar_values').click(function(){
        $('#hypertension_text').addClass('hide');
        $('#diabetes_text').addClass('hide');
        $('#diabetes_score_chart').addClass('hide');
        $('#customer-info-wizard').removeClass('hide');
        $('#health_information').removeClass('hide');
    })

    var load_wizard=function(){

    }

    function is_bmi_tab_complete(){
        var weight=$('#weight').val()
        var feet=$('#feet').val();
        var inches=$('#inches').val();
        var status=false;
        if(weight&&(feet&&inches)){
            status=true;
        }
        return status;
    }

    function get_bmi(){
        var weight=$('#weight').val()
        var feet=$('#feet').val();
        var inches=$('#inches').val();
        weight=parseInt(weight);
        feet=parseInt(feet);
        inches=parseInt(inches);
        height_in_inches = (feet * 12) + inches
        height_in_meters = (height_in_inches * 0.0254)
        bmi = (weight / (height_in_meters * height_in_meters))
        return bmi;
    }


//******************************************************validations and data insertion**************************************************

    $("#height_weight_next").click(function(){
        var weight=$('#weight').val()
        var feet=$('#feet').val();
        var inches=$('#inches').val();
        var date=moment().format("MMM DD,YYYY")

        if(weight==''){
            addParsleyError('#weight','Enter weight value');
        }
        else if(feet==''){
            addParsleyError('#feet','Enter feet value');
        }
        else if(inches==''){
            addParsleyError('#inches','Enter inches value');
        }
        else if(insert_data('/customers/customer_information/update_customer_vitals','PUT',{'undefined':{'weight':weight,'feet':feet,'inches':inches}})==true){
            modified_data.push('height_weight');
            var optimal_water_intake=parseFloat(weight)/0.024;
            $('#glassFullReading').html(optimal_water_intake);
            $('#feet_val').html(feet)
            $('#inches_val').html(inches)
            $('#height_date').html(date)
            $('#height_section').parent().removeClass('hide')
            $('#weight_val').html(weight)
            $('#weight_section').parent().removeClass('hide')
            $('#weight_date').html(date)
            $('#bmi_section').parent().removeClass('hide')
            nextTab('#height_weight');
        }
        else{}
    })

    $("#waist_bloodgroup_next").click(function(){
        var waist=$('#waist_size').val()
        var blood_group_id=$('.ekin-choice').filter('.selected.blood-group').attr('id');
        if(waist==''){
            addParsleyError('#waist_size','Enter waist value');
        }
        else if(blood_group_id==null){
            $("#blood_group_error").removeClass('hide')
        }
        else if(insert_data('/customers/customer_information/update_customer_vitals','PUT',{'undefined':{'blood_group_id':blood_group_id,'waist':waist}})==true){
            modified_data.push('waist_bloodgroup');
            //var customer_blood_type={1:'A+',2:'A-',3:'B+',4:'B-',5:'AB+',6:'AB-',7:'O+',8:'O-'}
            var date=moment().format("MMM DD,YYYY")
            $('#blood_group_val').html(customer_blood_type[blood_group_id])
            $('#blood_group_date').html(date)
            $('#blood_group_section').parent().removeClass('hide')
            nextTab('#waist_bloodgroup');
        }
        else{
        }
    })

    $("#activities_next").click(function(){
        var alcohol_status=$('.ekin-choice').filter('.selected.alcohol').attr('value');
        var smoke_status=$('.ekin-choice').filter('.selected.smoke').attr('value');
        var exercise_status=$('.ekin-choice').filter('.selected.exercise').attr('value');
        if(alcohol_status==null){
            $("#alcohol_error").removeClass('hide')
        }
        else if(smoke_status==null){
            $("#smoke_error").removeClass('hide')
        }
        else if(exercise_status==null){
            $("#exercise_error").removeClass('hide')
        }
        else if(insert_data('/customers/customer_information/update','POST',{'customer':{'smoke':smoke_status,'alcohol':alcohol_status,'frequency_of_exercise':exercise_status}})==true){
            modified_data.push('activities');
            nextTab('#activities');
        }
        else{}
    })

    $("#family_medical_history_next").click(function(){
        var father_health_history=[]
        var mother_health_history=[]
        var mother_health_selected=false;
        var father_health_selected=false;
        $('.ekin-multi-choice').filter('.selected.father-medical-history').each(function()
        {
            if(this.id!=0){
                father_health_history.push(this.id);
            }
            else{
                father_health_selected=true;
            }
        })
        $('.ekin-multi-choice').filter('.selected.mother-medical-history').each(function()
        {
            if(this.id!=0) {
                mother_health_history.push(this.id);
            }
            else{
                mother_health_selected=true;
            }
        })

        if(father_health_history.length==0){
            father_health_history=null;
        }
        if(mother_health_history.length==0){
            mother_health_history=null;
        }
        if(father_health_history==null && father_health_selected==false){
            $("#father_medical_error").removeClass('hide')
        }

        else if(mother_health_history==null && mother_health_selected==false){
            $("#mother_medical_error").removeClass('hide')
        }
        else if(insert_data("/customers/family_medical_histories","POST",{ family_medical_history:{relation:'Mother'},'chk-family_medicals': mother_health_history}) &&
            insert_data("/customers/family_medical_histories","POST",{ family_medical_history:{relation:'Father'},'chk-family_medicals': father_health_history})){
            modified_data.push('family_medical_history');
            nextTab("#family_medical_history");
        }
        else{
        }
    })

    $('#water_intake_next').click(function(){
        var water_intake_id=$('.ekin-choice').filter('.selected.water_intake').attr('value');
        var blood_sos_id=$('.ekin-choice').filter('.selected.blood_sos').attr('value');

        if(water_intake_id==1){
            hydrocare_status=true
        }

        if(water_intake_id==null){
            $("#water_intake_error").removeClass('hide')
        }
        else if(blood_sos_id==null) {
            $("#blood_sos_error").removeClass('hide')
        }

        else if(insert_data('/customers/customer_information/update','POST',{'customer':{'hydrocare_subscripted':water_intake_id,'blood_sos_subscripted':blood_sos_id}})==true){
            modified_data.push('water_intake');
            nextTab('#water_intake');
        }
        else{}
    })

    $("#health_information_skip").click(function(){
        $('#health_information').addClass('hide');
        nextTab('#health_information_skip');
    })

    $("#health_information_finish").click(function(){
        var systolic=$('#systolic').val()
        var diastolic=$('#diastolic').val();
        var blood_sugar=$('#blood_sugar').val();
        if(systolic==''){
            addParsleyError('#systolic','Enter systolic value');
        }
        else if(diastolic==''){
            addParsleyError('#diastolic','Enter diastolic value');
        }
        else if(blood_sugar==''){
            addParsleyError('#blood_sugar','Enter blood sugar value');
        }
        else if(insert_data("/customers/customer_lab_results/update_blood_sugar",'PUT',{ lab_result: {result:blood_sugar}}) &&
            insert_data("/customers/customer_lab_results/edit","PUT",{ undefined:{blood_pressure: {systolic:systolic,diastolic:diastolic}}}))
        {
            var date=moment().format("MMM DD,YYYY")
            $('#health_information').addClass('hide');
            modified_data.push('health_information');
            $("#systolic_val").html(systolic)
            $("#diastolic_val").html(diastolic)
            $("#bp_date").html(date)
            $("#blood_pressure_section").parent().removeClass("hide")

            $('#Fasting_blood_sugar_id').text(blood_sugar);
            $('#blood_sugar_date').html(date);
            $("#blood_sugar_section").parent().removeClass("hide")

            $("#recent_assessment_val").html('Body')
            $("#recent_assessment_date").html(date)
            $("#recent_body_assessment_section").parent().removeClass("hide")

            nextTab('#health_information');
        }
        else{}
    })

    if(!$('#height_weight').hasClass("hide")){
        $( "#weight" ).mouseout(function() {
            if($('#weight').val()=='')
                addParsleyError('#weight','Enter weight value');
            else{
                $('#weight').parsley().destroy();                
                if(is_bmi_tab_complete()){
                    var bmi=get_bmi()
                    $('#height-weight-message').text(updateMessagePrompt(bmi,'bmi'));
                }
            }
        });
        $( "#feet" ).mouseout(function() {
            if($('#feet').val()=='')
                addParsleyError('#feet','Enter feet');
            else{
                $('#feet').parsley().destroy();
                if(is_bmi_tab_complete()) {
                    var bmi=get_bmi()
                    $('#height-weight-message').text(updateMessagePrompt(bmi,'bmi'));
                }
            }
        });
        $( "input#inches" ).mouseout(function() {
            if($('#inches').val()=='')
                addParsleyError('#inches','Enter inches');
            else{
                $('#inches').parsley().destroy();
                if(is_bmi_tab_complete()) {
                    var bmi=get_bmi()
                    $('#height-weight-message').text(updateMessagePrompt(bmi,'bmi'));
                }
            }
        });
    }

    if(!$('#waist_bloodgroup_next').hasClass("hide")){
        $( "#waist_size" ).mouseout(function() {
            if($('#waist_size').val()=='')
                addParsleyError('#waist_size','Enter waist value');
            else{
                $('#waist_size').parsley().destroy();
                $("#waist-bloodgroup-message").text(updateMessagePrompt($("#waist_size").val(),'waist'))
            }
        });

        $('#blood_group_choice').click(function(){
            var blood_group_id=$('.ekin-choice').filter('.selected.blood-group').attr('id');
            $("#waist-bloodgroup-message").text(updateMessagePrompt(blood_group_id, 'blood_group'))
        });
    }

    if(!$('#activities_next').hasClass("hide")) {
        $('#alcohol-choices-id').click(function () {
            var alcohol_status=$('.ekin-choice').filter('.selected.alcohol').attr('value');
            $("#activities-message").text(updateMessagePrompt(alcohol_status, 'alcohol'))
        });
        $('#smoke-choices-id').click(function () {
            var smoke_status=$('.ekin-choice').filter('.selected.smoke').attr('value');
            $("#activities-message").text(updateMessagePrompt(smoke_status,'smoke'))
        });
        $('#exercise-choices-id').click(function () {
            var exercise_status=$('.ekin-choice').filter('.selected.exercise').attr('value');
            $("#activities-message").text(updateMessagePrompt(exercise_status,'exercise'))
        });
    }

    if(!$('#family_medical_history_next').hasClass("hide")) {
        $('#mother_health_info').click(function () {
            var mother_medical_condition=$('.ekin-multi-choice').filter('.selected.mother-medical-history').text();
            $("#family-info-message").text(updateMessagePrompt(mother_medical_condition,'parent'))
        });
        $('#father_health_info').click(function () {
            var father_medical_condition=$('.ekin-multi-choice').filter('.selected.father-medical-history').text();
            $("#family-info-message").text(updateMessagePrompt(father_medical_condition,'parent'))
        });
    }




    if(!$('health_information_finish').hasClass("hide")) {
        $( "#systolic" ).blur(function() {
            if($('#systolic').val()=='')
                addParsleyError('#systolic','Enter systolic value');
            else{
                $('#systolic').parsley().destroy();
                //$("#health-info-message").text('you entered systolic value '+$('#systolic').val())
            }
        });
        $( "#diastolic" ).blur(function() {
            if($('#diastolic').val()=='')
                addParsleyError('#diastolic','Enter diastolic');
            else{
                $('#diastolic').parsley().destroy();
                //$("#health-info-message").text('you entered diastolic value '+$('#diastolic').val())
            }
        });
        $("input#blood_sugar" ).mouseout(function() {
            if($('#blood_sugar').val()=='')
                addParsleyError('#blood_sugar','Enter Blood sugar');
            else{
                $('#blood_sugar').parsley().destroy();
                //$("#health-info-message").text('you entered blood_sugar value '+$('#blood_sugar').val())
            }
        });
    }


    $(".numeric").keydown(function (e) {
        // Allow: backspace, delete, tab, escape, enter and .
        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
                // Allow: Ctrl+A
            (e.keyCode == 65 && e.ctrlKey === true) ||
                // Allow: home, end, left, right, down, up
            (e.keyCode >= 35 && e.keyCode <= 40)) {
            // let it happen, don't do anything
            return;
        }
        // Ensure that it is a number and stop the keypress
        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
            addParsleyError('#'+this.id,'Enter numeric value');
            e.preventDefault();
        }
        else {
            $('#'+this.id).parsley().destroy();
        }
    });

    $('.father-medical-history').click(function(){
        $('#father_medical_error').addClass('hide');
    });

    $('.mother-medical-history').click(function(){
        $('#mother_medical_error').addClass('hide');
    });

    //$('.father-health-none-record').click(function(){
    //    alert('here');
    //    $('.father-health-records').filter('.selected.father-medical-history').each(function(){
    //        alert(this.id)
    //        $('#'+this.id).removeClass('selected')
    //    })
    //});

//*************************************************end of validations **************************************************

//$(document).ready(function(){
//    getMessagePrompts();
//});


    function updateMessagePrompt(value, type)
    {
        $('#initial_message').html('');
        switch(type)
        {
            case 'height':
                $('#height-weight-message').html(prepareMessagePrompt(risk_factors_data.message.height['normal_value'],
                    risk_factors_data.message.height['normal_image']));
                break;
            case 'bmi':
                var bmi =value;
                if(bmi < 15)
                {
                    return risk_factors_data.message.bmi['<15_value'];
                }
                else if(bmi >= 15 && bmi <= 16)
                {
                    return risk_factors_data.message.bmi['15-16_value'];
                }
                else if(bmi > 16 && bmi <= 18.5)
                {
                    return risk_factors_data.message.bmi['16-18.5_value'];
                }
                else if(bmi > 18.5 && bmi <= 25)
                {
                    return risk_factors_data.message.bmi['18.5-25_value'];
                }
                else if(bmi > 25 && bmi <= 30)
                {
                    return risk_factors_data.message.bmi['25-30_value'];
                }
                else if(bmi > 30 && bmi <= 35)
                {
                    return risk_factors_data.message.bmi['30-35_value'];
                }
                else if(bmi > 35 && bmi <= 40)
                {
                    return risk_factors_data.message.bmi['35-40_value'];
                }
                else if(bmi > 40)
                {
                    return risk_factors_data.message.bmi['>40_value'];
                }
                break;
            case 'waist':
                var waist_in_cms = Math.round(value * 2.54);
                if(risk_factors_data.message.waist['<94_value'].length > 0) {
                    if (waist_in_cms < 94) {
                        return risk_factors_data.message.waist['<94_value'];
                    }
                    else if (waist_in_cms >= 94 && waist_in_cms <= 102) {
                        return risk_factors_data.message.waist['94-102_value'];
                    }
                    else if (waist_in_cms > 102) {
                        return risk_factors_data.message.waist['>102_value'];
                    }
                }
                else
                {
                    if (waist_in_cms < 80) {
                        return risk_factors_data.message.waist['<80_value'];
                    }
                    else if (waist_in_cms >= 80 && waist_in_cms <= 88) {
                        return risk_factors_data.message.waist['80-88_value'];
                    }
                    else if (waist_in_cms > 88) {
                        return risk_factors_data.message.waist['>88_value'];
                    }
                }
                break;
            case 'blood_group':
                return risk_factors_data.message.blood_group[value.trim()+'_value'];
                break;
            case 'smoke':
                return risk_factors_data.message.smoke[value.toLowerCase()+'_value'];
                break;
            case 'alcohol':
                return risk_factors_data.message.alcohol[value.toLowerCase()+'_value'];
                break;
            case 'exercise':
                return risk_factors_data.message.exercise[value.toLowerCase()+'_value'];
                break;
            case 'parent':
                return risk_factors_data.message.parent[value.toLowerCase().trim()+'_value'];
        }
    }
}


