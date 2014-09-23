Template.editPatient.events
    "submit form": (e) ->
        e.preventDefault()
        currentPatientId = @_id
        patientProperties =
            firstName: $(e.target).find("[name=firstName]").val()
            lastName: $(e.target).find("[name=lastName]").val()
            mrn: $(e.target).find("[name=mrn]").val()
        Patients.update currentPatientId, {$set: patientProperties}, (error) ->
            if error
                Alert.add error.message
                Logs.add "error", error.message
            Router.go "listPatients"

    "click .delete": (e) ->
        e.preventDefault()
        if confirm "Delete this patient?"
            currentPatientId = @_id
            Patients.remove currentPatientId
            Router.go "listPatients"
