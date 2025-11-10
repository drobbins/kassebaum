import { Template } from 'meteor/templating';
import { Meteor } from 'meteor/meteor';

import { getHumanizedDuration } from '../../helpers/getHumanizedDuration';
import { formatDateString } from '../../helpers/formatDateString';

Template.instanceOfProcurementRow.helpers({
    ageAtCollectionString(dateOfBirth) {
        return getHumanizedDuration(dateOfBirth, this.date);
    }
});

Template.viewPatient.helpers({
    dateOfBirthString() {
        return formatDateString.call(this, this.dateOfBirth);
    }
});

Template.viewPatient.events({
    'click #restorePatientButton'() {
        Meteor.call('restorePatient', this._id);
    },
    'click #deletePatientButton'() {
        Meteor.call('deletePatient', this._id);
    }
});
