Meteor.publish "patients", ->
    Patients.find() if @userId and Roles.userIsInRole @userId, ["admin", "physician"]
