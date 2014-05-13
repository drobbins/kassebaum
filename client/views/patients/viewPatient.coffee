Template.viewPatient.helpers
    observations: -> Observations.find patientId: @_id
