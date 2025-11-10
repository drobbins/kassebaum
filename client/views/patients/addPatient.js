import { Template } from 'meteor/templating';
import { Session } from 'meteor/session';
import { Meteor } from 'meteor/meteor';
import { Random } from 'meteor/random';
import { $ } from 'meteor/jquery';

import { addAlert } from '../../helpers/alerts';
import { Logs } from 'meteor/robbinsd:simplelog';
import { initializeDatePickers } from '../../helpers/initializeDatePickers';

const EMMIDateFormat = 'YYYYMMDD';

const lookupPatientFromClient = () => {
    const mrn = $('[name=mrn]').val();
    Meteor.call('lookupPatient', mrn, (error, response) => {
        if (error) {
            addAlert(error.message, 'danger');
            Logs.add('error', error.message);
        } else if (response) {
            $('[name=firstName]').val(response.firstname);
            $('[name=middleName]').val(response.middlename.slice(0, 1));
            $('[name=lastName]').val(response.lastname);
            if (typeof moment !== 'undefined') {
                $('[name=dateOfBirth]').datepicker('update', moment(response.birthDate, EMMIDateFormat).toDate());
            }
        }
    });
};

Template.addPatient.events({
    'submit form'(event) {
        event.preventDefault();
        const form = event.target;
        const patient = {
            firstName: $(form).find('[name=firstName]').val(),
            lastName: $(form).find('[name=lastName]').val(),
            middleName: $(form).find('[name=middleName]').val(),
            dateOfBirth: $(form).find('[name=dateOfBirth]').datepicker('getDate')?.getTime(),
            mrn: $(form).find('[name=mrn]').val(),
            externalMrn: Session.get('externalMrn')
        };
        const collection = this.instancesOfProcurementCollection || Template.instance().data.instancesOfProcurementCollection;
        patient.instancesOfProcurement = collection ? collection.find().fetch() : [];
        Meteor.call('addPatient', patient, (error, shortId) => {
            if (error) {
                addAlert(error.message, 'danger');
                Logs.add('error', error.message);
            } else {
                const message = `Successfully added patient. Patient code: ${shortId}`;
                addAlert(message, 'success');
                Logs.add('success', message);
            }
        });
    },
    'click .add-surgical-pathology-number'() {
        const instancesOfProcurement = Session.get('instancesOfProcurement') || [];
        instancesOfProcurement.push({ id: Random.id() });
        Session.set('instancesOfProcurement', instancesOfProcurement);
    },
    'click .lookup-patient': lookupPatientFromClient,
    'keypress [name=mrn]'(event) {
        if (event.keyCode === 13) {
            event.preventDefault();
            lookupPatientFromClient();
        }
    },
    'click .new-patient'() {
        $('form[name=addPatient]')[0].reset();
    }
});

Template.addPatient.helpers({
    disabledIfNonUabMrn() {
        return Session.get('externalMrn') ? 'disabled' : '';
    }
});

Template.addPatient.onRendered(() => {
    initializeDatePickers();
});
