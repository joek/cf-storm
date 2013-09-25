$(function(){
    $('.wait-trigger').click(loadingMessage)
})

function loadingMessage() {
    $.blockUI({ css: { 
	border: 'none', 
	padding: '15px', 
	backgroundColor: '#000', 
	'-webkit-border-radius': '10px', 
	'-moz-border-radius': '10px', 
	opacity: .5, 
	color: '#fff',
	'font-size': '30px',
	'z-index': 1000 },
        message: '<i class="icon-spinner icon-spin icon-large"></i> Loading...'
		
	      }); 
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

$(function() {
    var current = parseInt($('#health-current').attr('value'));
    for(var i=0; i <= current; i++) {
	setTimeout("console.info(i)", 1);
    }
});

