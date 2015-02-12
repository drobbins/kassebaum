Template.nonUabMrnHelpText.events
    "click .toggle-uab-mrn": ->
        Session.set "nonUabMrn", not Session.get "nonUabMrn"

Template.nonUabMrnHelpText.rendered = -> Session.set "nonUabMrn", false