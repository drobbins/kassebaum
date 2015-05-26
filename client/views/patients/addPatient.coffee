Template.addPatient.events
    "submit form": (e) ->
        e.preventDefault()
        patient =
            firstName: $(e.target).find("[name=firstName]").val()
            lastName: $(e.target).find("[name=lastName]").val()
            middleName: $(e.target).find("[name=middleName]").val()
            dateOfBirth: $(e.target).find("[name=dateOfBirth]").datepicker("getDate")?.getTime()
            mrn: $(e.target).find("[name=mrn]").val()
            externalMrn: Session.get "externalMrn"
        patient.instancesOfProcurement = @instancesOfProcurementCollection.find().fetch()
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

    "click .lookup-patient": ->
        mrn = $("[name=mrn]").val()
        Meteor.call "lookupPatient", mrn, (error, response) ->
            if error
                Alert.add error.message, "danger"
                Logs.add "error", error.message
            else if response
                $("[name=firstName]").val(response.firstname)
                $("[name=middleName]").val(response.middlename.slice(0,1))
                $("[name=lastName]").val(response.lastname)
                $("[name=dateOfBirth]").datepicker "update", moment(response.birthDate, EMMIDateFormat).toDate()

    "click .new-patient": ->
        $("form[name=addPatient]")[0].reset()

Template.addPatient.helpers
    disabledIfNonUabMrn: ->
        if Session.get "externalMrn" then "disabled" else ""

Template.addPatient.rendered = ->
    initializeDatePickers()

EMMIDateFormat = "YYYYMMDD"