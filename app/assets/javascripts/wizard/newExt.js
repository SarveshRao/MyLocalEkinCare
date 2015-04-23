// JavaScript Document

$(document).ready(function(e) {
//	$('.file-item').click(function(e) {
//        alert('delete this file');
//    });

    function showLoading(){
        $('#upload-gif').css('display','block');
    }
    function hideLoading(){
        $('#upload-gif').css('display','none');
    }

//    $("input:file").change(function (){
// 		showLoading();
//		setTimeout(
//        function()
//        {
           //do something special
//		   hideLoading();
//        }, 2000);
 		
		/*$.ajax({
			type: "POST",
			url: "upload.php",
			enctype: 'multipart/form-data',
			data: {
				file: myfile
			},
			success: function () {
			    //call hide function here
			    hideLoading();
				alert("Data has been Uploaded: ");
			}
		 });
    */
//	});
});
	
// validations
$(document).ready(function(e) {
	
	$('.in-val').text($("input[name='customer[inches]']").val());
	$('.ft-val').text($("input[name='customer[feet]']").val());
	
	
	
	$('#reg1').submit(function(e) {
		var validation = true;
		var family = true;

		
		// HEIGHT
		if(!$('.wt-inp').val() || $('.wt-inp').val().length > 3 || !$("input[name='customer[feet]']:checked").val() || !$("input[name='customer[inches]']:checked").val()){
			$('.alert-height').css('display','block');
			validation = false;
  		}
		else{
			$('.alert-height').css('display','none');
		}
		

		// LIFESTYLE
//		if (!$("input[name='smoke']:checked").val()) {
//            alert($("input[name='smoke']:checked").val())
//			$('.alert-smoke').css('display','block');
//			validation = false;
//  		}
//		else{
//			$('.alert-smoke').css('display','none');
//		}
//
//		if (!$("input[name='alcohol']:checked").val()) {
//		   $('.alert-alcohol').css('display','block');
//		   validation = false;
//		}
//		else{
//			$('.alert-alcohol').css('display','none');
//		}
//
//		if (!$("input[name='exercise']:checked").val()) {
//			 $('.alert-exercise').css('display','block');
//		     validation = false;
//		}
//		else{
//			$('.alert-exercise').css('display','none');
//		}
		 
		 
		// FAMILY
		if (!$("input[name='mother']:checked").val()) {
		 	 $('.alert-family').css('display','block');
			 makeActive('mother');
		     validation = false;
			 family = false;
		}
		 
		
		if (!$("input[name='father']:checked").val()) {
		 	 $('.alert-family').css('display','block');
			 makeActive('father');
		     validation = false;
			 family = false;
		}
		
		if(family){
			$('.alert-family').css('display','none');
		}
		
		//LOCATION
		if(!$('.zip-inp').val() || $('.zip-inp').val().length!=6 ){
			$('.zip-inp').css('border-color','#F00');
			$('.alert-zip').css('display','block');
			validation = false;
  		}
		else{
			$('.zip-inp').css('border-color',' #CCC');
			$('.alert-zip').css('display','none');
		}
		
 		if(validation){
//			$('#reg1').submit();
            return true;
		}
		else{
//			$( "#profile" ).effect( "shake" );
            return false;
		}
    });
	
function makeActive(input){
 	$('.father-tab').removeClass( "active" );
	$('.mother-tab').removeClass( "active" );
	$('.sibling-tab').removeClass( "active" );
 	$('#father').removeClass( "active" );
	$('#mother').removeClass( "active" );
	$('#sibling').removeClass( "active" );
	
	$("."+input+"-tab").addClass( "active" );
	$("#"+input).addClass( "active" );
	
}
});
