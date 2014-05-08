Template.listPatients.helpers
    patientCount: -> Patients.find().count()
    patients: -> Patients.find()
