import { Template } from 'meteor/templating';
import { Session } from 'meteor/session';

export const formatDateString = function formatDateString(date) {
    const value = date ?? this?.date;
    if (value && typeof moment !== 'undefined') {
        return moment(value).format(Session.get('momentDateFormat'));
    }
    return value;
};

Template.registerHelper('formatDateString', formatDateString);

if (typeof window !== 'undefined') {
    window.formatDateString = formatDateString;
}

export default formatDateString;
