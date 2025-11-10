import { Template } from 'meteor/templating';

import { Logs } from './simplelog';

Template.simpleLogs.helpers({
    logItems() {
        return Logs.collection.find({}, { sort: { timestamp: -1 } });
    }
});

Template.logItem.helpers({
    raw() {
        return JSON.stringify(this, null, 2);
    },
    timeString() {
        return new Date(this.timestamp).toLocaleString();
    }
});
