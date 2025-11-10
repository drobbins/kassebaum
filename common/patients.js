import { Mongo } from 'meteor/mongo';

import { authorizedUser } from './kassebaum';

export const Patients = new Mongo.Collection('patients');

Patients.allow({
    update(userId) {
        return authorizedUser(userId);
    },
    remove(userId) {
        return authorizedUser(userId);
    }
});

Patients.helpers({
    fullName() {
        return `${this.firstName} ${this.lastName}`;
    }
});

export default Patients;

if (typeof globalThis !== 'undefined') {
    globalThis.Patients = Patients;
}
