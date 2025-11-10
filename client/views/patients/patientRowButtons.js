import { Template } from 'meteor/templating';
import { Meteor } from 'meteor/meteor';

Template.patientRowButtons.events({
    'click #restorePatientButton'() {
        Meteor.call('restorePatient', this._id);
    },
    'click #deletePatientButton'() {
        Meteor.call('deletePatient', this._id);
    }
});
