import { Mongo } from 'meteor/mongo';
import { Random } from 'meteor/random';
import { Meteor } from 'meteor/meteor';
import { Roles } from 'meteor/alanning:roles';
import { _ } from 'meteor/underscore';

import { authorizedUser } from './kassebaum';

export const apiTokens = new Mongo.Collection('api-tokens');

function generateUniqueApiToken() {
    let token;
    do {
        token = Random.id(64);
    } while (apiTokens.findOne({ token }));
    return token;
}

apiTokens.allow({
    remove(userId) {
        return authorizedUser(userId);
    }
});

Meteor.methods({
    'apiToken.create'(tokenAttributes) {
        if (!this.userId || !Roles.userIsInRole(this.userId, ['admin'])) {
            throw new Meteor.Error(401, 'You are not authorized to add api tokens.');
        }

        const token = generateUniqueApiToken();

        const apiToken = _.extend({}, tokenAttributes, {
            token,
            added: new Date().getTime(),
            addedBy: this.userId
        });
        apiTokens.insert(apiToken);
    },
    'apiToken.revoke'(token) {
        if (!this.userId || !Roles.userIsInRole(this.userId, ['admin'])) {
            throw new Meteor.Error(401, 'You are not authorized to revoke api tokens.');
        }
        apiTokens.update({ token }, { $set: { revoked: true } });
    },
    'apiToken.confirm'(token) {
        if (!token) {
            return false;
        } else if (apiTokens.findOne({ token, revoked: { $ne: true } })) {
            return true;
        }
        return false;
    }
});

export default apiTokens;

if (typeof globalThis !== 'undefined') {
    globalThis.apiTokens = apiTokens;
}
