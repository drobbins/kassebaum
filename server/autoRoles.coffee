if Meteor.settings?.automaticRoles?.length > 0
    Accounts.onCreateUser (options, user) ->
        # Keep profile copy
        if options.profile then user.profile = options.profile
        # Add automatic roles
        user.roles = Meteor.settings.automaticRoles
        return user
