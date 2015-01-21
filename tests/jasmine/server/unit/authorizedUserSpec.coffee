describe "authorizedUser utility function", ->

    it "returns false if called without a userId", ->
        expect(authorizedUser(null)).toBeFalsy()

    it "returns false if the user does not have admin role", ->
        userId = 1234
        spyOn Roles, "userIsInRole"
            .and.returnValue false
        expect(authorizedUser(userId)).toBeFalsy()
        expect(Roles.userIsInRole).toHaveBeenCalledWith userId, ["admin"]

    it "returns true if the user does have admin role", ->
        userId = 1234
        spyOn Roles, "userIsInRole"
            .and.returnValue true
        expect(authorizedUser(userId)).toBeTruthy()
        expect(Roles.userIsInRole).toHaveBeenCalledWith userId, ["admin"]