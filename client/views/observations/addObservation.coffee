Template.addObservation.events
    "submit form": (e, template) ->
        e.preventDefault()
        observation =
            type: $(e.target).find("[name=type]").val()
            value: $(e.target).find("[name=value]").val()
            patientId: template.data._id
        Meteor.call "observation", observation, (error, id) ->
            if error then Alerts.add error.message
