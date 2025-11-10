let AlertRef = typeof Alert !== 'undefined' ? Alert : null;

if (!AlertRef) {
    try {
        ({ Alert: AlertRef } = require('meteor/steeve:simple-bootstrap3-alerts'));
    } catch (error) {
        AlertRef = null;
    }
}

export const addAlert = (message, type) => {
    if (AlertRef && typeof AlertRef.add === 'function') {
        AlertRef.add(message, type);
    }
};

export default addAlert;
