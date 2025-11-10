import { Accounts } from 'meteor/accounts-base';

Accounts.onCreateUser((options, user) => {
    if (options.profile) {
        user.profile = options.profile;
    }

    if (!user.profile.name) {
        user.profile.name = user.username;
    }

    return user;
});
