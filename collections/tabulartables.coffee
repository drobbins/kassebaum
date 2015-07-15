TabularTables = {}

if Meteor.isClient then Template.registerHelper "TabularTables", TabularTables

TabularTables.LogEntries = new Tabular.Table
    name: "LogEntries"
    collection: Logs.collection
    columns: [
        {data: "timestamp", title: "Time", render: (val) -> moment(val).format(Session.get("momentLogDateFormat")) }
        {data: "level", title: "Level" }
        {data: "data.user.username", title: "User" }
        {data: "message", title: "Message" }
    ]
    extraFields: ['data']
    order: [[0, 'desc']]