Template.instancesOfProcurementForm.events
    "click .add-instance-of-procurement": -> @instancesOfProcurementCollection.insert {}

Template.instancesOfProcurementForm.helpers
    "iop": -> @instancesOfProcurementCollection.find()

Template.instancesOfProcurementForm.created = ->
    collection = @data.instancesOfProcurementCollection = new Meteor.Collection null
    collection.insert instance for instance in @data.instancesOfProcurement

Template.instanceOfProcurementForm.events
    "click .remove-instance-of-procurement": (e, template) ->
        collection = Template.parentData(2).instancesOfProcurementCollection
        collection.remove @