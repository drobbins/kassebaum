window.initializeDatePickers = ->
    $('.datepicker').datepicker
        format: Session.get "datepickerDateFormat"
        todayBtn: "linked"
        todayHighlight: true
    .each (i, el) ->
        $el = $(el)
        $el.datepicker "update", new Date(parseInt($el.val(),10))