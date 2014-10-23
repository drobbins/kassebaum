Template.registerHelper "authorizedUser", ->
    Roles.userIsInRole Meteor.user(), ["admin", "tech"]
