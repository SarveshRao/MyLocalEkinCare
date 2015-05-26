$(document).ready(function(){
    $(".teeth-marker").addClass("hide");
    $(".teeth-marker").css("visibility","visible");
    if(typeof result === "undefined"){

    }
    else {
        if (result) {
            var res = JSON.parse(result);

            for (var i = 0; i < res.length; i++) {
                var teeth = res[i][0]
                //var teeth_cls = ".teeth-marker:eq(" + teeth + ")"
                id='#teeth'+teeth
                $(id).removeClass("hide");
            }


            //$(".teeth-marker:eq(2)").removeClass("hide");
            //$(".teeth-marker:eq(7)").removeClass("hide");
            //$(".teeth-marker:eq(12)").removeClass("hide");
            //$(".teeth-marker:eq(14)").removeClass("hide");
            //$(".teeth-marker:eq(9)").removeClass("hide");
            //$(".teeth-marker:eq(19)").removeClass("hide");
            //$(".teeth-marker:eq(21)").removeClass("hide");
            //$(".teeth-marker:eq(22)").removeClass("hide");
            //$(".teeth-marker:eq(25)").removeClass("hide");
            //$(".teeth-marker:eq(28)").removeClass("hide");
            //$(".teeth-marker:eq(31)").removeClass("hide");

            //var teeth = [11, 12, 13, 14, 15, 16, 17, 18, 21, 22, 23, 24, 25, 26, 27, 28, 31, 32, 33, 34, 35, 36, 37, 38, 41, 42, 43, 44, 45, 46, 47, 48];
            var drop = new Array();

            for (var i = 0; i < res.length; i++) {
                if($('#teeth' + res[i][0]).length>0) {
                    drop[i] = new Drop({
                        target: $('#teeth' + res[i][0])[0],
                        content: '<strong>Dentition</strong> :' + res[i][1] + '<br/><strong>Tooth Number</strong> : ' + res[i][0] + '<br/><strong>Diagonsis</strong>: <span style="font-style:italic">' + res[i][2] + '</span><br/><strong>Recommendation</strong>: <span style="font-style:italic;">' + res[i][3] + '</span>',
                        classes: 'drop-theme-arrows-bounce',
                        position: 'bottom center',
                        constrainToScrollParent: true,
                        openOn: 'click'
                    });
                }
            }

            //drop[4].open();
        }
    }
});


