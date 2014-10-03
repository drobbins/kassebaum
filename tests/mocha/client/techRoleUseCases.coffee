if MochaWeb then MochaWeb.testOnly ->

        assert = chai.assert

        tech =
            username: "kallie"
            password: "password"
            name: "Kallie Emil"

        describe "Technicans", ->

            it "can log in", (done) ->
                Meteor.loginWithPassword tech.username, tech.password, ->
                    Meteor.flush() # Update the UI
                    try
                        assert.equal $("#login-dropdown-list a").text().trim(), "Kallie Emil"
                        done()
                    catch error
                        done(error)
