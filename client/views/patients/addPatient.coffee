Template.addPatient.events
    "submit form": (e) ->
        e.preventDefault()
        patient =
            firstName: $(e.target).find("[name=firstName]").val()
            lastName: $(e.target).find("[name=lastName]").val()
            mrn: $(e.target).find("[name=mrn]").val()
        console.log "Saving new patient:", patient
        Meteor.call "patient", patient, (error, id) ->
            if error then console.error error
            Router.go 'listPatients'
