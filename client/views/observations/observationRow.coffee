Template.observationRow.helpers
    relativeTimeAdded: -> moment(@submitted).fromNow()
    timeAdded: -> moment(@submitted)
    file: -> ObservationFiles.findOne "metadata.observationId": @_id
