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