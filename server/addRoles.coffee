Meteor.methods
  "addDefaultRoles": ->
    # create the default roles if they doesn't exist
    defaultRoles = ["admin", "procurement-tech", "tech"]
    defaultRoles.forEach (role) ->
      Roles.createRole role, {unlessExists: true}
