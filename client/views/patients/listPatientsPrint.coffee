Template.listPatientsPrint.helpers
    patients: () ->
        ids = Session.get "selectedPatientsList"
        Patients.find({_id: {$in: ids}})
