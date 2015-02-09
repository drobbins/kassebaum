Template.addPatient.events
    "submit form": (e) ->
        e.preventDefault()
        patient =
            firstName: $(e.target).find("[name=firstName]").val()
            lastName: $(e.target).find("[name=lastName]").val()
            middleName: $(e.target).find("[name=middleName]").val()
            dateOfBirth: $(e.target).find("[name=dateOfBirth]").datepicker("getDate").getTime()
            mrn: $(e.target).find("[name=mrn]").val()
            instancesOfProcurement: $(e.target).find ".surgical-path-number"
                .map (i,el) ->
                    return {
                        instanceOfProcurement: $(el).find("[name=instanceOfProcurement]").val()
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
        instancesOfProcurement = Session.get "instancesOfProcurement" or []
        instancesOfProcurement.push
            id: Meteor.uuid()
        Session.set "instancesOfProcurement", instancesOfProcurement

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
    instancesOfProcurement: ->
        Session.get "instancesOfProcurement"

Template.addPatient.rendered = ->
    initializeDatePickers()

Meteor.startup ->
    Session.set "instancesOfProcurement", [ { id: Meteor.uuid() } ]