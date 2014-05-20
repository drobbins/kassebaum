Template.addPatient.events
    "submit form": (e) ->
        e.preventDefault()
        patient =
            firstName: $(e.target).find("[name=firstName]").val()
            lastName: $(e.target).find("[name=lastName]").val()
            mrn: $(e.target).find("[name=mrn]").val()
            surgicalPathologyNumbers: $(e.target).find ".surgical-path-number"
                .map (i,el) ->
                    return {
                        surgicalPathologyNumber: $(el).find("[name=surgicalPathologyNumber]").val()
                        date: $(el).find("[name=date]").val()
                    }
                .get()
        Meteor.call "patient", patient, (error, id) ->
            if error then Alerts.add error.message
            else Router.go 'listPatients'
    "click .add-surgical-pathology-number": ->
        surgicalPathologyNumbers = Session.get "surgicalPathologyNumbers" or []
        surgicalPathologyNumbers.push
            id: Meteor.uuid()
        Session.set "surgicalPathologyNumbers", surgicalPathologyNumbers

Template.addPatient.helpers
    surgicalPathologyNumbers: ->
        Session.get "surgicalPathologyNumbers"

Meteor.startup ->
    Session.set "surgicalPathologyNumbers", [ { id: Meteor.uuid() } ]
