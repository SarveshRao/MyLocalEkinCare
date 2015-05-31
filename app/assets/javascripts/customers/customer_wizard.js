
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


//*****************************no modifications required******************
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

var getMessagePrompts=function(current_tab){
    var risk_factors_data=null;
    $.ajax({
        url: "/customers/customer_information/get_message_prompts",
        type: "GET",
        data:{tab:current_tab},
        async: false,
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
        data:data,
        success: function (result) {
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
//********************************************************************************
customer_data=getCustomerInfo();
modified_data=[]



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
            if(is_available('health_information')){
                nextTab("#health_information");
            }
            else{
                $('#health_information').removeClass('hide');
                $("#health_information").siblings().addClass('hide');
            }
            break;
        case "#health_information":
                $("#customer-info-wizard").addClass('hide');
                $("#hypertension_score_chart").removeClass('hide');
                $('#diabetes_score_chart').removeClass('hide');
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

    if(customer_data.feet==null || customer_data.inches==null || customer_data.weight==null || customer_data.blood_group || customer_data.waist==null || customer_data.smoke==null || customer_data.alcohol==null || customer_data.exercise==null || customer_data.father_health==false || customer_data.mother_health==false){
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
}


var load_wizard=function(){

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
        $('#feet_val').html(feet)
        $('#inches_val').html(inches)
        $('#height_date').html(date)
        $('#height_section').parent().removeClass('hide')
        $('#weight_val').html(weight)
        $('#weight_section').parent().removeClass('hide')
        $('#weight_date').html(date)
        $('#bmi_date').html(date)
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
    $('.ekin-multi-choice').filter('.selected.father-medical-history').each(function()
    {
        father_health_history.push(this.id)
    })
    $('.ekin-multi-choice').filter('.selected.mother-medical-history').each(function()
    {
        mother_health_history.push(this.id)
    })
    if(father_health_history.length==0 || mother_health_history.length==0){
        $('#family_medical_history').addClass('hide');
        modified_data.push('family_medical_history');
        nextTab("#family_medical_history");
    }
    else if(insert_data("/customers/family_medical_histories","POST",{ family_medical_history:{relation:'Mother'},'chk-family_medicals': mother_health_history}) &&
        insert_data("/customers/family_medical_histories","POST",{ family_medical_history:{relation:'Father'},'chk-family_medicals': father_health_history})){
        modified_data.push('family_medical_history');
        nextTab("#family_medical_history");
    }
    else{
    }
})

$("#health_information_skip").click(function(){
    $('#health_information').addClass('hide');
    nextTab('#health_information');
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
        $('#health_information').addClass('hide');
        modified_data.push('health_information');
        nextTab('#health_information');
    }
    else{}
})

if(!$('#height_weight').hasClass("hide")){
    $( "#weight" ).blur(function() {
        if($('#weight').val()=='')
            addParsleyError('#weight','Enter weight value');
        else{
            $('#weight').parsley().destroy();
            $("#height-weight-message").text('you entered weight value '+$('#weight').val())
        }
    });
    $( "#feet" ).blur(function() {
        if($('#feet').val()=='')
            addParsleyError('#feet','Enter feet');
        else{
            $('#feet').parsley().destroy();
            $("#height-weight-message").text('you entered feet value '+$('#feet').val())
        }
    });
    $( "input#inches" ).mouseout(function() {
        if($('#inches').val()=='')
            addParsleyError('#inches','Enter inches');
        else{
            $('#inches').parsley().destroy();
            $("#height-weight-message").text('you entered inches value '+$('#inches').val())
        }
    });
}

//condition should be modified
if(!$('#waist_bloodgroup_next').hasClass("hide")){
    $( "#waist_size" ).mouseout(function() {
        if($('#waist_size').val()=='')
            addParsleyError('#waist_size','Enter waist value');
        else{
            $('#waist_size').parsley().destroy();
            $("#waist-bloodgroup-message").text('you entered waist value '+$("#waist_size").val())
        }
    });

    $('#blood_group_choice').click(function(){
        var blood_group_id=$('.ekin-choice').filter('.selected.blood-group').attr('id');
        $("#waist-bloodgroup-message").text('you selected blood group id '+blood_group_id)
    });
}

//condition should be modified
if(!$('#activities_next').hasClass("hide")) {
    $('#alcohol-choices-id').click(function () {
        var alcohol_status=$('.ekin-choice').filter('.selected.alcohol').attr('value');
        $("#activities-message").text('you entered alcohol status '+alcohol_status)
    });
    $('#smoke-choices-id').click(function () {
        var smoke_status=$('.ekin-choice').filter('.selected.smoke').attr('value');
        $("#activities-message").text('you entered smoke status '+smoke_status)
    });
    $('#exercise-choices-id').click(function () {
        var exercise_status=$('.ekin-choice').filter('.selected.exercise').attr('value');
        $("#activities-message").text('you entered exercise_status '+exercise_status)
    });
}

if(!$('#family_medical_history_next').hasClass("hide")) {
    $('#mother_health_info').click(function () {
        var mother_medical_condition=$('.ekin-multi-choice').filter('.selected.mother-medical-history').attr('id')
        $("#family-info-message").text('you selected mother medical condition '+mother_medical_condition)
    });
    $('#father_health_info').click(function () {
        var father_medical_condition=$('.ekin-multi-choice').filter('.selected.father-medical-history').attr('id')
        $("#family-info-message").text('you selected father medical condition '+father_medical_condition);
    });
}

//condition should be modified
if(!$('health_information_finish').hasClass("hide")) {
    $( "#systolic" ).blur(function() {
        if($('#systolic').val()=='')
            addParsleyError('#systolic','Enter systolic value');
        else{
            $('#systolic').parsley().destroy();
            $("#health-info-message").text('you entered systolic value '+$('#systolic').val())
        }
    });
    $( "#diastolic" ).blur(function() {
        if($('#diastolic').val()=='')
            addParsleyError('#diastolic','Enter diastolic');
        else{
            $('#diastolic').parsley().destroy();
            $("#health-info-message").text('you entered diastolic value '+$('#diastolic').val())
        }
    });
    $("input#blood_sugar" ).mouseout(function() {
        if($('#blood_sugar').val()=='')
            addParsleyError('#blood_sugar','Enter Blood sugar');
        else{
            $('#blood_sugar').parsley().destroy();
            $("#health-info-message").text('you entered blood_sugar value '+$('#blood_sugar').val())
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

//*************************************************end of validations **************************************************