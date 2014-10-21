tech =
    username: "kallie"
    password: "password"
    name: "Kallie Emil"

admin =
    username: "admin"
    password: "password"
    name: "Admin"

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
