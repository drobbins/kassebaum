Template.editPatient.events
    "submit form": (e) ->
        e.preventDefault()
        currentPatientId = @_id
        patientProperties =
            firstName: $(e.target).find("[name=firstName]").val()
            lastName: $(e.target).find("[name=lastName]").val()
            middleName: $(e.target).find("[name=middleName]").val()
            dateOfBirth: $(e.target).find("[name=dateOfBirth]").datepicker("getDate").getTime()
            mrn: $(e.target).find("[name=mrn]").val()
        Patients.update currentPatientId, {$set: patientProperties}, (error) ->
            if error
                Alert.add error.message, "danger"
                Logs.add "error", "Unable to edit patient #{currentPatientId}: #{error.message}"
            Router.go "listPatients"

    "click .delete": (e) ->
        e.preventDefault()
        if confirm "Delete this patient?"
            currentPatientId = @_id
            Patients.remove currentPatientId
            Router.go "listPatients"

    "DOMNodeInserted": ->
        # Initialize any new datepicker fields after insertion into the DOM
        initializeDatePickers()

Template.editPatient.rendered = ->
    initializeDatePickers()
