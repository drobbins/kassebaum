import { Template } from 'meteor/templating';
import { Meteor } from 'meteor/meteor';
import { $ } from 'meteor/jquery';

import { addAlert } from '../../helpers/alerts';
import { Logs } from 'meteor/robbinsd:simplelog';

Template.addApiToken.events({
    'click #addApiTokenButton'(event, template) {
        event.preventDefault();
        const system = template.$('[name=system]').val();
        console.log(`Adding token for ${system}`);
        Meteor.call('apiToken.create', { system }, (error) => {
            if (error) {
                addAlert(error.message, 'danger');
            } else {
                const message = `Successfully added token for ${system}.`;
                addAlert(message, 'success');
                Logs.add('success', message);
            }
            template.$('[name=system]').val('');
        });
    }
});
