window.initializeDatePickers = ->
    $('.datepicker').datepicker
        format: Session.get "datepickerDateFormat"
        todayBtn: "linked"
        todayHighlight: true
    .each (i, el) ->
        $el = $(el)
        val = $el.val()
        # If there is a val and it doesn't contain a /, treat it as a date in integer form
        if val and not val.match "/" then $el.datepicker "update", new Date(parseInt(val,10))