$(function() {
    $('.btn').click(function() {
	if(!$(this).attr('href')){
	    loadingMessage();	    
	};
        $('.btn').each(function(index,value){
            if($(this).attr('href') == null){
                $(this).attr('disabled', true);
                $(this).parents().find('form').submit();
            };
	});
    });
});

function loadingMessage() {
    $.blockUI({ css: { 
	border: 'none', 
	padding: '15px', 
	backgroundColor: '#000', 
	'-webkit-border-radius': '10px', 
	'-moz-border-radius': '10px', 
	opacity: .5, 
	color: '#fff',
	'z-index': 1000
    }}); 
};

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
