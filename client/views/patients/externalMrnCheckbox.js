import { Template } from 'meteor/templating';
import { Session } from 'meteor/session';

Template.externalMrnCheckbox.events({
    'click .toggle-uab-mrn'() {
        Session.set('externalMrn', !Session.get('externalMrn'));
    }
});

Template.externalMrnCheckbox.onRendered(() => {
    Session.set('externalMrn', false);
});
