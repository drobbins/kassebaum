import { Router } from 'meteor/iron:router';
import { Meteor } from 'meteor/meteor';
import { Roles } from 'meteor/alanning:roles';
import { Session } from 'meteor/session';
import { Logs } from 'meteor/robbinsd:simplelog';

import Patients from './patients';

let AlertRef = typeof Alert !== 'undefined' ? Alert : null;

if (!AlertRef) {
    try {
        ({ Alert: AlertRef } = require('meteor/steeve:simple-bootstrap3-alerts'));
    } catch (error) {
        AlertRef = null;
    }
}

Router.configure({
    layoutTemplate: 'layout',
    loadingTemplate: 'loading'
});

Router.route('home', {
    path: '/',
    template: 'home'
});

Router.route('admin', {
    path: '/admin',
    template: 'admin',
    onBeforeAction() {
        if (Meteor.loggingIn()) {
            this.render(this.loadingTemplate);
        } else if (!Roles.userIsInRole(Meteor.user(), ['admin'])) {
            this.redirect('/');
        }
        this.next();
    }
});

Router.route('logs', {
    path: '/logs',
    template: 'logs'
});

Router.route('listPatients', {
    path: '/patients',
    template: 'listPatients'
});

Router.route('listDeletedPatients', {
    path: '/patients/deleted',
    template: 'listDeletedPatients'
});

Router.route('listPatientsPrint', {
    path: '/patients/print',
    template: 'listPatientsPrint',
    waitOn() {
        return Meteor.subscribe('patientsById', Session.get('selectedPatientsList'));
    }
});

Router.route('addPatient', {
    path: '/patients/new',
    template: 'addPatient',
    data: () => ({})
});

Router.route('viewPatient', {
    path: '/patients/:_id',
    template: 'viewPatient',
    data() {
        return Patients.findOne(this.params._id);
    },
    waitOn() {
        return Meteor.subscribe('patientById', this.params._id);
    }
});

Router.route('editPatient', {
    path: '/patients/:_id/edit',
    template: 'editPatient',
    data() {
        return Patients.findOne(this.params._id);
    },
    waitOn() {
        return Meteor.subscribe('patientById', this.params._id);
    }
});

function requireLogin() {
    if (!Meteor.user()) {
        if (Meteor.loggingIn()) {
            this.render(this.loadingTemplate);
        } else {
            AlertRef && AlertRef.add('Please log in to proceed.', 'danger');
            this.redirect('/');
        }
    }
    this.next();
}

function requireAdmin() {
    if (!Roles.userIsInRole(Meteor.user(), ['admin'])) {
        AlertRef && AlertRef.add('You do not have sufficient privileges to proceed.', 'danger');
        this.redirect('/');
    }
    this.next();
}

function requireProcurementTech() {
    if (!Roles.userIsInRole(Meteor.user(), ['admin', 'procurement-tech'])) {
        AlertRef && AlertRef.add('You do not have sufficient privileges to proceed.', 'danger');
        this.redirect('/');
    }
    this.next();
}

function logNavigation() {
    if (Meteor.user()) {
        Logs.add('info', `loaded ${this.url}`);
    }
}

Router.onBeforeAction(requireAdmin, { only: ['logs', 'admin'] });
Router.onBeforeAction(requireProcurementTech, { except: ['home', 'accessDenied', 'modules', 'addPatient'] });
Router.onBeforeAction(requireLogin, { except: ['home', 'accessDenied', 'modules'] });
Router.onBeforeAction('loading');
Router.onAfterAction(logNavigation, { except: ['home', 'accessDenied', 'modules'] });
