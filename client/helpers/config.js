import { Accounts } from 'meteor/accounts-base';
import { Session } from 'meteor/session';

Accounts.ui.config({
    passwordSignupFields: 'USERNAME_ONLY'
});

Session.set('momentDateFormat', 'MM/DD/YYYY');
Session.set('datepickerDateFormat', 'mm/dd/yyyy');
Session.set('momentLogDateFormat', 'MM/DD/YYYY h:mm:ss a');
