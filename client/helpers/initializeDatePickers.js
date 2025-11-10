import { $ } from 'meteor/jquery';
import { Session } from 'meteor/session';

export const initializeDatePickers = () => {
    $('.datepicker')
        .datepicker({
            format: Session.get('datepickerDateFormat'),
            todayBtn: 'linked',
            todayHighlight: true
        })
        .each((i, el) => {
            const $el = $(el);
            const val = $el.val();

            if (val && !val.includes('/')) {
                $el.datepicker('update', new Date(parseInt(val, 10)));
            }
        });
};

if (typeof window !== 'undefined') {
    window.initializeDatePickers = initializeDatePickers;
}

export default initializeDatePickers;
