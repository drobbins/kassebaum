Template.editObservation.events
    "submit form": (e, template) ->
        e.preventDefault()
        currentObservationId = @_id
        patientId = @patientId
        observationProperties =
            type: $(e.target).find("[name=type]").val()
            value: $(e.target).find("[name=value]").val()
        Observations.update currentObservationId, {$set: observationProperties}, (error) ->
            if error then Alerts.add error.message
            Router.go "viewPatient", _id: patientId
