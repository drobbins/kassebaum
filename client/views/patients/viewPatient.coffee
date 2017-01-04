Template.instanceOfProcurementRow.helpers
    ageAtCollectionString: (dateOfBirth) ->
        getHumanizedDuration dateOfBirth, @date

Template.viewPatient.helpers
    dateOfBirthString: -> window.formatDateString @dateOfBirth

Template.viewPatient.events
    "click #restorePatientButton": -> Meteor.call "restorePatient", this._id
    "click #deletePatientButton": -> Meteor.call "deletePatient", this._id
