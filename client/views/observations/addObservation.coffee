Template.addObservation.events
    "submit form": (e, template) ->
        e.preventDefault()
        observation =
            type: $(e.target).find("[name=type]").val()
            value: $(e.target).find("[name=value]").val()
            patientId: template.data._id
        Meteor.call "observation", observation, (error, id) ->
            if error then Alerts.add error.message
            fileInput = $(e.target).find("[name=observationFile]").get(0)
            for file in fileInput.files
                do (file) ->
                    newFile = new FS.File file
                    newFile.metadata =
                        observationId: id
                        patientId: template.data._id
                    ObservationFiles.insert newFile, (error, fileObject) ->
                        if error then Alerts.add error.message
