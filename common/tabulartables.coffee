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
    responsive: true
    autoWidth: false
    columns: [
        {
            tmpl: Meteor.isClient && Template.patientListSelector
            className: "text-center"
            width: "1px" # actual width will be greater - this just minimizes it
        }
        # {data: "added", title: "Added", render: (val) -> moment(val).format(Session.get("momentDateFormat")) }
        {data: "shortId", title: "Short ID", width: "100px"}
        {data: "mrn", title: "MRN"}
        # {data: "fullName()", title: "Name"}
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
    extraFields: ['instancesOfProcurement', 'firstName', 'lastName', 'deleted']
    order: [[1, 'desc']]
