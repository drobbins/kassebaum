import { Meteor } from 'meteor/meteor';
import { Roles } from 'meteor/alanning:roles';

Meteor.methods({
    addDefaultRoles() {
        const defaultRoles = ['admin', 'procurement-tech', 'tech'];
        defaultRoles.forEach((role) => {
            Roles.createRole(role, { unlessExists: true });
        });
    }
});
