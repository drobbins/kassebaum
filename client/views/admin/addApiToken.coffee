Template.addApiToken.events
    "click #addApiTokenButton": (e, t) ->
        e.preventDefault()
        system = t.$("[name=system]").val()
        console.log "Adding token for #{system}"
        Meteor.call 'apiToken.create', {system: system}, (error) ->
            if error
                Alert.add error.message, "danger"
                # Logs.add "error", error.message
            else
                message = "Successfully added token for #{system}."
                Alert.add message, "success"
                Logs.add "success", message
            t.$("[name=system]").val("")
