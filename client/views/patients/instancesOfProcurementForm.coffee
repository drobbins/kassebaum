Template.instancesOfProcurementForm.events
    "click .add-instance-of-procurement": -> @instancesOfProcurementCollection.insert {}

Template.instancesOfProcurementForm.helpers
    "iop": -> @instancesOfProcurementCollection.find()

Template.instancesOfProcurementForm.created = ->
    collection = @data.instancesOfProcurementCollection = new Meteor.Collection null
    if @data.instancesOfProcurement
        collection.insert instance for instance in @data.instancesOfProcurement
    else
        collection.insert date: Date.now()

Template.instanceOfProcurementForm.events
    "click .remove-instance-of-procurement": (e, template) ->
        collection = Template.parentData(2).instancesOfProcurementCollection
        collection.remove @
    "change input": (e, t) ->
        collection = Template.parentData(2).instancesOfProcurementCollection
        id = t.$("[name=_id]").val()
        instanceOfProcurementProperties =
            date: t.$("[name=date]").datepicker("getDate").getTime()
            surgicalPathologyNumber: t.$("[name=surgicalPathologyNumber]").val()
            otherNumber: t.$("[name=otherNumber]").val()
        collection.update id, {$set: instanceOfProcurementProperties}
        