if Meteor.isServer
    Hashids = Meteor.require "hashids"

    mergeSurgicalPathologyNumbers = (oldNumbers, newNumbers) ->
        surgicalPathologyNumbers = oldNumbers.concat newNumbers
        # Based on http://coffeescriptcookbook.com/chapters/arrays/removing-duplicate-elements-from-arrays
        output = {}
        output[JSON.stringify(surgicalPathologyNumbers[key])] = JSON.stringify(surgicalPathologyNumbers[key]) for key in [0...surgicalPathologyNumbers.length]
        return (JSON.parse(value) for key, value of output)


    Meteor.methods
        patient: (patientAttributes) ->
            user = Meteor.user()
            patientWithSameMRN = Patients.findOne mrn: patientAttributes.mrn

            # Validation
            if not user then throw new Meteor.Error 401, "You need to log in to add patients"
            if not Roles.userIsInRole @userId, ["admin", "tech"] then throw new Meteor.Error 401, "You are not authorized to add patients"
            if not hasAttributes patientAttributes, ["firstName", "lastName", "mrn"]
                throw new Meteor.Error 422, "Patient first name, last name, and MRN are required"

            if patientWithSameMRN # Update Patient with any new Surgical Path #'s
                surgicalPathologyNumbers = mergeSurgicalPathologyNumbers patientWithSameMRN.surgicalPathologyNumbers, patientAttributes.surgicalPathologyNumbers
                Patients.update patientWithSameMRN._id, $set: surgicalPathologyNumbers: surgicalPathologyNumbers
                return patientWithSameMRN.shortId


            else # Create a new patient
                hasher = new Hashids Meteor.uuid(), 6
                shortId = hasher.encrypt parseInt patientAttributes.mrn, 10 # Generate Short ID
                patient = _.extend patientAttributes,
                    added: new Date().getTime()
                    addedBy: user._id
                    shortId: shortId
                patientId = Patients.insert(patient)
                return shortId
