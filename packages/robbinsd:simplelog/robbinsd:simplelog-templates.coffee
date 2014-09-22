Template.simpleLogs.helpers
    logItems: -> Logs.collection.find()

Template.logItem.helpers
    raw: -> JSON.stringify @, null, 2
    timeString: -> (new Date(@timestamp)).toLocaleString()
