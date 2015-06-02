tech =
    username: "kallie"
    password: "password"
    name: "Kallie Emil"

admin =
    username: "admin"
    password: "password"
    name: "Admin"

wrongRole =
    username: "kallie"
    password: "password"
    name: "Kallie Emil"
    roles: [ "notTech" ]

patient =
    firstName: "Adolphus"
    lastName: "McTestington"
    mrn: "1234512345"
    instancesOfProcurement: [ "111", "222", "333"]

emmi_result =
    result:
        firstname: "Adolphus"
        lastname: "McTestington"
        mrn: "1234512345"

describe "Patients", ->

    describe "method patient", ->

        it "exists", ->
            expect(Meteor.methodMap.patient).toBeDefined()

        it "returns a 401 if not logged in.", ->
            spyOn Meteor, "user"
                .and.returnValue null
            Meteor.call "patient", {}, (err, resp) ->
                expect(err.error).toBe 401
                expect(Meteor.user).toHaveBeenCalled()

        it "returns a 401 if missing correct role.", ->
            spyOn Meteor, "user"
                .and.returnValue wrongRole
            spyOn Roles, "userIsInRole"
                .and.returnValue false
            Meteor.call "patient", {}, (err, resp) ->
                expect(err.error).toBe 401
                expect(Meteor.user).toHaveBeenCalled()
                expect(Roles.userIsInRole).toHaveBeenCalled()

        it "does not return a 401 if a correct role.", ->
            spyOn Meteor, "user"
                .and.returnValue tech
            spyOn Roles, "userIsInRole"
                .and.returnValue true
            Meteor.call "patient", {}, (err, resp) ->
                expect(err.error).not.toBe 401
                expect(Meteor.user).toHaveBeenCalled()
                expect(Roles.userIsInRole).toHaveBeenCalled()

        describe "returns a 422 if missing required field", ->

            beforeEach ->
                spyOn Meteor, "user"
                    .and.returnValue tech
                spyOn Roles, "userIsInRole"
                    .and.returnValue true

            testValidation = (field) ->
                temp = patient[field]
                patient[field] = null
                Meteor.call "patient", patient, (err, resp) ->
                    expect(err.error).toBe 422
                    patient[field] = temp

            it "patient.firstName", ->
                testValidation "firstName"

            it "patient.lastName", ->
                testValidation "lastName"

            it "patient.mrn", ->
                testValidation "mrn"

        it "merges surgical pathology numbers for existing patients", ->
            existingPatient =
                firstName: "Adolphus"
                lastName: "McTestington"
                mrn: "1234512345"
                shortId: "abcdef"
                instancesOfProcurement: [ "111", "222", "444"]
            spyOn Meteor, "user"
                .and.returnValue tech
            spyOn Roles, "userIsInRole"
                .and.returnValue true
            spyOn Patients, "findOne"
                .and.returnValue existingPatient
            spyOn Patients, "update"
            Meteor.call "patient", patient, (err, resp) ->
                expect(err).toBe null
                #expect(shortId).toBe existingPatient.shortId
                expect(Patients.update).toHaveBeenCalled()
                expect(Patients.update.calls.mostRecent().args[1].$set.instancesOfProcurement).toEqual [ "111", "222", "444", "333"]

        it "inserts patient with a new shortId for new patients", ->
            spyOn Meteor, "user"
                .and.returnValue tech
            spyOn Roles, "userIsInRole"
                .and.returnValue true
            spyOn Patients, "findOne"
                .and.returnValue null
            spyOn Patients, "insert"
            Meteor.call "patient", patient, (err, resp) ->
                expect(err).toBe null
                expect(Patients.insert).toHaveBeenCalled()
                expect(Patients.insert.calls.mostRecent().args[0].shortId).not.toBeNull()

    describe "method lookupPatient", ->

        beforeEach -> process.env.MOCK_EMMI = false

        afterEach -> process.env.MOCK_EMMI = true

        it "returns a 401 if not logged in.", ->
            spyOn Meteor, "user"
                .and.returnValue null
            Meteor.call "lookupPatient", {}, (err, resp) ->
                expect(err.error).toBe 401
                expect(Meteor.user).toHaveBeenCalled()

        it "returns a 401 if missing correct role.", ->
            spyOn Meteor, "user"
                .and.returnValue wrongRole
            spyOn Roles, "userIsInRole"
                .and.returnValue false
            Meteor.call "lookupPatient", {}, (err, resp) ->
                expect(err.error).toBe 401
                expect(Meteor.user).toHaveBeenCalled()
                expect(Roles.userIsInRole).toHaveBeenCalled()

        it "does not return a 401 if a correct role.", ->
            spyOn Meteor, "user"
                .and.returnValue tech
            spyOn Roles, "userIsInRole"
                .and.returnValue true
            Meteor.call "lookupPatient", {}, (err, resp) ->
                expect(err.error).not.toBe 401
                expect(Meteor.user).toHaveBeenCalled()
                expect(Roles.userIsInRole).toHaveBeenCalled()

        it "looks up a patient using an EMMI.Client", ->
            spyOn Meteor, "user"
                .and.returnValue tech
            spyOn Roles, "userIsInRole"
                .and.returnValue true
            clientStub = getPatient: jasmine.createSpy("getPatient").and.returnValue emmi_result
            spyOn EMMI, "Client"
                .and.callFake -> clientStub
            Meteor.call "lookupPatient", "1234", (err, resp) ->
                expect(err).toBeNull()
                expect(clientStub.getPatient).toHaveBeenCalledWith "1234"