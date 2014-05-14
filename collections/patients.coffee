Meteor.methods
    patient: (patientAttributes) ->
        user = Meteor.user()
        patientWithSameMRN = Patients.findOne mrn: patientAttributes.mrn

        # Validation
        if not user then throw new Meteor.Error 401, "You need to log in to add patients"
        if not Roles.userIsInRole @userId, ["admin", "physician"] then throw new Meteor.Error 401, "You are not authorized to add patients"
        if not hasAttributes patientAttributes, ["firstName", "lastName", "mrn"]
            throw new Meteor.Error 422, "Patient first name, last name, and MRN are required"
        if patientWithSameMRN then throw new Meteor.Error 302, "This patient has already been created", patientWithSameMRN._id

        patient = _.extend patientAttributes,
            added: new Date().getTime()
            addedBy: user._id

        patientId = Patients.insert(patient)
