@Patients = new Meteor.Collection "patients"

Patients.allow
    update: (userId) -> authorizedUser userId
    remove: (userId) -> authorizedUser userId

if Meteor.isServer
    Hashids = Meteor.npmRequire "hashids"

    mergeSurgicalPathologyNumbers = (oldNumbers, newNumbers) ->
        surgicalPathologyNumbers = oldNumbers.concat newNumbers
        # Based on http://coffeescriptcookbook.com/chapters/arrays/removing-duplicate-elements-from-arrays
        output = {}
        output[JSON.stringify(surgicalPathologyNumbers[key])] = JSON.stringify(surgicalPathologyNumbers[key]) for key in [0...surgicalPathologyNumbers.length]
        return (JSON.parse(value) for key, value of output)

    generateUniqueShortId = (mrn) ->
        hasher = new Hashids Meteor.uuid(), 6
        shortId = (hasher.encrypt parseInt mrn, 10).slice 0,6 # Generate Short ID
        while Patients.findOne(shortId: shortId)
            shortId = (hasher.encrypt parseInt mrn+Meteor.uuid(), 10).slice 0,6 # Generate another Short ID
        shortId

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
                shortId = generateUniqueShortId patientAttributes.mrn
                patient = _.extend patientAttributes,
                    added: new Date().getTime()
                    addedBy: user._id
                    shortId: shortId
                patientId = Patients.insert(patient)
                return shortId

        lookupPatient: (mrn) ->
            client = new EMMI.Client EMMIClientSettings
            patient = (client.getPatient mrn).result
            _.each ["firstname", "lastname"], (property) ->
                patient[property] = patient[property].toProperCase()
            patient
