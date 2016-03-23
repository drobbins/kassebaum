Template.patientListSelector.events
    "change input[type=checkbox]": (e) ->
        selectedPatientsList = Session.get("selectedPatientsList") or []
        if $(e.target).is ":checked"
            selectedPatientsList.push(@_id)
        else
            selectedPatientsList = _.without selectedPatientsList, @_id
        Session.set "selectedPatientsList", selectedPatientsList

Template.patientListSelector.helpers
    isChecked: -> _.contains Session.get("selectedPatientsList"), @_id
