import { Template } from 'meteor/templating';
import { Mongo } from 'meteor/mongo';

import { initializeDatePickers } from '../../helpers/initializeDatePickers';

Template.instancesOfProcurementForm.events({
    'click .add-instance-of-procurement'(event, template) {
        template.data.instancesOfProcurementCollection.insert({});
    },
    DOMNodeInserted(event, template) {
        initializeDatePickers();
    }
});

Template.instancesOfProcurementForm.helpers({
    iop() {
        return Template.instance().data.instancesOfProcurementCollection.find();
    }
});

Template.instancesOfProcurementForm.onCreated(function onCreated() {
    const collection = new Mongo.Collection(null);
    this.data.instancesOfProcurementCollection = collection;

    if (this.data.instancesOfProcurement) {
        this.data.instancesOfProcurement.forEach((instance) => collection.insert(instance));
    } else {
        const defaultDate = typeof moment !== 'undefined'
            ? moment(Date.now()).startOf('day').valueOf()
            : Date.now();
        collection.insert({ date: defaultDate });
    }
});

Template.instanceOfProcurementForm.events({
    'click .remove-instance-of-procurement'() {
        const collection = Template.parentData(2).instancesOfProcurementCollection;
        collection.remove(this._id);
    },
    'change input'(event, template) {
        const collection = Template.parentData(2).instancesOfProcurementCollection;
        const id = template.$('[name=_id]').val();
        const instanceOfProcurementProperties = {
            date: template.$('[name=date]').datepicker('getDate')?.getTime(),
            surgicalPathologyNumber: template.$('[name=surgicalPathologyNumber]').val(),
            otherNumber: template.$('[name=otherNumber]').val()
        };
        collection.update(id, { $set: instanceOfProcurementProperties });
    }
});

Template.instancesOfProcurementForm.onRendered(() => {
    initializeDatePickers();
});
