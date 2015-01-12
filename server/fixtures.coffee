if process.env.NODE_ENV is "development"

    now = new Date().getTime()
    hour = 1000 * 60 * 60 # ms * sec * min
    now = now - 10 * hour

    if Meteor.users.find().count() is 0
        # Create Users
        kallieId = Accounts.createUser
            profile:
                name: "Kallie Emil"
            username: "kallie"
            password: "password"
        Roles.addUsersToRoles kallieId, ["tech"]

        isaId = Accounts.createUser
            profile:
                name: "Isa Tufayl"
            username: "isa"
            password: "password"
        Roles.addUsersToRoles isaId, ["tech"]

        adminId = Accounts.createUser #Create admin login
            profile:
                name: "Admin"
            username: "admin"
            password: "password"
        Roles.addUsersToRoles adminId, ["admin"]

        techsalId = Accounts.createUser #Create techsal login
            profile:
                name: "Tech Sal"
            username: "techsal"
            password: "password"
        Roles.addUsersToRoles techsalId, ["tech"]
    else
        kallieId = Meteor.users.findOne({"username":"kallie"})._id
        adminId = Meteor.users.findOne({"username":"admin"})._id
        isaId = Meteor.users.findOne({"username":"isa"})._id
        techsalId = Meteor.users.findOne({"username":"techsal"})._id

    Meteor.methods
        "/fixtures/loadpatients": -> Patients.insert patient for patient in patients
        "/fixtures/reloadpatients": ->
            Patients.remove {}
            Patients.insert patient for patient in patients
        "/fixtures/reloadlogs": (count) -> Logs.loadFixture(count)

    patients = [
        {
            firstName: "Makena"
            lastName: "Asaph"
            mrn: "1234567890"
            surgicalPathologyNumbers: [
                {
                    surgicalPathologyNumber: "0192837465"
                    date: now - 2 * hour
                }
                {
                    surgicalPathologyNumber: "0912873456"
                    date: now - 26 * hour
                }
            ]
            shortId: "abcdEF"
            added: now + 7 * hour
            addedBy: isaId
        }
        {
            firstName: "Lunete"
            lastName: "Margarita"
            middleName: "P"
            mrn: "1357902468"
            surgicalPathologyNumbers: [
                {
                    surgicalPathologyNumber: "0192867465"
                    date: now - 2 * hour
                }
                {
                    surgicalPathologyNumber: "6912873456"
                    date: now - 26 * hour
                }
            ]
            shortId: "EFdsdw"
            added: now
            addedBy: isaId
            value: "p.R521K"
        }
        {
            firstName: "Yasmeen"
            lastName: "Capucine"
            mrn: "1234567891"
            surgicalPathologyNumbers: [
                {
                    surgicalPathologyNumber: "1094859925"
                    date: now - 2 * hour
                }
                {
                    surgicalPathologyNumber: "1993848458"
                    date: now - 26 * hour
                }
            ]
            shortId: "cbd1rC"
            added: now
            addedBy: kallieId
        }

    ]

    if Patients.find().count() is 0 then Meteor.call "/fixtures/loadpatients"