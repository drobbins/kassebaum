authorizedUser = (userId) ->
    userId and Roles.userIsInRole userId, ["admin"]

Meteor.publish "patients", ->
    Patients.find() if authorizedUser @userId
