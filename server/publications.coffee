Meteor.publish "patients", ->
    Patients.find() if authorizedUser @userId
