Template.viewPatient.helpers
    observations: -> Observations.find {patientId: @_id}, {sort: submitted: -1}
