import { Template } from 'meteor/templating';
import { Session } from 'meteor/session';
import { _ } from 'meteor/underscore';

Template.patientListSelector.events({
    'change input[type=checkbox]'(event) {
        let selectedPatientsList = Session.get('selectedPatientsList') || [];
        if (event.target.checked) {
            selectedPatientsList.push(this._id);
        } else {
            selectedPatientsList = _.without(selectedPatientsList, this._id);
        }
        Session.set('selectedPatientsList', selectedPatientsList);
    }
});

Template.patientListSelector.helpers({
    isChecked() {
        return _.contains(Session.get('selectedPatientsList') || [], this._id);
    }
});
