import { Meteor } from 'meteor/meteor';
import { Tabular } from 'meteor/aldeed:tabular';

import Patients from './patients';
import apiTokens from './api-tokens';
import { Logs } from 'meteor/robbinsd:simplelog';

const TabularTables = {};
let TemplateRef;
let SessionRef;

if (Meteor.isClient) {
    ({ Template: TemplateRef } = require('meteor/templating'));
    ({ Session: SessionRef } = require('meteor/session'));

    TemplateRef.registerHelper('TabularTables', TabularTables);
}

const formatWithSession = (value, sessionKey) => {
    if (!SessionRef || typeof moment === 'undefined') {
        return value;
    }

    return moment(value).format(SessionRef.get(sessionKey));
};

TabularTables.LogEntries = new Tabular.Table({
    name: 'LogEntries',
    collection: Logs.collection,
    columns: [
        {
            data: 'timestamp',
            title: 'Time',
            render(val) {
                return formatWithSession(val, 'momentLogDateFormat');
            }
        },
        { data: 'level', title: 'Level' },
        { data: 'data.user.username', title: 'User' },
        { data: 'message', title: 'Message' }
    ],
    extraFields: ['data'],
    order: [[0, 'desc']]
});

TabularTables.Patients = new Tabular.Table({
    name: 'Patients',
    collection: Patients,
    responsive: true,
    autoWidth: false,
    columns: [
        {
            tmpl: Meteor.isClient && TemplateRef && TemplateRef.patientListSelector,
            className: 'text-center',
            width: '1px'
        },
        { data: 'shortId', title: 'Short ID', width: '100px' },
        { data: 'mrn', title: 'MRN' },
        { data: 'firstName', title: 'First Name' },
        { data: 'lastName', title: 'Last Name' },
        {
            tmpl: Meteor.isClient && TemplateRef && TemplateRef.instanceOfProcurementDates,
            title: 'Procurement Dates'
        },
        {
            tmpl: Meteor.isClient && TemplateRef && TemplateRef.patientRowButtons,
            className: 'text-center'
        }
    ],
    extraFields: ['instancesOfProcurement', 'firstName', 'lastName', 'deleted'],
    order: [[1, 'desc']]
});

TabularTables.APITokens = new Tabular.Table({
    name: 'APITokens',
    collection: apiTokens,
    columns: [
        {
            data: 'added',
            title: 'Date Added',
            render(val) {
                return formatWithSession(val, 'momentLogDateFormat');
            }
        },
        { data: 'system', title: 'System' },
        { data: 'token', title: 'Token' },
        { data: 'revoked', title: 'Revoked?' },
        {
            tmpl: Meteor.isClient && TemplateRef && TemplateRef.apiTokenRowButtons,
            className: 'text-center'
        }
    ]
});

export default TabularTables;
