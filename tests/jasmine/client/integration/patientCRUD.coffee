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

    it "Adding patients with Patients.insert is forbidden", (done) ->
        Patients.insert patient, (err) ->
            expect(err.error).toBe 403
            done()
