Meteor.methods
    observation: (observationAttributes) ->
        user = Meteor.user()
        patient = Patients.findOne observationAttributes.patientId

        # Validation
        if not user then throw new Meteor.Error 401, "You need to log in to add patients"
        if not Roles.userIsInRole @userId, ["admin", "physician"] then throw new Meteor.Error 401, "You are not authorized to add obserations."
        if not patient then throw new Meteor.Error 422, "Patient does not exist"

        observation = _.extend observationAttributes,
            user: user.profile.name
            userId: user._id
            submitted: new Date().getTime()

        observationId = Observations.insert observation
