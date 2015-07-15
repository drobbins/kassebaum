Meteor.publish "patients", ->
    Patients.find() if authorizedUser @userId

Meteor.publish "patientById", (id) ->
	check(id, String)
	Patients.find({_id:id}) if authorizedUser @userId