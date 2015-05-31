$(function() {
    var SECONDS_BETWEEN_FRAMES, cFrameWidth, cHeight, cImageSrc, cImageTimeout, cIndex, cPreloaderTimeout, cSpeed, cTotalFrames, cWidth, cXpos;
    cSpeed = 12;
    cWidth = 256;
    cHeight = 50;
    cTotalFrames = 21;
    cFrameWidth = 256;
    cImageSrc = '../assets/sprites.gif';
    cImageTimeout = false;
    cIndex = 0;
    cXpos = 0;
    cPreloaderTimeout = false;
    SECONDS_BETWEEN_FRAMES = 0;
    cLoaderId = 'loaderPageImage';
    window.startAnimation = function(loader) {
        cIndex = 0;
        cXpos = 0;
        var FPS;
        document.getElementById(cLoaderId).style.backgroundImage = 'url(' + cImageSrc + ')';
        document.getElementById(cLoaderId).style.width = cWidth + 'px';
        document.getElementById(cLoaderId).style.height = cHeight + 'px';
        document.getElementById(cLoaderId).style.backgroundSize='cover';
        FPS = Math.round(100 / cSpeed);
        SECONDS_BETWEEN_FRAMES = 1 / FPS;
        if(loader == 'page')
            cPreloaderTimeout = setTimeout('window.continueAnimationForPage()', SECONDS_BETWEEN_FRAMES / 1000);
        if(loader == 'upload') {
            document.getElementById(cLoaderId).style.marginLeft=23+'px';
            cPreloaderTimeout = setTimeout('window.continueAnimationForUpload()', SECONDS_BETWEEN_FRAMES / 1000);
        }
    };
    window.continueAnimationForPage = function() {
        cXpos += cFrameWidth;
        cIndex += 1;
        if (cIndex >= cTotalFrames) {
            cXpos = 0;
        }
        cIndex = 0;
        if (document.getElementById(cLoaderId)) {
            document.getElementById(cLoaderId).style.backgroundPosition = -cXpos + 'px 0';
        }
        cPreloaderTimeout = setTimeout('window.continueAnimationForPage()', SECONDS_BETWEEN_FRAMES * 1000);
    };

    window.continueAnimationForUpload = function() {

        cXpos += cFrameWidth;
        //increase the index so we know which frame of our animation we are currently on
        cIndex += 1;

        //if our cIndex is higher than our total number of frames, we're at the end and should restart
        if (cIndex >= cTotalFrames) {
            cXpos =0;
            cIndex=0;
        }

        if(document.getElementById(cLoaderId))
            document.getElementById(cLoaderId).style.backgroundPosition=(-cXpos)+'px 0';

        cPreloaderTimeout=setTimeout('continueAnimationForUpload()', SECONDS_BETWEEN_FRAMES*1000);
    };

    window.stopAnimation = function() {
        clearTimeout(cPreloaderTimeout);
        cPreloaderTimeout = false;
    };
    window.imageLoader = function(fun, cLoaderId_new, cSpeed_new, cWidth_new, cHeight_new, cTotalFrames_new, cFrameWidth_new, cImageSrc_new) {
        var genImage;
        cSpeed = cSpeed_new;
        cWidth = cWidth_new;
        cHeight = cHeight_new;
        cTotalFrames = cTotalFrames_new;
        cFrameWidth = cFrameWidth_new;
        cImageSrc = cImageSrc_new;
        cLoaderId = cLoaderId_new;
        clearTimeout(cImageTimeout);
        cImageTimeout = 0;
        genImage = new Image;
        genImage.onload = function() {};
        cImageTimeout = setTimeout(fun, 0);
    };

    $('.start_loader').click(function(){
        window.stopAnimation();
        var cSpeed_new1 = 12;
        var cWidth_new1 = 256;
        var cHeight_new1 = 50;
        var cTotalFrames_new1 = 21;
        var cFrameWidth_new1 = 256;
        var cImageSrc_new1 = '../../assets/sprites_page_loader.gif';
        var cLoaderId1 = 'loaderPageImage';
        window.imageLoader('window.startAnimation("page")', cLoaderId, cSpeed_new1, cWidth_new1, cHeight_new1, cTotalFrames_new1, cFrameWidth_new1, cImageSrc_new1);
    });

    function check_file(){
        str = $('.uploaded_medical_record').val().toUpperCase();
        suffix = '.JPG';
        suffix1 = '.JPEG';
        suffix2 = '.PNG';
        suffix3 = '.PDF';
        suffix4 = '.DOC';
        suffix5 = '.XLS';
        suffix6 = '.GIF';
        if(str.indexOf(suffix) == -1 && str.indexOf(suffix1) == -1 && str.indexOf(suffix2) == -1 && str.indexOf(suffix3) == -1 && str.indexOf(suffix4) == -1 && str.indexOf(suffix5) == -1 && str.indexOf(suffix6) == -1){
            alert('File type not allowed,\nAllowed files: jpg, jpeg, png, gif, pdf, doc, docx, xls, xlsx');
            $('.uploaded_medical_record').val('');
            return false;
        }else{
            return true;
        }
    }

    $('.start_upload_loader').click(function(e){
        if (check_file()) {
            window.stopAnimation();
            var cSpeed_new2 = 7;
            var cWidth_new2 = 32;
            var cHeight_new2 = 32;
            var cTotalFrames_new2 = 23;
            var cFrameWidth_new2 = 32;
            var cImageSrc_new2 = '../assets/sprites_upload_loader.gif';
            var cLoaderId2 = 'loaderUploadImage';
            window.imageLoader('window.startAnimation("upload")', cLoaderId2, cSpeed_new2, cWidth_new2, cHeight_new2, cTotalFrames_new2, cFrameWidth_new2, cImageSrc_new2);
        }else{

            return false;
        }

    });
    window.stopAnimation();
});