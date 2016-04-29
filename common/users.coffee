Meteor.methods
    "changeUserPassword": (user, password) ->
        if not Roles.userIsInRole @userId, ["admin"] then throw new Meteor.Error 401, "You are not authorized to perform that action"
        if not @isSimulation then Accounts.setPassword user, password
