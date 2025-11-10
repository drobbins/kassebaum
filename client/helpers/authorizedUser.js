import { Template } from 'meteor/templating';
import { Meteor } from 'meteor/meteor';
import { Roles } from 'meteor/alanning:roles';

Template.registerHelper('authorizedUser', () =>
    Roles.userIsInRole(Meteor.user(), ['admin', 'tech', 'procurement-tech'])
);
