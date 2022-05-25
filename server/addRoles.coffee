defaultRoles = ["admin", "procurement-tech", "tech"]
currentRoles = Roles.getAllRoles().map((role) -> return role._id)
_.difference(defaultRoles, currentRoles).forEach (role) ->
    Roles.createRole role
