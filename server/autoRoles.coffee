if Meteor.settings?.automaticRoles?.length > 0
    Accounts.onCreateUser (options, user) ->
        # Keep profile copy
        if options.profile then user.profile = options.profile
        # Add a default profile.name if necessary
        if not user.profile.name then user.profile.name = user.username
        # Add automatic roles
        user.roles = Meteor.settings.automaticRoles
        return user
