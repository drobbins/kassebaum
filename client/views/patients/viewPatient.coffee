Template.instanceOfProcurementRow.helpers
    ageAtCollectionString: (dateOfBirth) ->
        getHumanizedDuration dateOfBirth, @date

Template.viewPatient.helpers
    dateOfBirthString: -> window.formatDateString @dateOfBirth