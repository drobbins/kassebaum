Template.simpleLogs.helpers
    logItems: -> Logs.collection.find({}, sort: timestamp: -1)

Template.logItem.helpers
    raw: -> JSON.stringify @, null, 2
    timeString: -> (new Date(@timestamp)).toLocaleString()
