import { Template } from 'meteor/templating';
import { Session } from 'meteor/session';
import { Router } from 'meteor/iron:router';
import { $ } from 'meteor/jquery';

import Patients from '../../../common/patients';
import { addAlert } from '../../helpers/alerts';
import { Logs } from 'meteor/robbinsd:simplelog';
import { initializeDatePickers } from '../../helpers/initializeDatePickers';

Template.editPatient.events({
    'submit form'(event) {
        event.preventDefault();
        const currentPatientId = this._id;
        const form = event.target;
        const patientProperties = {
            firstName: $(form).find('[name=firstName]').val(),
            lastName: $(form).find('[name=lastName]').val(),
            middleName: $(form).find('[name=middleName]').val(),
            dateOfBirth: $(form).find('[name=dateOfBirth]').datepicker('getDate')?.getTime(),
            mrn: $(form).find('[name=mrn]').val(),
            externalMrn: Session.get('externalMrn')
        };
        const collection = this.instancesOfProcurementCollection || Template.instance().data.instancesOfProcurementCollection;
        patientProperties.instancesOfProcurement = collection ? collection.find().fetch() : [];

        Patients.update(currentPatientId, { $set: patientProperties }, (error) => {
            if (error) {
                addAlert(error.message, 'danger');
                Logs.add('error', `Unable to edit patient ${currentPatientId}: ${error.message}`);
            }
            Router.go('listPatients');
        });
    },
    'click .delete'(event) {
        event.preventDefault();
        if (confirm('Delete this patient?')) {
            const currentPatientId = this._id;
            Patients.remove(currentPatientId);
            Router.go('listPatients');
        }
    }
});

Template.editPatient.onRendered(() => {
    initializeDatePickers();
});
