window.formatDateString = (date) ->
    date = date or @date
    if date then moment(date).format Session.get "momentDateFormat"
Template.registerHelper "formatDateString", window.formatDateString