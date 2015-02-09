Template.instanceOfProcurementRow.helpers
    ageAtCollectionString: (dateOfBirth) -> 
        moment.duration(@date-dateOfBirth).humanize()

Template.viewPatient.helpers
    dateOfBirthString: -> window.formatDateString @dateOfBirth