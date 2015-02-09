Template.instancesOfProcurementForm.events
    "click .add-instance-of-procurement": -> @instancesOfProcurementCollection.insert {}

Template.instancesOfProcurementForm.helpers
    "iop": -> @instancesOfProcurementCollection.find()

Template.instancesOfProcurementForm.created = ->
    collection = @data.instancesOfProcurementCollection = new Meteor.Collection null
    collection.insert instance for instance in @data.instancesOfProcurement

Template.instanceOfProcurementForm.events
    "click .remove-instance-of-procurement": (e, template) ->
        collection = template.view.parentView.parentView.parentView.templateInstance().data.instancesOfProcurementCollection
        collection.remove @