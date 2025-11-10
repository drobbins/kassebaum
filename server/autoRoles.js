import { Meteor } from 'meteor/meteor';
import { Accounts } from 'meteor/accounts-base';

const automaticRoles = Meteor.settings?.automaticRoles;

if (Array.isArray(automaticRoles) && automaticRoles.length > 0) {
    Accounts.onCreateUser((options, user) => {
        if (options.profile) {
            user.profile = options.profile;
        }

        if (!user.profile.name) {
            user.profile.name = user.username;
        }

        user.roles = automaticRoles;
        return user;
    });
}
