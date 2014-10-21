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

        xit "exists", ->
            expect(Meteor.methodMap.patient).toBeDefined()

        xit "returns a 401 if not logged in.", ->
            spyOn Meteor, "user"
                .and.returnValue null
            Meteor.call "patient", {}, (err, resp) ->
                expect(err.message).toBe 401
                expect(Meteor.user).toHaveBeenCalled()
