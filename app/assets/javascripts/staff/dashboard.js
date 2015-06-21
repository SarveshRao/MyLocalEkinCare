$(function(){

var getCompanyData=function(url,type,data){
    var companydata = {}
    $.ajax({
        url:url,
        type: type ,
        data: data,
        async: false,
        success: function (result) {
            companydata=result;
        },
        error: function(xhr, status, error) {
        }
    });
    return companydata;
}

var drawCompanyChart=function(id, data){
    $(id).length && $.plot($(id), data, {
        series: {
            pie: {
                innerRadius: 0.4,
                show: true,
                stroke: {
                    width: 0
                },
                label: {
                    show: true,
                    threshold: 0.05
                }
            }
        },
        colors: ["#88C057","#FFC107","#EC2045"],
        grid: {
            hoverable: true,
            clickable: false
        },
        tooltip: true,
        tooltipOpts: {
            content: "%s: %p.0%",
            defaultTheme: false
        }
    });
}

if($('#company-wizard').length>0){
  // pie

    var data1 =  getCompanyData("/staff/company_login/weight","GET",{gender:"All",range1:"All",range2:"All"})
    var data2 =  getCompanyData("/staff/company_login/hypertensive","GET",{gender:"All",range1:"All",range2:"All"})
    var data3 =  getCompanyData("/staff/company_login/diabetic","GET",{gender:"All",range1:"All",range2:"All"})

    if (data1.Healthy!=0 || data1.Overweight!=0 || data1.Obese!=0) {
        var weight_data = [
            {
                label: "Normal",
                data: data1.Healthy
            },
            {
                label: "Overweight",
                data: data1.Overweight
            },
            {
                label: "Obese",
                data: data1.Obese                
            }
        ];
        drawCompanyChart("#flot-donut-weight", weight_data)
    }else{
        $("#flot-donut-weight").html($('<img src="/assets/company_no_data.png"/>'))
    }

    if (data3.Healthy!=0 || data3.pre_diabetic!=0 || data3.Diabetic!=0) {
        var diabetes_data = [
            {
                label: "Non Diabetic",
                data: data3.Healthy
            },
            {
                label: "Pre Diabetic",
                data: data3.pre_diabetic
            },
            {
                label: "Diabetic",
                data: data3.Diabetic
            }
        ];

        drawCompanyChart("#flot-donut-diabetes", diabetes_data)
    }else{
        $("#flot-donut-diabetes").html($('<img src="/assets/company_no_data.png"/>'))
    }

    if(data2.Healthy!=0 || data2.pre_hypertensive!=0 || data2.Hypertension!=0) {
        var hypertension_data = [
            {
                label: "Non Hypertensive",
                data: data2.Healthy
            },
            {
                label: "Pre Hypertensive",
                data: data2.pre_hypertensive
            },
            {
                label: "Hypertensive",
                data: data2.Hypertension
            }
        ];
        drawCompanyChart("#flot-donut-hypertension", hypertension_data)
    }else{
        $("#flot-donut-hypertension").html($('<img src="/assets/company_no_data.png"/>'))
    }


    $(".weight_gender_dropdown > li").click(function(){

        //var gender = $(".weight_gender_dropdown .active > a > input").attr("value");
        var gender = $(this).find("input").first().attr("value")
        var range
        var rangeVal
        if($(".weight_age_dropdown > li.active").find("input").first().attr("value")){
            range = $(".weight_age_dropdown > li.active").find("input").first().attr("value");
        }else{
            range = $(".weight_age_dropdown > li").find("input").first().attr("value");
        }
        if(range.split(",")!=-1) {
            rangeVal = range.split(",");
        }else{
            rangeVal = range
        }
        var data1 =  getCompanyData("/staff/company_login/weight","GET",{gender:gender,range1:rangeVal[0],range2:rangeVal[1]});

        if (data1.Healthy!=0 || data1.Overweight!=0 || data1.Obese!=0){
            var weight_data = [
                {
                    label: "Normal",
                    data: data1.Healthy
                },
                {
                    label: "Overweight",
                    data: data1.Overweight
                },
                {
                    label: "Obese",
                    data: data1.Obese
                }
            ];
            drawCompanyChart("#flot-donut-weight", weight_data)
        }else{
            $("#flot-donut-weight").html($('<img src="/assets/company_no_data.png"/>'))
        }
    });

    $(".weight_age_dropdown > li").click(function() {

        //var gender = $(".weight_gender_dropdown .active > a > input").attr("value");

        if ($(".weight_gender_dropdown > li.active").find("input").first().attr("value")) {
            var gender = $(".weight_gender_dropdown > li.active").find("input").first().attr("value");
        } else {
            var gender = $(".weight_gender_dropdown > li").find("input").first().attr("value");
        }
        var range = $(this).find("input").first().attr("value");
        var rangeVal
        if (range.split(",") != -1) {
            rangeVal = range.split(",");
        }else{
            rangeVal = range
        }
        var data1 =  getCompanyData("/staff/company_login/weight","GET",{gender:gender,range1:rangeVal[0],range2:rangeVal[1]});

        if (data1.Healthy!=0 || data1.Overweight!=0 || data1.Obese!=0) {
            var weight_data = [
                {
                    label: "Normal",
                    data: data1.Healthy
                },
                {
                    label: "Overweight",
                    data: data1.Overweight
                },
                {
                    label: "Obese",
                    data: data1.Obese
                }
            ];
            drawCompanyChart("#flot-donut-weight", weight_data)
        }else{
            $("#flot-donut-weight").html($('<img src="/assets/company_no_data.png"/>'))
        }
    });

    $(".Hypertension_gender_dropdown > li").click(function(){
        var gender = $(this).find("input").first().attr("value")
        var range
        var rangeVal
        if($(".Hypertension_age_dropdown > li.active").find("input").first().attr("value")){
            range = $(".Hypertension_age_dropdown > li.active").find("input").first().attr("value");
        }else{
            range = $(".Hypertension_age_dropdown > li").find("input").first().attr("value");
        }
        if(range.split(",")!=-1) {
            rangeVal = range.split(",");
        }else{
            rangeVal = range
        }
        var data =  getCompanyData("/staff/company_login/hypertensive","GET",{gender:gender,range1:rangeVal[0],range2:rangeVal[1]});
        if(data.Healthy!=0 || data.pre_hypertensive!=0 || data.Hypertension!=0) {
            var hypertension_data = [
                {
                    label: "Non Hypertensive",
                    data: data.Healthy
                },
                {
                    label: "Pre Hypertensive",
                    data: data.pre_hypertensive
                },
                {
                    label: "Hypertensive",
                    data: data.Hypertension
                }
            ];
            drawCompanyChart("#flot-donut-hypertension", hypertension_data)
        }else{
            $("#flot-donut-hypertension").html($('<img src="/assets/company_no_data.png"/>'))
        }
    });

    $(".Hypertension_age_dropdown > li").click(function() {

        if ($(".Hypertension_gender_dropdown > li.active").find("input").first().attr("value")) {
            var gender = $(".Hypertension_gender_dropdown > li.active").find("input").first().attr("value");
        } else {
            var gender = $(".Hypertension_gender_dropdown > li").find("input").first().attr("value");
        }
        var range = $(this).find("input").first().attr("value");
        var rangeVal
        if (range.split(",") != -1) {
            rangeVal = range.split(",");
        }else{
            rangeVal = range
        }
        var data =  getCompanyData("/staff/company_login/hypertensive","GET",{gender:gender,range1:rangeVal[0],range2:rangeVal[1]});
        if(data.Healthy!=0 || data.pre_hypertensive!=0 || data.Hypertension!=0) {
            var hypertension_data = [
                {
                    label: "Non Hypertensive",
                    data: data.Healthy
                },
                {
                    label: "Pre Hypertensive",
                    data: data.pre_hypertensive
                },
                {
                    label: "Hypertensive",
                    data: data.Hypertension
                }
            ];
            drawCompanyChart("#flot-donut-hypertension", hypertension_data)
        }else{
            $("#flot-donut-hypertension").html($('<img src="/assets/company_no_data.png"/>'))
        }
    });

    $(".Diabetes_gender_dropdown > li").click(function(){
        var gender = $(this).find("input").first().attr("value")
        var range
        var rangeVal
        if($(".Diabetes_age_dropdown > li.active").find("input").first().attr("value")){
            range = $(".Diabetes_age_dropdown > li.active").find("input").first().attr("value");
        }else{
            range = $(".Diabetes_age_dropdown > li").find("input").first().attr("value");
        }
        if(range.split(",")!=-1) {
            rangeVal = range.split(",");
        }else{
            rangeVal = range
        }
        var data =  getCompanyData("/staff/company_login/diabetic","GET",{gender:gender,range1:rangeVal[0],range2:rangeVal[1]});
        if(data.Healthy!=0 || data.pre_diabetic!=0 || data.Diabetic!=0) {
            var diabetes_data = [
                {
                    label: "Non Diabetic",
                    data: data.Healthy
                },
                {
                    label: "Pre Diabetic",
                    data: data.pre_diabetic
                },
                {
                    label: "Diabetic",
                    data: data.Diabetic
                }
            ];
            drawCompanyChart("#flot-donut-diabetes", diabetes_data)
        }else{
            $("#flot-donut-diabetes").html($('<img src="/assets/company_no_data.png"/>'))
        }
    });

    $(".Diabetes_age_dropdown > li").click(function() {

        if ($(".Diabetes_gender_dropdown > li.active").find("input").first().attr("value")) {
            var gender = $(".Diabetes_gender_dropdown > li.active").find("input").first().attr("value");
        } else {
            var gender = $(".Diabetes_gender_dropdown > li").find("input").first().attr("value");
        }
        var range = $(this).find("input").first().attr("value");
        var rangeVal
        if (range.split(",") != -1) {
            rangeVal = range.split(",");
        }else{
            rangeVal = range
        }
        var data =  getCompanyData("/staff/company_login/diabetic","GET",{gender:gender,range1:rangeVal[0],range2:rangeVal[1]});
        if(data.Healthy!=0 || data.pre_diabetic!=0 || data.Diabetic!=0) {
            var diabetes_data = [
                {
                    label: "Non diabetic",
                    data: data.Healthy
                },
                {
                    label: "Pre Diabetic",
                    data: data.pre_diabetic
                },
                {
                    label: "Diabetic",
                    data: data.Diabetic
                }
            ];
            drawCompanyChart("#flot-donut-diabetes", diabetes_data)
        }else{
            $("#flot-donut-diabetes").html($('<img src="/assets/company_no_data.png"/>'))
        }
    });


}
});

$(".employee_filter input").click(function(){
    $(this).toggleClass("optionSelected");
    var count = 0;
    $(".employee_filter").each(function(i){

        if($(this).find("input").first().attr("class")=="optionSelected"){
            count+=parseInt($(this).find("input").first().attr("data_value"));
        }

    })
    $("#employee_number").text(""+count);
})

$("#company_checkbox_action input").click(function(){
    test1=[];
    $(".employee_filter .optionSelected").each(function(){test1.push($(this).attr("data_value"))});
    $.ajax({
        url:"/staff/company_login/getanalysis",
        type: 'GET' ,
        data:{ options: test1 },
        async: false,
        success: function (result) {
            $("#employee_number").text(""+result.option_selected+"/"+result.total_customers);
        },
        error: function(xhr, status, error) {
        }
    });

})
