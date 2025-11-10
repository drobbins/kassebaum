import { Meteor } from 'meteor/meteor';
import { Random } from 'meteor/random';
import { Roles } from 'meteor/alanning:roles';
import { _ } from 'meteor/underscore';

import Patients from '../common/patients';
import { hasAttributes, toProperCase } from '../common/kassebaum';
import { EMMIClientSettings } from './EMMIClientSettings';

const mergeInstancesOfProcurement = (oldNumbers = [], newNumbers = []) => {
    const instancesOfProcurement = [...oldNumbers, ...newNumbers];
    const deduped = {};

    instancesOfProcurement.forEach((value) => {
        deduped[JSON.stringify(value)] = value;
    });

    return Object.values(deduped);
};

const generateUniqueShortId = () => {
    let shortId = Random.id(6).toUpperCase();

    while (shortId.includes('0') || Patients.findOne({ shortId })) {
        shortId = Random.id(6).toUpperCase();
    }

    return shortId;
};

const upsertPatient = (patientAttributes, addedBy) => {
    const patientWithSameMRN = Patients.findOne({
        $or: [
            { mrn: patientAttributes.mrn },
            { shortId: patientAttributes.mrn }
        ]
    });

    if (patientWithSameMRN) {
        const instancesOfProcurement = mergeInstancesOfProcurement(
            patientWithSameMRN.instancesOfProcurement || [],
            patientAttributes.instancesOfProcurement || []
        );

        Patients.update(patientWithSameMRN._id, {
            $set: { instancesOfProcurement }
        });

        return patientWithSameMRN.shortId;
    }

    if (!hasAttributes(patientAttributes, ['firstName', 'lastName', 'mrn'])) {
        throw new Meteor.Error(422, 'Patient first name, last name, and MRN are required');
    }

    const shortId = generateUniqueShortId(patientAttributes.mrn);
    const patient = _.extend({}, patientAttributes, {
        added: new Date().getTime(),
        addedBy,
        shortId
    });

    Patients.insert(patient);

    return shortId;
};

Meteor.methods({
    addPatient(patientAttributes) {
        if (!this.userId) {
            throw new Meteor.Error(401, 'You need to log in to add patients');
        }

        if (!Roles.userIsInRole(this.userId, ['admin', 'tech', 'procurement-tech'])) {
            throw new Meteor.Error(401, 'You are not authorized to add patients');
        }

        return upsertPatient(patientAttributes, this.userId);
    },

    addPatientByAPI(patients, token) {
        const attemptToUpsertPatient = (patient) => {
            try {
                const result = upsertPatient(patient, token);
                return { status: 'success', shortId: result, original: patient };
            } catch (error) {
                return { status: 'error', error, original: patient };
            }
        };

        if (Array.isArray(patients)) {
            return patients.map(attemptToUpsertPatient);
        }

        return [attemptToUpsertPatient(patients)];
    },

    lookupPatient(mrn) {
        if (process.env.NODE_ENV === 'development' && process.env.MOCK_EMMI === 'true') {
            return {
                firstname: 'Barbra',
                lastname: 'Hsistest',
                middlename: 'Qualif',
                birthDate: '19830302'
            };
        }

        if (!Roles.userIsInRole(Meteor.user(), ['admin', 'tech', 'procurement-tech'])) {
            throw new Meteor.Error(401, 'You are not authorized to lookup patients');
        }

        const client = new EMMI.Client(EMMIClientSettings);
        const patient = client.getPatient(mrn).result;

        ['firstname', 'lastname'].forEach((property) => {
            patient[property] = toProperCase(patient[property]);
        });

        return patient;
    },

    deletePatient(_id) {
        if (!this.userId) {
            throw new Meteor.Error(401, 'You need to log in to delete patients');
        }

        if (!Roles.userIsInRole(this.userId, ['admin', 'tech', 'procurement-tech'])) {
            throw new Meteor.Error(401, 'You are not authorized to delete patients');
        }

        Patients.update(_id, { $set: { deleted: true } });
    },

    restorePatient(_id) {
        if (!this.userId) {
            throw new Meteor.Error(401, 'You need to log in to restore patients');
        }

        if (!Roles.userIsInRole(this.userId, ['admin', 'tech', 'procurement-tech'])) {
            throw new Meteor.Error(401, 'You are not authorized to restore patients');
        }

        Patients.update(_id, { $unset: { deleted: '' } });
    }
});

export { upsertPatient, generateUniqueShortId };
export default Patients;
