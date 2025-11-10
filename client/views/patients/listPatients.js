import { Template } from 'meteor/templating';
import { Session } from 'meteor/session';
import { $ } from 'meteor/jquery';

import { initializeDatePickers } from '../../helpers/initializeDatePickers';

Template.listPatients.onRendered(function onRendered() {
    initializeDatePickers();
    const startDate = Session.get('startDate');
    const endDate = Session.get('endDate');

    if (startDate) {
        $('[name=startDate]').datepicker('update', new Date(startDate));
    }

    if (endDate) {
        $('[name=endDate]').datepicker('update', new Date(endDate));
    }
});

Template.listPatients.helpers({
    tabularSelector() {
        const startDate = Session.get('startDate');
        const endDate = Session.get('endDate');
        const dateQuery = {
            deleted: { $exists: false },
            instancesOfProcurement: {
                $elemMatch: {
                    $and: []
                }
            }
        };

        if (startDate) {
            dateQuery.instancesOfProcurement.$elemMatch.$and.push({ date: { $gte: startDate } });
        }

        if (endDate) {
            dateQuery.instancesOfProcurement.$elemMatch.$and.push({ date: { $lte: endDate } });
        }

        if (startDate || endDate) {
            return dateQuery;
        }

        return { deleted: { $exists: false } };
    },
    selectedPatientsList() {
        return (Session.get('selectedPatientsList') || []).length > 0;
    }
});

Template.listPatients.events({
    'change input[name=startDate], input[name=endDate]'() {
        const start = $('[name=startDate]').datepicker('getDate');
        Session.set('startDate', start ? start.getTime() : undefined);
        const end = $('[name=endDate]').datepicker('getDate');
        if (end && typeof moment !== 'undefined') {
            Session.set('endDate', moment(end).endOf('day').valueOf());
        } else {
            Session.set('endDate', undefined);
        }
    },
    'click #clearDateFilters'() {
        $('[name=startDate]').datepicker('clearDates');
        $('[name=endDate]').datepicker('clearDates');
        Session.set('endDate', undefined);
        Session.set('startDate', undefined);
    },
    'click button#clearSelection'() {
        Session.set('selectedPatientsList', []);
    }
});
