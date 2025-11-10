import { Roles } from 'meteor/alanning:roles';

export const hasAttributes = (object, attributes) => {
    if (!object) {
        return false;
    }

    return attributes.every((attribute) =>
        Object.prototype.hasOwnProperty.call(object, attribute) && Boolean(object[attribute])
    );
};

export const authorizedUser = (userId) =>
    Boolean(userId) && Roles.userIsInRole(userId, ['admin', 'procurement-tech']);

export const toProperCase = (value = '') =>
    value.replace(/\w\S*/g, (txt) =>
        txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
    );

export const Kassebaum = {
    hasAttributes,
    authorizedUser,
    toProperCase
};

if (typeof globalThis !== 'undefined') {
    globalThis.Kassebaum = Kassebaum;
}

export default Kassebaum;
