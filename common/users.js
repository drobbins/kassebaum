import { Meteor } from 'meteor/meteor';
import { Accounts } from 'meteor/accounts-base';
import { Roles } from 'meteor/alanning:roles';

Meteor.methods({
    changeUserPassword(user, password) {
        if (!Roles.userIsInRole(this.userId, ['admin'])) {
            throw new Meteor.Error(401, 'You are not authorized to perform that action');
        }

        if (!this.isSimulation) {
            Accounts.setPassword(user, password);
        }
    }
});
