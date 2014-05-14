if Patients.find().count() is 0
    now = new Date().getTime()
    hour = 1000 * 60 * 60 # ms * sec * min
    now = now - 10 * hour

    # Users
    kallieId = Meteor.users.insert
        profile:
            name: "Kallie Emil"
        roles: ["physician"]
    kallie = Meteor.users.findOne kallieId

    isaId = Meteor.users.insert
        profile:
            name: "Isa Tufayl"
        roles: ["physician"]
    isa = Meteor.users.findOne isaId

    adminId = Accounts.createUser #Create admin login
        profile:
            name: "Admin"
        roles: ["admin"]
        username: "admin"
        password: "password"
    Roles.addUsersToRoles adminId, ["admin"]


    makenaId = Patients.insert
        firstName: "Makena"
        lastName: "Asaph"
        mrn: "1234567890"
        added: now + 7 * hour
        addedBy: isa._id
    Observations.insert
        patientId: makenaId
        userId: kallie._id
        user: kallie.profile.name
        submitted: now + 5 * hour
        type: "Weight"
        value: "146 lb"
    Observations.insert
        patientId: makenaId
        userId: kallie._id
        user: kallie.profile.name
        submitted: now + 5 * hour
        type: "Height"
        value: "68 in"
    Observations.insert
        patientId: makenaId
        userId: isa._id
        user: isa.profile.name
        submitted: now + 1 * hour
        type: "HER2"
        value: "Positive"
    Observations.insert
        patientId: makenaId
        userId: isa._id
        user: isa.profile.name
        submitted: now + 1 * hour
        type: "rs401681"
        value: "CT"
    Observations.insert
        patientId: makenaId
        userId: isa._id
        user: isa.profile.name
        submitted: now + 1 * hour
        type: "EGFR"
        value: "p.R521K"


    luneteId = Patients.insert
        firstName: "Lunete"
        lastName: "Margarita"
        mrn: "1357902468"
        added: now
        addedBy: isa._id
    Observations.insert
        patientId: luneteId
        userId: kallie._id
        user: kallie.profile.name
        submitted: now + 5 * hour
        type: "Height"
        value: "68 in"
    Observations.insert
        patientId: luneteId
        userId: isa._id
        user: isa.profile.name
        submitted: now + 1 * hour
        type: "HER2"
        value: "Positive"
    Observations.insert
        patientId: luneteId
        userId: isa._id
        user: isa.profile.name
        submitted: now + 1 * hour
        type: "rs401681"
        value: "CT"
    Observations.insert
        patientId: luneteId
        userId: isa._id
        user: isa.profile.name
        submitted: now + 1 * hour
        type: "EGFR"
        value: "p.R521K"

    yasmeenId = Patients.insert
        firstName: "Yasmeen"
        lastName: "Capucine"
        mrn: "1234567891"
        added: now
        addedBy: kallie._id
    Observations.insert
        patientId: yasmeenId
        userId: kallie._id
        user: kallie.profile.name
        submitted: now + 5 * hour
        type: "Height"
        value: "68 in"
    Observations.insert
        patientId: yasmeenId
        userId: isa._id
        user: isa.profile.name
        submitted: now + 1 * hour
        type: "HER2"
        value: "Positive"
    Observations.insert
        patientId: yasmeenId
        userId: isa._id
        user: isa.profile.name
        submitted: now + 1 * hour
        type: "rs401681"
        value: "CT"
    Observations.insert
        patientId: yasmeenId
        userId: isa._id
        submitted: now + 1 * hour
        type: "EGFR"
        value: "p.R521K"
