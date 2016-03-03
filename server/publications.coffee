Meteor.publish "patients", ->
    if authorizedUser @userId then Patients.find() else []

Meteor.publish "patientById", (id) ->
	check(id, String)
	if authorizedUser @userId then Patients.find({_id:id}) else []

Meteor.publish "patientsById", (ids) ->
    check(ids, [String])
    if authorizedUser @userId then Patients.find({_id: {$in: ids}}) else []
