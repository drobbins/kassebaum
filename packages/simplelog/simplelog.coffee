# Write your package code here!
Logs =
    collection: new Meteor.Collection("logs")
    add: (level, msg, data) ->
        data = data or {}
        Logs.collection.insert
            message: msg
            level: level
            data: _.extend data,
                user: _.pick Meteor.user(), "_id", "profile", "roles", "username"
                url: Meteor.absoluteUrl()
                path: location.pathname
            timestamp: Date.now()
    list: (level) ->
        if level
            Logs.collection.find level: level
        else
            Logs.collection.find()
    loadFixture: (count) ->
        Logs.collection.remove {}
        Logs.collection.insert logFixture() for num in [0..count]

Logs.collection.allow
    insert: -> true

if Meteor.isClient
    Meteor.subscribe "logs"

if Meteor.isServer
    Meteor.publish "logs", -> Logs.collection.find()

logFixture = ->
    fixture =
        "message": "loaded /patients"
        "level": "info"
        "data":
            "user":
                "_id": "hC7hosmkLAjpFbfFw"
                "profile":
                        "name": "Admin"
                    "username": "admin"
                "roles":
                    "admin"
                "createdAt": "2015-01-12T16:13:48.471Z"
                "services":
                    "password":
                        "bcrypt": "$2a$10$brFn2qyU7IvireQ00aNi8eO2r7X2F0ZkXZhVIjUfh9lF5fC4ke2Gi"
                    "resume":
                        "loginTokens":
                            "when": "2015-01-12T16:14:14.767Z"
                            "hashedToken": "0CaDtpp7SIhJpzvtBkwUQackwLCp9sxLsWTivev7v0g="
            "url": "http://localhost:3000/"
            "path": "/patients"
        "timestamp": Math.floor Math.random()*10000