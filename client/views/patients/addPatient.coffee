Template.addPatient.events
    "submit form": (e) ->
        e.preventDefault()
        patient =
            firstName: $(e.target).find("[name=firstName]").val()
            lastName: $(e.target).find("[name=lastName]").val()
            middleName: $(e.target).find("[name=middleName]").val()
            mrn: $(e.target).find("[name=mrn]").val()
            surgicalPathologyNumbers: $(e.target).find ".surgical-path-number"
                .map (i,el) ->
                    return {
                        surgicalPathologyNumber: $(el).find("[name=surgicalPathologyNumber]").val()
                        date: $(el).find("[name=date]").datepicker("getDate").getTime()
                    }
                .get()
        Meteor.call "patient", patient, (error, shortId) ->
            if error
                Alert.add error.message, "danger"
                Logs.add "error", error.message
            else
                message = "Successfully added patient. Patient code: #{shortId}"
                Alert.add message, "success"
                Logs.add "success", message

    "click .add-surgical-pathology-number": ->
        surgicalPathologyNumbers = Session.get "surgicalPathologyNumbers" or []
        surgicalPathologyNumbers.push
            id: Meteor.uuid()
        Session.set "surgicalPathologyNumbers", surgicalPathologyNumbers

    "DOMNodeInserted": ->
        # Initialize any new datepicker fields after insertion into the DOM
        initializeDatePickers()

    "click .lookup-patient": ->
        mrn = $("[name=mrn]").val()
        Meteor.call "lookupPatient", mrn, (error, response) ->
            if error
                Alert.add error.message, "danger"
                Logs.add "error", error.message
            else
                $("[name=firstName]").val(response?.firstname)
                $("[name=middleName]").val(response?.middlename)
                $("[name=lastName]").val(response?.lastname)

Template.addPatient.helpers
    surgicalPathologyNumbers: ->
        Session.get "surgicalPathologyNumbers"

Template.addPatient.rendered = ->
    initializeDatePickers()

Meteor.startup ->
    Session.set "surgicalPathologyNumbers", [ { id: Meteor.uuid() } ]