Template.listPatients.helpers
    patientCount: -> Patients.find().count()
    patients: ->
        filter = Session.get "patientFilter"
        if filter
            Patients.find filter
        else
            Patients.find()

Template.listPatients.events
    "keyup [name=search]": (e) ->
        value = $(e.target).val()
        filter = $or: [
            { firstName: $regex: value }
            { lastName: $regex: value }
            { mrn: $regex: value }
            { shortId: $regex: value }
        ]
        Session.set "patientFilter", filter
