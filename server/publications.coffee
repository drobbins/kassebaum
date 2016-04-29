Meteor.publish "patients", ->
    if Kassebaum.authorizedUser @userId then Patients.find() else []

Meteor.publish "patientById", (id) ->
	check(id, String)
	if Kassebaum.authorizedUser @userId then Patients.find({_id:id}) else []

Meteor.publish "patientsById", (ids) ->
    check(ids, [String])
    if Kassebaum.authorizedUser @userId then Patients.find({_id: {$in: ids}}) else []
