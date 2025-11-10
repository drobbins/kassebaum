import { Meteor } from 'meteor/meteor';
import { Accounts } from 'meteor/accounts-base';
import { Roles } from 'meteor/alanning:roles';

import Patients from '../common/patients';
import { Logs } from 'meteor/robbinsd:simplelog';

if (process.env.NODE_ENV === 'development') {
    const hour = 1000 * 60 * 60;
    const day = hour * 24;
    const week = day * 7;
    const year = day * 365;
    let now = Date.now() - 10 * hour;

    let kallieId;
    let isaId;

    if (Meteor.users.find().count() === 0) {
        kallieId = Accounts.createUser({
            profile: { name: 'Kallie Emil' },
            username: 'kallie',
            password: 'password'
        });
        Roles.addUsersToRoles(kallieId, ['tech']);

        isaId = Accounts.createUser({
            profile: { name: 'Isa Tufayl' },
            username: 'isa',
            password: 'password'
        });
        Roles.addUsersToRoles(isaId, ['tech']);

        const adminId = Accounts.createUser({
            profile: { name: 'Admin' },
            username: 'admin',
            password: 'password'
        });
        Roles.addUsersToRoles(adminId, ['admin']);

        const techsalId = Accounts.createUser({
            profile: { name: 'Tech Sal' },
            username: 'techsal',
            password: 'password'
        });
        Roles.addUsersToRoles(techsalId, ['tech']);
    } else {
        kallieId = Meteor.users.findOne({ username: 'kallie' })?._id;
        isaId = Meteor.users.findOne({ username: 'isa' })?._id;
    }

    const patients = [
        {
            firstName: 'Makena',
            lastName: 'Asaph',
            mrn: '1234567890',
            dateOfBirth: 702280800000,
            instancesOfProcurement: [
                {
                    surgicalPathologyNumber: '0192837465',
                    date: now - (2 * year + 8 * week + 1 * day + 4 * hour)
                },
                {
                    otherNumber: '0912873456',
                    date: now - (2 * year + 6 * week + 1 * day + 4 * hour)
                }
            ],
            shortId: 'abcdEF',
            added: now + 7 * hour,
            addedBy: isaId
        },
        {
            firstName: 'Lunete',
            lastName: 'Margarita',
            middleName: 'P',
            mrn: '1357902468',
            dateOfBirth: -487623600000,
            instancesOfProcurement: [
                {
                    surgicalPathologyNumber: '0192867465',
                    date: now - (0 * year + 8 * week + 1 * day + 4 * hour)
                },
                {
                    otherNumber: '6912873456',
                    date: now - (8 * year + 8 * week + 1 * day + 4 * hour)
                }
            ],
            shortId: 'EFdsdw',
            added: now,
            addedBy: isaId,
            value: 'p.R521K'
        },
        {
            firstName: 'Yasmeen',
            lastName: 'Capucine',
            mrn: '1234567891',
            dateOfBirth: 171176400000,
            instancesOfProcurement: [
                {
                    surgicalPathologyNumber: '1094859925',
                    date: now - (2 * year + 5 * week + 1 * day + 4 * hour)
                },
                {
                    otherNumber: '1993848458',
                    date: now - (3 * year + 1 * week + 10 * day - 3 * hour)
                }
            ],
            shortId: 'cbd1rC',
            added: now,
            addedBy: kallieId
        }
    ];

    Meteor.methods({
        '/fixtures/loadpatients'() {
            patients.forEach((patient) => Patients.insert(patient));
        },
        '/fixtures/reloadpatients'() {
            Patients.remove({});
            patients.forEach((patient) => Patients.insert(patient));
        },
        '/fixtures/reloadlogs'(count) {
            Logs.loadFixture(count);
        },
        '/fixtures/removetestuser'(username) {
            Meteor.users.remove({ username });
        }
    });

    if (Patients.find().count() === 0) {
        Meteor.call('/fixtures/loadpatients');
    }
}
