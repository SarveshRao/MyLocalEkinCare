$(document).ready(function(){

     if($(".l-ucva").length>0)   {
        lDropUcva = new Drop({
            target: document.querySelector('.l-ucva'),
            content: 'UCVA stands for Uncorrected Visual',
            classes: 'drop-theme-arrows-bounce',
            position: 'top center',
            constrainToScrollParent: true,
            openOn: 'hover'
        });
    }

    if($(".l-sphe").length>0){
        lDropSphe = new Drop({
            target: document.querySelector('.l-sphe'),
            content: 'This number measurement reflects the extent of the nearsightedness or farsightedness.',
            classes: 'drop-theme-arrows-bounce',
            position: 'top center',
            constrainToScrollParent: true,
            openOn: 'hover'
        });
    }


    if($(".l-cyl").length>0){
        lDropCyl = new Drop({
            target: document.querySelector('.l-cyl'),
            content: 'This number measurement refers to the amount of astigmatism (an irregularly cornea which causes blurring) in the eye.',
            classes: 'drop-theme-arrows-bounce',
            position: 'top center',
            constrainToScrollParent: true,
            openOn: 'hover'
        });
    }

    if($(".l-axis").length>0){
        lDropAxis = new Drop({
            target: document.querySelector('.l-axis'),
            content: 'This number measurement describes the astigmatism in degrees from the horizontal (most left and right eyes have the same axis in astigmatism) axis.',
            classes: 'drop-theme-arrows-bounce',
            position: 'top center',
            constrainToScrollParent: true,
            openOn: 'hover'
        });
    }

    if($(".l-add").length>0){
        lDropAdd = new Drop({
            target: document.querySelector('.l-add'),
            content: 'If you are over 45, there may be a number where it says ‘ADD’. This is your reading addition and relates to the amount of additional correction needed to focus at close distances. If a measurement is shown in this section, it means you have different prescriptions for distance and reading. Bifocal or varifocal lenses may be needed.',
            classes: 'drop-theme-arrows-bounce',
            position: 'top center',
            constrainToScrollParent: true,
            openOn: 'hover'
        });
    }


//     lDropCva = new Drop({
//              target: document.querySelector('.r-cva'),
//              content: '',
//              classes: 'drop-theme-arrows-bounce',
//              position: 'top center',
//              constrainToScrollParent: true,
//              openOn: 'hover'
//            });
//
    if($(".r-ucva").length>0){
        rDropUcva = new Drop({
            target: document.querySelector('.r-ucva'),
            content: 'UCVA stands for Uncorrected Visual',
            classes: 'drop-theme-arrows-bounce',
            position: 'top center',
            constrainToScrollParent: true,
            openOn: 'hover'
        });
    }

    if($(".r-sphe").length>0){
        rDropSphe = new Drop({
            target: document.querySelector('.r-sphe'),
            content: 'This number measurement reflects the extent of the nearsightedness or farsightedness.',
            classes: 'drop-theme-arrows-bounce',
            position: 'top center',
            constrainToScrollParent: true,
            openOn: 'hover'
        });
    }

    if($(".r-cyl").length>0){
        rDropCyl = new Drop({
            target: document.querySelector('.r-cyl'),
            content: 'This number measurement refers to the amount of astigmatism (an irregularly cornea which causes blurring) in the eye.',
            classes: 'drop-theme-arrows-bounce',
            position: 'top center',
            constrainToScrollParent: true,
            openOn: 'hover'
        });
    }

    if($(".r-axis").length>0){
        rDropAxis = new Drop({
            target: document.querySelector('.r-axis'),
            content: 'This number measurement describes the astigmatism in degrees from the horizontal (most left and right eyes have the same axis in astigmatism) axis.',
            classes: 'drop-theme-arrows-bounce',
            position: 'top center',
            constrainToScrollParent: true,
            openOn: 'hover'
        });
    }

    if($(".r-add").length>0){
        rDropAdd = new Drop({
            target: document.querySelector('.r-add'),
            content: 'If you are over 45, there may be a number where it says ‘ADD’. This is your reading addition and relates to the amount of additional correction needed to focus at close distances. If a measurement is shown in this section, it means you have different prescriptions for distance and reading. Bifocal or varifocal lenses may be needed.',
            classes: 'drop-theme-arrows-bounce',
            position: 'top center',
            constrainToScrollParent: true,
            openOn: 'hover'
        });
    }


//     rDropCva = new Drop({
//              target: document.querySelector('.r-cva'),
//              content: '',
//              classes: 'drop-theme-arrows-bounce',
//              position: 'top center',
//              constrainToScrollParent: true,
//              openOn: 'hover'
//            });



});


