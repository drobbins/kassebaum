import { Meteor } from 'meteor/meteor';
import { check } from 'meteor/check';

import Patients from '../common/patients';
import { authorizedUser } from '../common/kassebaum';

Meteor.publish('patients', function publishPatients() {
    return authorizedUser(this.userId) ? Patients.find() : [];
});

Meteor.publish('patientById', function publishPatientById(id) {
    check(id, String);
    return authorizedUser(this.userId) ? Patients.find({ _id: id }) : [];
});

Meteor.publish('patientsById', function publishPatientsById(ids) {
    check(ids, [String]);
    return authorizedUser(this.userId) ? Patients.find({ _id: { $in: ids } }) : [];
});
