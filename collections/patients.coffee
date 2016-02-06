@Patients = new Meteor.Collection "patients"

Patients.allow
    update: (userId) -> authorizedUser userId
    remove: (userId) -> authorizedUser userId

if Meteor.isServer
    Hashids = Meteor.npmRequire "hashids"

    mergeInstancesOfProcurement = (oldNumbers, newNumbers) ->
        instancesOfProcurement = oldNumbers.concat newNumbers
        # Based on http://coffeescriptcookbook.com/chapters/arrays/removing-duplicate-elements-from-arrays
        output = {}
        output[JSON.stringify(instancesOfProcurement[key])] = JSON.stringify(instancesOfProcurement[key]) for key in [0...instancesOfProcurement.length]
        return (JSON.parse(value) for key, value of output)

    generateUniqueShortId = (mrn) ->
        shortId = Random.id(6) # Generate a Short ID
        while Patients.findOne(shortId: shortId)
            shortId = Random.id(6) # Generate another Short ID
        shortId

    Meteor.methods
        patient: (patientAttributes) ->
            user = Meteor.user()
            patientWithSameMRN = Patients.findOne mrn: patientAttributes.mrn

            # Validation
            if not user then throw new Meteor.Error 401, "You need to log in to add patients"
            if not Roles.userIsInRole @userId, ["admin", "tech", "procurement-tech"] then throw new Meteor.Error 401, "You are not authorized to add patients"
            if not hasAttributes patientAttributes, ["firstName", "lastName", "mrn"]
                throw new Meteor.Error 422, "Patient first name, last name, and MRN are required"

            if patientWithSameMRN # Update Patient with any new Surgical Path #'s
                instancesOfProcurement = mergeInstancesOfProcurement patientWithSameMRN.instancesOfProcurement, patientAttributes.instancesOfProcurement
                Patients.update patientWithSameMRN._id, $set: instancesOfProcurement: instancesOfProcurement
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
            if process.env.NODE_ENV is "development" and process.env.MOCK_EMMI is "true"
                return patient =
                    firstname: "Barbra"
                    lastname: "Hsistest"
                    middlename: "Qualif"
                    birthDate: "19830302"
            else
                if not Roles.userIsInRole Meteor.user(), ["admin", "tech", "procurement-tech"] then throw new Meteor.Error 401, "You are not authorized to lookup patients"
                client = new EMMI.Client EMMIClientSettings
                patient = (client.getPatient mrn).result
                _.each ["firstname", "lastname"], (property) ->
                    patient[property] = patient[property].toProperCase()
                patient
