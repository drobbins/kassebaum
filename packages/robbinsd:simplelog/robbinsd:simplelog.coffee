# Write your package code here!
Logs =
    collection: new Meteor.Collection("logs")
    add: (level, msg, data) ->
        data = data or {}
        Logs.collection.insert
            message: msg
            level: level
            data: _.extend data,
                user: Meteor.user()
                url: Meteor.absoluteUrl()
                path: location.pathname
            timestamp: Date.now()
    list: (level) ->
        if level
            Logs.collection.find level: level
        else
            Logs.collection.find()

Logs.collection.allow
    insert: -> true

if Meteor.isClient
    Meteor.subscribe "logs"

if Meteor.isServer
    Meteor.publish "logs", -> Logs.collection.find()

