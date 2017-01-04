Template.patientRowButtons.events
    "click #restorePatientButton": -> Meteor.call "restorePatient", this._id
    "click #deletePatientButton": -> Meteor.call "deletePatient", this._id
