// Makes a loading screen when triggered
$(function(){
    $('.wait-trigger').click(loadingMessage)
})

// The actual loading screen
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

// Shows/hides the delete confirmation for deleting last route
$(function() {
    $('.trigger-unmap-confirmation').click(function() {
        $('.unmap-confirmed').toggle();
    });
});

// Health monitor initializer
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


function setAppHealth() {
    var prev_health = parseInt($('#current-health').attr('value'));
    var new_health = parseInt($('#new-health').attr('data-health'));
    var time = 300;
    var time_add = 20;
    $('#current-health').attr('value', new_health);
    if(prev_health <= new_health){
        for(i=prev_health; i<=new_health; i++){
            updateKnob(i, time);
            time = time + time_add;
        };
    }
    else{
        for(i=prev_health; i>=new_health; i--){
            updateKnob(i, time);
            time = time + time_add;
        };
    };
};

function updateKnob(value, time){
    window.setTimeout(function(){
        $('#health-monitor').val(value).trigger('change');
    }, time);
};

$(function(){
    $('.row-link').click(function(){
        window.open($(this).attr('data-path'), '_self');
    });
});


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

// App show async loadings
$(function(){
    $('#app-services').find('#services-content').load($('#services-content').attr('data-path'), function(){
        $('#loading-services').hide()
    });

    $('#app-uris').find('#routes-content').load($('#routes-content').attr('data-path'), function(){
        $('#loading-routes').hide()
    });

    $('#app-stats').find('#stats-content').load($('#stats-content').attr('data-path'), function(){
        $('#loading-stats').hide();
        setAppHealth();
        window.setTimeout(ajaxAppStats, 3000);
    });

});


function ajaxAppStats() {
    if(document.getElementById('stats-content')){
        $.ajax({
            url: $('#stats-content').attr('data-path'),
            type: 'GET',
            dataType: 'html',
            contentType: 'application/html; charset=utf-8',
            success: function(data){
                $('#stats-content').html(data)
                setAppHealth();
                window.setTimeout(ajaxAppStats, 1000);
            }
        });
    }
}
