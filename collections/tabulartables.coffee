TabularTables = {}

if Meteor.isClient then Template.registerHelper "TabularTables", TabularTables

TabularTables.LogEntries = new Tabular.Table
    name: "LogEntries"
    collection: Logs.collection
    columns: [
        {data: "level", title: "Level" }
        {data: "timestamp", title: "Time", render: (val) -> moment(val).format(Session.get("momentDateFormat")) }
        {
            data: (row) ->
                a = 2
                row.data?.user?.username
            title: "User"
        }
        {data: "message", title: "Message" }
    ]
    extraFields: ['data']