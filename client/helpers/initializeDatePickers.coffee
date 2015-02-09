window.initializeDatePickers = ->
    $('.datepicker').datepicker
        format: Session.get "datepickerDateFormat"
        todayBtn: "linked"
        todayHighlight: true
    .each (i, el) ->
        $el = $(el)
        val = $el.val()
        if val then $el.datepicker "update", new Date(parseInt(val,10))