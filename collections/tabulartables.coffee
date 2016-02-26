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

TabularTables.Patients = new Tabular.Table
    name: "Patients"
    collection: Patients
    columns: [
        {data: "added", title: "Added", width: "65px", render: (val) -> moment(val).format(Session.get("momentDateFormat")) }
        {data: "shortId", title: "Short ID"}
        {data: "mrn", title: "MRN"}
        {data: "firstName", title: "First Name"}
        {data: "lastName", title: "Last Name"}
        {
            tmpl: Meteor.isClient && Template.instanceOfProcurementDates
            title: "Procurement Dates"
        }
        {
            tmpl: Meteor.isClient && Template.patientRowButtons
            className: "text-center"
        }
    ]
    extraFields: ['instancesOfProcurement']
    order: [[0, 'desc']]
