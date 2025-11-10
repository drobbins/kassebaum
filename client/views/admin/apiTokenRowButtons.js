import { Template } from 'meteor/templating';
import { Meteor } from 'meteor/meteor';

import { Logs } from 'meteor/robbinsd:simplelog';

Template.apiTokenRowButtons.events({
    'click #revokeTokenButton'() {
        Meteor.call('apiToken.revoke', this.token);
        Logs.add('success', `revoked token ${this.token}`);
    }
});
