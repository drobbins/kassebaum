Template.surgicalPathologyNumberRow.helpers
    dateString: -> moment(@date).format Session.get "momentDateFormat"
