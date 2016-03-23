Template.listPatientsPrint.helpers
    patients: ->
        ids = Session.get "selectedPatientsList"
        Patients.find({_id: {$in: ids}})
    title: -> Session.get "listPatientsPrint.title"

Template.listPatientsPrint.events
    "keyup input[name=title]": (e) -> Session.set "listPatientsPrint.title", $(e.target).val()
