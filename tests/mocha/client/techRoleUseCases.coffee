if MochaWeb then MochaWeb.testOnly ->

        assert = chai.assert

        tech =
            username: "kallie"
            password: "password"
            name: "Kallie Emil"

        describe "Technicans", ->

            it "log in", (done) ->
                Meteor.loginWithPassword tech.username, tech.password, ->
                    Meteor.flush() # Update the UI
                    try
                        assert.equal $("#login-dropdown-list a").text().trim(), "Kallie Emil"
                        done()
                    catch error
                        done(error)

            describe "Add a Patient", (done) ->

                patient =
                    firstName: "Adolfus"
                    lastName: "McTest"
                    mrn: "123412341234"

                before (done) ->
                    Meteor.logout()
                    Meteor.loginWithPassword tech.username, tech.password, done

                after ->
                    Meteor.logout()

                it "Add Patient nav button is present.", ->
                    assert.equal $("a[href='/patients/new']").text(), "Add Patient"

                it "Clicking the Add Patient nav button navigates to the addPatient form.", ->
                    Router.go "addPatient" #Simulates click on $("a[href='/patients/new']").click()
                    Meteor.flush()
                    assert.equal $("form[name='addPatient']").length, 1
                    assert.equal Router.current().route.name, "addPatient"
