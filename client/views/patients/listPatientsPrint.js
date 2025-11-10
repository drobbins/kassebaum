import { Template } from 'meteor/templating';
import { Session } from 'meteor/session';
import { $ } from 'meteor/jquery';

import Patients from '../../../common/patients';

Template.listPatientsPrint.helpers({
    patients() {
        const ids = Session.get('selectedPatientsList') || [];
        return Patients.find({ _id: { $in: ids } });
    },
    title() {
        return Session.get('listPatientsPrint.title');
    }
});

Template.listPatientsPrint.events({
    'keyup input[name=title]'(event) {
        Session.set('listPatientsPrint.title', $(event.target).val());
    }
});
