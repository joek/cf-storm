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
    window.setTimeout(ajaxAppStats, 3000);
});

function ajaxAppStats() {
    if(document.getElementById('astats')){
        $.ajax({
            url: $('#astats').attr('data-path'),
            type: 'GET',
            dataType: 'html',
            contentType: 'application/html; charset=utf-8',
            success: function(data){
                $('#astats').html(data)
                window.setTimeout(ajaxAppStats, 1000);
            }
        });
    }
}

$(function(){
    $('#env').load($('#env').attr('data-path'), function(){
        $('#env-loading').hide();
        $('#env-container').find('.panel-body').slideToggle();
    })
});;

$(function(){
    $('#staging').load($('#staging').attr('data-path'), function(){
        $('#staging-loading').hide();
        $('#staging-container').find('.panel-body').slideToggle();
    })
});;

$(function(){
    $('#stderr').load($('#stderr').attr('data-path'), function(){
        $('#stderr-loading').hide();
        $('#stderr-container').find('.panel-body').slideToggle();
    })
});;

$(function(){
    $('#stdout').load($('#stdout').attr('data-path'), function(){
        $('#stdout-loading').hide();
        $('#stdout-container').find('.panel-body').slideToggle();
    })
});;

$(function(){
    $('#env-container').find('.panel-heading').click(function(){
        $('#env-container').find('.panel-body').slideToggle()
    });
    $('#staging-container').find('.panel-heading').click(function(){
        $('#staging-container').find('.panel-body').slideToggle()
    });
    $('#stderr-container').find('.panel-heading').click(function(){
        $('#stderr-container').find('.panel-body').slideToggle()
    });
    $('#stdout-container').find('.panel-heading').click(function(){
        $('#stdout-container').find('.panel-body').slideToggle()
    });

});
