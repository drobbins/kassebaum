authorizedUser = (userId) ->
    userId and Roles.userIsInRole userId, ["admin", "physician"]

Meteor.publish "patients", ->
    Patients.find() if authorizedUser @userId

Meteor.publish "observations", (patientId) ->
    Observations.find patientId: patientId if authorizedUser @userId

Meteor.publish "observationFiles", (patientId) ->
    ObservationFiles.find "metadata.patientId": patientId if authorizedUser @userId

Meteor.publish "observationDetail", (observationId) ->
    Observations.find _id: observationId if authorizedUser @userId

Meteor.publish "observationDetailFiles",  (observationId) ->
    ObservationFiles.find "metadata.observationId": observationId if authorizedUser @userId
