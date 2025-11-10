import { Meteor } from 'meteor/meteor';
import { Mongo } from 'meteor/mongo';
import { _ } from 'meteor/underscore';

const collection = new Mongo.Collection('logs');

const resolvePath = () => {
    if (typeof location !== 'undefined' && location.pathname) {
        return location.pathname;
    }
    return '';
};

export const Logs = {
    collection,
    add(level, msg, data = {}) {
        const user = Meteor.user();
        const payload = _.extend({}, data, {
            user: user && _.pick(user, '_id', 'profile', 'roles', 'username'),
            url: Meteor.absoluteUrl(),
            path: resolvePath()
        });

        collection.insert({
            message: msg,
            level,
            data: payload,
            timestamp: Date.now()
        });
    },
    list(level) {
        if (level) {
            return collection.find({ level });
        }
        return collection.find();
    },
    loadFixture(count) {
        collection.remove({});
        for (let index = 0; index <= count; index += 1) {
            collection.insert(logFixture());
        }
    }
};

collection.allow({
    insert() {
        return true;
    }
});

function logFixture() {
    return {
        message: 'loaded /patients',
        level: 'info',
        data: {
            user: {
                _id: 'hC7hosmkLAjpFbfFw',
                profile: {
                    name: 'Admin'
                },
                username: 'admin',
                roles: ['admin'],
                createdAt: '2015-01-12T16:13:48.471Z',
                services: {
                    password: {
                        bcrypt: '$2a$10$brFn2qyU7IvireQ00aNi8eO2r7X2F0ZkXZhVIjUfh9lF5fC4ke2Gi'
                    },
                    resume: {
                        loginTokens: {
                            when: '2015-01-12T16:14:14.767Z',
                            hashedToken: '0CaDtpp7SIhJpzvtBkwUQackwLCp9sxLsWTivev7v0g='
                        }
                    }
                }
            },
            url: 'http://localhost:3000/',
            path: '/patients'
        },
        timestamp: Math.floor(Math.random() * 10000)
    };
}

export default Logs;

if (typeof globalThis !== 'undefined') {
    globalThis.Logs = Logs;
}
