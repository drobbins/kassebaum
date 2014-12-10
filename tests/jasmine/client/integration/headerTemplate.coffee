describe "Header template", ->

    it "should not show any nav buttons when not logged in", ->
        div = document.createElement "DIV"
        Blaze.render Template.header, div
        expect($(div).find(".navbar-nav").first().find("li a")[0]).not.toBeDefined()
        expect($(div).find(".navbar-right li a").length).toBe 2 # login link buttons are ok

    it "should be able to login as a tech", (done) ->
        Meteor.loginWithPassword "kallie", "password", (err) ->
            expect(err).toBeUndefined()
            done()

    it "should show Add Patient link to techs", ->
        div = document.createElement "DIV"
        Blaze.render Template.header, div
        expect($(div).find(".navbar-nav").first().find("li a")[0]).not.toBeDefined()
        expect(true).toBe false

    it "should be able to logout", (done) ->
        Meteor.logout done