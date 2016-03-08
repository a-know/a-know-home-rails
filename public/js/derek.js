/* ===================================================
 * template specific javascript funtions
 * ================================================ */
$(document).ready(function(){
    //Init jQuery Masonry layout
    init_masonry();

    window.setTimeout(function() {

        $(window).trigger('resize');

    }, 1000);

});


function init_masonry(){

    var $container = $('#portfolio');
    var gutter = 12;
    var min_width = 215;

    $container.imagesLoaded( function(){

        $container.masonry({

            itemSelector: '.portfolio-item',
            gutterWidth: gutter,
            isAnimated: true,
            columnWidth: function( containerWidth ) {

                var num_of_boxes = (containerWidth/min_width | 0);

                var box_width = (((containerWidth - (num_of_boxes-1)*gutter)/num_of_boxes) | 0) ;

                if (containerWidth < min_width) {
                    box_width = containerWidth;
                }

                $('.portfolio-item').width(box_width);

                return box_width;
            }
        });
    });
}

/* tooltip */
$('.my-tooltip').tooltip()
