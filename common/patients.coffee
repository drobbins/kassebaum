@Patients = new Meteor.Collection "patients"

Patients.allow
    update: (userId) -> Kassebaum.authorizedUser userId
    remove: (userId) -> Kassebaum.authorizedUser userId

Patients.helpers
    fullName: -> return "#{@firstName} #{@lastName}"

if Meteor.isServer

    mergeInstancesOfProcurement = (oldNumbers, newNumbers) ->
        instancesOfProcurement = oldNumbers.concat newNumbers
        # Based on http://coffeescriptcookbook.com/chapters/arrays/removing-duplicate-elements-from-arrays
        output = {}
        output[JSON.stringify(instancesOfProcurement[key])] = JSON.stringify(instancesOfProcurement[key]) for key in [0...instancesOfProcurement.length]
        return (JSON.parse(value) for key, value of output)

    generateUniqueShortId = Kassebaum.generateUniqueShortId

    Kassebaum.upsertPatient = (patientAttributes, addedBy) ->
        patientWithSameMRN = Patients.findOne {$or: [ {mrn: patientAttributes.mrn}, {shortId: patientAttributes.mrn}]}

        if patientWithSameMRN # Update Patient with any new Surgical Path #'s
            instancesOfProcurement = mergeInstancesOfProcurement patientWithSameMRN.instancesOfProcurement, patientAttributes.instancesOfProcurement
            Patients.update patientWithSameMRN._id, $set: instancesOfProcurement: instancesOfProcurement
            return patientWithSameMRN.shortId

        else # Create a new patient
            if not Kassebaum.hasAttributes patientAttributes, ["firstName", "lastName", "mrn"]
                throw new Meteor.Error 422, "Patient first name, last name, and MRN are required"
            shortId = generateUniqueShortId patientAttributes.mrn
            patient = _.extend patientAttributes,
                added: new Date().getTime()
                addedBy: addedBy
                shortId: shortId
            patientId = Patients.insert(patient)
            return shortId

    Meteor.methods
        addPatient: (patientAttributes) ->
            # Validation
            if not @userId then throw new Meteor.Error 401, "You need to log in to add patients"
            if not Roles.userIsInRole @userId, ["admin", "tech", "procurement-tech"] then throw new Meteor.Error 401, "You are not authorized to add patients"

            return Kassebaum.upsertPatient(patientAttributes, @userId);

        addPatientByAPI: (patients, token) ->

            attemptToUpsertPatient = (patient) ->
                try
                    result = Kassebaum.upsertPatient(patient, token)
                    return { status: "success", shortId: result, original: patient }
                catch error
                    return { status: "error", error: error, original: patient }

            if Array.isArray(patients)
                return patients.map attemptToUpsertPatient
            else
                return [attemptToUpsertPatient(patients)]


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

        deletePatient: (_id) ->
            if not @userId then throw new Meteor.Error 401, "You need to log in to delete patients"
            if not Roles.userIsInRole @userId, ["admin", "tech", "procurement-tech"] then throw new Meteor.Error 401, "You are not authorized to delete patients"
            Patients.update _id, $set: deleted: true

        restorePatient: (_id) ->
            if not @userId then throw new Meteor.Error 401, "You need to log in to restore patients"
            if not Roles.userIsInRole @userId, ["admin", "tech", "procurement-tech"] then throw new Meteor.Error 401, "You are not authorized to restore patients"
            Patients.update _id, $unset: deleted: ""
