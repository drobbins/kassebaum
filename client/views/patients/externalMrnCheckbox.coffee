Template.externalMrnCheckbox.events
    "click .toggle-uab-mrn": ->
        Session.set "externalMrn", not Session.get "externalMrn"

Template.externalMrnCheckbox.rendered = -> Session.set "externalMrn", false