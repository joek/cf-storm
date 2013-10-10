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
    var current = parseInt($('#current-health').attr('value'));
    for(i=0; i<=current; i++){
        updateKnob(i);
    };
});

function updateKnob(value){
    window.setTimeout(function(){
        $('#health-monitor').val(value).trigger('change');
    }, (300+(value*20)));
};

$(function(){
    $('.row-link').click(function(){
        window.open($(this).attr('data-path'), '_self');
    });
});

$(function(){
    if($('#app-stats')){
        window.setTimeout(ajaxAppStats, 3000);
    };
});

function ajaxAppStats() {
    $.ajax({
        url: document.URL + '/async_stats',
        type: 'GET',
        dataType: 'html',
        contentType: 'application/html; charset=utf-8',
        success: function(data){
            $('#astats').html(data)
            window.setTimeout(ajaxAppStats, 3000);
        }
    });

}
