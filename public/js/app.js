$(function() {
    $('.btn').click(function() {
        $('.btn').each(function(index,value){
            if($(this).attr('href') == null){
                $(this).attr('disabled', true);
                $(this).parents().find('form').submit();
            };
        });
    });
});

$(function() {
    $('.trigger-unmap-confirmation').click(function() {
        $('.unmap-confirmed').toggle();
    });
});


$(function() {
    $('#health-monitor').knob({
        'max': 100,
        'min': 0,
        'readOnly': true,
        'fgColor': '#33FF44',
        'bgColor': '#FFBBBB',
        'angleOffset':-125,
        'angleArc': 250
    });
});
